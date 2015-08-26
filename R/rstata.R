### The REPL, batch-processing and environment-handling logic for rstata

#Create a package-wide environment used to hold three things:
#    o) the dataset,
#    o) the symbol table for macro substitution, and
#    o) settings and parameters that commands can see or modify.
rstata_env <- new.env(parent=baseenv())

#Flags you can bitwise OR to enable debugging features.
#It's important that these have the same numeric values as in the C++ header file.
DEBUG_PARSE_TRACE <- 4
DEBUG_MATCH_CALL <- 8
DEBUG_VERBOSE_ERROR <- 16
DEBUG_NO_PARSE_ERROR <- 32

#' @export
#' @useDynLib rstata
#' @import Rcpp
rstata <-
function(dta = NULL, filename=NULL, string=NULL,
         assign.back=TRUE, save.history=TRUE,
         debug_level=0, echo=NULL)
{
    #We have a package-wide environment because of scoping issues,
    #but the data in it shouldn't persist across calls to this function
    rm(list=ls(rstata_env), envir=rstata_env)

    #Create the settings cache and macro symbol table
    assign("rstata_macro_env", new.env(parent=emptyenv()), envir=rstata_env)
    assign("rstata_settings_env", new.env(parent=emptyenv()), envir=rstata_env)
  
    #Create environments to represent Stata's "e-class" and "r-class" objects
    #for stored results
    assign("rstata_eclass_env", new.env(parent=emptyenv()), envir=rstata_env)
    assign("rstata_rclass_env", new.env(parent=emptyenv()), envir=rstata_env)
  
    #Sanity checks: create an empty dataset if none provided,
    #but make sure we have a data frame
    if(is.null(dta))
    {
        assign("rstata_dta", dplyr::data_frame(), envir=rstata_env)
        varname <- "dta"
    } else
    {
        assign("rstata_dta", dplyr::as_data_frame(dta), envir=rstata_env)
        varname <- deparse(substitute(dta))
    }

    stopifnot(is.data.frame(get("rstata_dta", envir=rstata_env)))

    #Sanity checks: make sure file and string aren't both set
    if(!is.null(filename) && !is.null(string))
    {
        stop("Cannot specify both the filename and string arguments")
    }

    #Should we, on exit, put the final dataset back into the variable
    #we were given as if we had a pointer to it?
    if(!is.null(assign.back))
        on.exit(if(assign.back)
        {
            obj <- get("rstata_dta", envir=rstata_env)
            assign(varname, obj, pos=parent.frame())
        })

    #We should put the debug_level argument into settings_env so that it's
    #accessible for nested invocations of do_parse_with_callbacks to handle
    #do files or the body blocks of loops.
    assignSetting("debug_level", debug_level)

    #=========================================================================
    #The actual work of parsing and executing commands is here
    if(interactive() && is.null(filename) && is.null(string))
    {
        #We're reading from stdin, interactively:
        #time for a read-eval-print loop

        #Save the command history before we get started
        if(!is.null(save.history) && save.history)
        {
            #the R command history before this function was invoked
            orig_cmdhist <- tempfile()
            savehistory(orig_cmdhist)

            #our command history
            cmdhist <- tempfile()
            cat("", file=cmdhist)
            loadhistory(cmdhist) #start with empty history

            on.exit(
            {
                loadhistory(orig_cmdhist)

                unlink(cmdhist)
                unlink(orig_cmdhist)
            }, add=TRUE)
        }

        while(TRUE)
        {
            val <-
            tryCatch(
            {
                inpt <- read_interactive()

                if(!is.null(save.history) && save.history)
                {
                    cat(inpt, "\n", file=cmdhist, append=TRUE)
                    loadhistory(cmdhist) #it's brutal how much disk access this is
                }

                #Send the input to the bison parser, which, after reading
                #each command, invokes the process_cmd callback
                do_parse_with_callbacks(text=inpt, cmd_action=process_cmd,
                                        macro_value_accessor=macro_value_accessor,
                                        debug_level=debug_level,
                                        echo=ifelse(is.null(echo), 0, echo))
            },
            error = function(c) c)

            if(inherits(val, "error"))
            {
                if(inherits(val, "ExitRequestedException"))
                {
                    break
                } else if(inherits(val, "BadCommandException") ||
                          inherits(val, "EvalErrorException") ||
                          inherits(val, "ContinueException") ||
                          inherits(val, "BreakException"))
                {
                    cat(paste0(val$message, "\n\n"))

                    next
                } else
                {
                    cat(paste0(val$message, "\n\n"))

                    s <- substr(readline("Save dataset to R workspace? "), 1, 1)
                    if(s == "Y" || s == "y")
                        assign.back <- TRUE

                    break
                }
            } else
            {
                cat("\n")
            }
        }
    } else if(is.null(filename) && is.null(string))
    {
        #We should read from stdin, but not interactively
        inpt <- readLines(con=stdin(), warn=FALSE)
        inpt <- Reduce(function(x, y) paste(x, y, sep="\n"), inpt)
        inpt <- paste0(inpt, "\n")

        do_parse_with_callbacks(text=inpt, cmd_action=process_cmd,
                                macro_value_accessor=macro_value_accessor,
                                debug_level=debug_level,
                                echo=ifelse(is.null(echo), 1, echo))
    } else if(!is.null(filename))
    {
        #We should read from a do-file
        con = file(filename, "r")
        on.exit(close(con), add=TRUE)

        inpt <- readLines(con)
        inpt <- Reduce(function(x, y) paste(x, y, sep="\n"), inpt)
        inpt <- paste0(inpt, "\n")

        do_parse_with_callbacks(text=inpt, cmd_action=process_cmd,
                                macro_value_accessor=macro_value_accessor,
                                debug_level=debug_level,
                                echo=ifelse(is.null(echo), 1, echo))
    } else
    {
        #We should read from a string
        con = textConnection(string)
        on.exit(close(con), add=TRUE)

        inpt <- readLines(con)
        inpt <- Reduce(function(x, y) paste(x, y, sep="\n"), inpt)
        inpt <- paste0(inpt, "\n")

        do_parse_with_callbacks(text=inpt, cmd_action=process_cmd,
                                macro_value_accessor=macro_value_accessor,
                                debug_level=debug_level,
                                echo=ifelse(is.null(echo), 1, echo))
    }

    return(invisible(get("rstata_dta", envir=rstata_env)));
}

#Callbacks: the main command-processing callback function for the parser
process_cmd <-
function(ast, debug_level=0)
{
    #Semantic analysis and code generation
    ret_p1 <-
    tryCatch(
    {
        check(ast, ifelse( (debug_level %&% DEBUG_VERBOSE_ERROR) != 0, 1, 0))

        codegen(ast, ifelse( (debug_level %&% DEBUG_MATCH_CALL) != 0, 1, 0))
    },
    error=function(c) c,
    BadCommandException=function(c) c)

    #Raising conditions with custom classes through an intervening
    #C++ layer is quite tricky, so we're going to return ints and have
    #the C++ code re-raise the exceptions in a more controllable way
    if(inherits(ret_p1, "BadCommandException") || inherits(ret_p1, "error"))
        return( list(1, ret_p1$message) )

    #Evaluate the generated calls for their side effects and for printable objects
    ret_p2 <-
    tryCatch(
    {
        deep_eval(ret_p1, envir=parent.env(environment()), enclos=rstata_env)
    },
    error=function(c) c,
    EvalErrorException=function(c) c,
    BadCommandException=function(c) c,
    ExitRequestedException=function(c) c,
    ContinueException=function(c) c,
    BreakException=function(c) c)

    if(inherits(ret_p2, "EvalErrorException") || inherits(ret_p2, "BadCommandException") ||
       inherits(ret_p2, "error"))
        return( list(2, ret_p2$message) )

    if(inherits(ret_p2, "ExitRequestedException"))
        return( list(3, ret_p2$message) )

    if(inherits(ret_p2, "ContinueException"))
        return( list(4, ret_p2$message) )

    if(inherits(ret_p2, "BreakException"))
        return( list(5, ret_p2$message) )

    return( list(0, "Success") );
}

#Callbacks: a macro value accessor that allows the lexer to retrieve macro values.
macro_value_accessor <-
function(name)
{
    env <- get("rstata_macro_env", envir=rstata_env)

    #Implement the e() and r() stored results objects, and the c() system
    #values object. All of the regexes here are a little screwy: if the e(),
    #r(), or c() appears at the beginning of the macro text, everything after
    #the close paren is ignored. But this is actually Stata's behavior,
    #so we'll run with it.

    #the e() class
    m <- regexpr("^e\\((?<match>.*)\\)", name, perl=TRUE)
    start <- attr(m, "capture.start")
    len <- attr(m, "capture.length")
    if(start != -1)
    {
        val <- substr(name, start, start + len - 1)
        return(rstata_func_e(val))
    }

    #the r() class
    m <- regexpr("^r\\((?<match>.*)\\)", name, perl=TRUE)
    start <- attr(m, "capture.start")
    len <- attr(m, "capture.length")
    if(start != -1)
    {
        val <- substr(name, start, start + len - 1)
        return(rstata_func_r(val))
    }

    #the c() class
    m <- regexpr("^r\\((?<match>.*)\\)", name, perl=TRUE)
    start <- attr(m, "capture.start")
    len <- attr(m, "capture.length")
    if(start != -1)
    {
        val <- substr(name, start, start + len - 1)
        return(rstata_func_c(val))
    }

    #a normal macro
    if(!(name %in% ls(env)))
        return("")
    else
        return(get(name, envir=env, inherits=FALSE))
}

