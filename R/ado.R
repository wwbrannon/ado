### The REPL, batch-processing and environment-handling logic for ado
#TODO: this should really be factored into a more OO design; use R6?

#Flags you can bitwise OR to enable debugging features.
#It's important that these have the same numeric values as
#the macros in the C++ header file.
DEBUG_PARSE_TRACE <- 4
DEBUG_MATCH_CALL <- 8
DEBUG_VERBOSE_ERROR <- 16
DEBUG_NO_PARSE_ERROR <- 32

#' Interpret ado code interactively or from a file.
#'
#' An interpreter for a dialect of Stata's ado language. The ado dialect is
#' close to the one Stata provides; see the package vignettes for full details.
#'
#' @param dta If NULL, start with an empty dataset; if a data.frame, use a copy
#'            of the data.frame to initialize the dataset.
#' @param filename The path to an ado script to execute. At least one of filename
#'                 and string must be NULL.
#' @param string A length-1 character vector to read command input from. At least
#'                 one of filename and string must be NULL.
#' @param assign.back If TRUE, copy the final dataset state to a variable in the
#'                    caller's environment on function exit. The variable name is
#'                    the name (in the caller's environment) of the data.frame
#'                    passed as the dta argument, or if dta was NULL, the name "dta"
#'                    is used. The effect is to modify the passed data.frame, though
#'                    the old value will not necessarily be garbage-collected.
#' @param debug_level How verbose debug messages should be.
#' @param echo Whether to echo command input. Values 0, 1, and NULL are accepted;
#'             if NULL, echo only when running non-interactively.
#'
#' @return Invisible NULL.
#'
#' @export
#' @useDynLib ado
#' @import Rcpp
ado <-
function(dta = NULL, filename=NULL, string=NULL, assign.back=FALSE,
         debug_level=0, echo=NULL)
{
    #We have a package-wide environment because of scoping issues,
    #but the data in it shouldn't persist across calls to this function
    initialize()
    dt <- get("ado_dta", envir=ado_env)

    #If we got a data.frame to use, set up the dataset object to use it
    if(is.null(dta))
    {
        varname <- "dta"
    } else
    {
        dt$use_dataframe(dta)
        varname <- deparse(substitute(dta))
    }

    #Sanity checks: make sure file and string aren't both set
    if(!is.null(filename) && !is.null(string))
    {
        stop("Cannot specify both the filename and string arguments")
    }

    #Sanity checks: make sure we get one of filename and string if not
    #in interactive mode
    if(!interactive() && is.null(filename) && is.null(string))
    {
        stop("Must specify filename or string if not in interactive mode")
    }

    #Should we, on exit, put the final dataset back into the variable
    #we were given as if we had a pointer to it?
    if(!is.null(assign.back))
    {
        on.exit(if(assign.back)
        {
            obj <- as.data.frame(dt$as_data_frame)
            assign(varname, obj, pos=parent.frame())
        })
    }

    #Call the finalizer on exit to make sure the dataset is cleared and
    #memory is released
    on.exit(finalize(), add=TRUE)

    #We should put the debug_level argument into settings_env so that it's
    #accessible for nested invocations of do_parse_with_callbacks to handle
    #do files or the body blocks of loops.
    assignSetting("debug_level", debug_level)

    #Set up the object to read from
    if(interactive() && is.null(filename) && is.null(string))
    {
        con <- NULL
    } else if(is.null(filename) && is.null(string))
    {
        con <- stdin()
    } else if(!is.null(filename))
    {
        con <- file(filename, "rb")
        on.exit(close(con), add=TRUE)
    } else
    {
        #It's not important to close this connection because (as in
        #the R docs for textConnection) it's not really an OS resource
        con <- textConnection(string)
    }

    #Should we echo input? Don't echo when interactive and reading from
    #stdin, because then the cmd text is already visible on the console.
    if(is.null(echo))
    {
        if(is.null(con))
            echo <- 0
        else
            echo <- 1
    }

    #Make the echo level into a setting as well
    assignSetting("echo", echo)

    #=========================================================================
    #The actual work of parsing and executing commands is here: time for an REPL,
    #whether input is interactive from the console or not. The logic is split out
    #into a separate function so that it can be re-used in the -do- command, rather
    #than being duplicated there.
    repl(con)

    return(invisible((dt$as_data_frame)))
}

repl <-
function(con=NULL, debug_level=getSettingValue("debug_level"),
         echo=getSettingValue("echo"))
{
    while(TRUE)
    {
        val <-
            tryCatch(
                {
                    inpt <- read_input(con)

                    #We've hit EOF
                    if(length(inpt) == 0)
                    {
                        raiseCondition("Exit requested", c("error", "ExitRequestedException"))
                    }

                    #Send the input to the bison parser, which, after reading
                    #each command, invokes the process_cmd callback
                    do_parse_with_callbacks(text=inpt, cmd_action=process_cmd,
                                            macro_value_accessor=macro_value_accessor,
                                            debug_level=debug_level, echo=echo)
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

                break
            }
        } else
        {
            cat("\n")
        }
    }

    return(invisible(NULL))
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
    {
        return( list(1, ret_p1$message) )
    }

    #Evaluate the generated calls for their side effects and for printable objects
    ret_p2 <-
    tryCatch(
    {
        deep_eval(ret_p1, envir=parent.env(environment()), enclos=ado_env)
    },
    error=function(c) c,
    EvalErrorException=function(c) c,
    BadCommandException=function(c) c,
    ExitRequestedException=function(c) c,
    ContinueException=function(c) c,
    BreakException=function(c) c)

    if(inherits(ret_p2, "EvalErrorException") || inherits(ret_p2, "BadCommandException") ||
       inherits(ret_p2, "error"))
    {
        return( list(2, ret_p2$message) )
    }

    if(inherits(ret_p2, "ExitRequestedException"))
    {
        return( list(3, ret_p2$message) )
    }

    if(inherits(ret_p2, "ContinueException"))
    {
        return( list(4, ret_p2$message) )
    }

    if(inherits(ret_p2, "BreakException"))
    {
        return( list(5, ret_p2$message) )
    }

    return( list(0, "Success") );
}

#Callbacks: a macro value accessor that allows the lexer to retrieve macro values.
macro_value_accessor <-
function(name)
{
    env <- get("ado_macro_env", envir=ado_env)

    #Implement the e() and r() stored results objects, and the c() system
    #values object. All of the regexes here are a little screwy: when the e(),
    #r(), or c() appears at the beginning of the macro text, everything after
    #the close paren is ignored. But this is actually Stata's behavior,
    #so we'll run with it.

    #The (e,r,c)-classes are ONLY recognized when at the start of a macro text.
    #The "_?" in the regexes matches them when used in either a local macro
    #(which the parser expands into a global with a prefixed "_") or a global.

    #the e() class
    m <- regexpr("^e_?\\((?<match>.*)\\)", name, perl=TRUE)
    start <- attr(m, "capture.start")
    len <- attr(m, "capture.length")
    if(start != -1)
    {
        txt <- substr(name, start, start + len - 1)
        val <- as.character(ado_func_e(txt))

        return(val)
    }

    #the r() class
    m <- regexpr("^_?r\\((?<match>.*)\\)", name, perl=TRUE)
    start <- attr(m, "capture.start")
    len <- attr(m, "capture.length")
    if(start != -1)
    {
        txt <- substr(name, start, start + len - 1)
        val <- as.character(ado_func_r(txt))

        return(val)
    }

    #the c() class
    m <- regexpr("^_?c\\((?<match>.*)\\)", name, perl=TRUE)
    start <- attr(m, "capture.start")
    len <- attr(m, "capture.length")
    if(start != -1)
    {
        txt <- substr(name, start, start + len - 1)
        val <- as.character(ado_func_c(txt))

        return(val)
    }

    #a normal macro
    if(!(name %in% ls(env)))
    {
        return("")
    } else
    {
        return(get(name, envir=env, inherits=FALSE))
    }
}

