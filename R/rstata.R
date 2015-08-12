### The REPL, batch-processing and environment-handling logic for rstata

rstata <-
function(dta = NULL, filename=NULL, string=NULL, assign.back=TRUE)
{
    #Sanity checks: create an empty dataset if none provided,
    #but make sure we have a data frame
    if(is.null(dta))
        dta <- data.frame();
    stopifnot(is.data.frame(dta))
    
    #Sanity checks: make sure file and string aren't both set
    if(!is.null(filename) && !is.null(string))
    {
        stop("Cannot specify both the filename and string arguments")
    }
    
    #Should we put the final dataset back into the variable
    #we were given, pointer-style, on exit?
    if(!is.null(assign.back) && assign.back)
    {
        varname <- deparse(substitute(dta))
        on.exit(assign(varname, dta, pos=parent.frame()))
    }
    
    #Create two environments used to hold a) the symbol table for macro
    #substitution, b) settings and parameters that commands can see
    #or modify.
    settings.env <- new.env()
    macro.env <- new.env()
    
    #A macro value accessor that closes over the macro environment, so
    #we can pass it in to the parser as a callback.
    get_macro_value <-
    function(name)
    {
        get(name, envir=macro.env, inherits=FALSE)
    }

    if(interactive() && is.null(filename) && is.null(string))
    {
        #We're reading from stdin, interactively:
        #time for a read-eval-print loop
        while(TRUE)
        {
            val <-
            tryCatch(
            {
                inpt <- read_interactive()

                #Send the input to the bison parser, which, after reading
                #each command, invokes the process_cmd callback defined at
                #the end of this file to do a few things:
                #    o) run post-parsing syntax and semantic checks on that
                #       command's AST
                #    o) recursively walk the AST to construct an R expression
                #       object
                #    o) finally, eval the expression object for its side
                #       effects, including printing any output, and throw
                #       away the value
                do_parse_with_callbacks(inpt, process_cmd, get_macro_value)
                                        
            },
            error = function(c) c,
            exit = function(c) c)

            #We got a bad command, but restart rather than abort
            if(inherits(val, "bad_command"))
            {
                print(val)
                next
            }

            #A different error - should this prompt to save data?
            if(inherits(val, "error"))
                signalCondition(val); #re-raise the exception
            
            #The custom condition for ado-language exit commands
            if(inherits(val, "exit"))
            {
                cat("\n")
                break
            }
        }
    } else if(is.null(filename) && is.null(string))
    {   
        inpt <- readLines(con=stdin(), warn=FALSE)
        
        do_parse_with_callbacks(inpt, process_cmd, get_macro_value)
    } else if(!is.null(filename))
    {
        inpt <- readLines(con=file(filename, "r"))
        
        do_parse_with_callbacks(inpt, process_cmd, get_macro_value)
    } else
    {
        inpt <- readLines(con=textConnection(string))
        
        do_parse_with_callbacks(inpt, process_cmd, get_macro_value)
    }

    return(invisible(dta));
}

process_cmd <-
function(ast)
{
    #for right now, don't do any of the stuff below...
    print(ast); return(1);
    
    settings.env <- get("settings.env", envir=parent.frame())
    macro.env    <- get("macro.env", envir=parent.frame())
    
    #don't throw an R exception into C++, not a good idea...
    #instead, the C++ code will notice this return code and re-raise
    #the condition
    #FIXME: is this actually necessary?
    val <-
    tryCatch( 
    {
        #take the syntax tree and a) weed it, b) turn it into
        #an expression object, throwing exceptions if anything goes wrong
        walked <- walk(ast)

        lapply(walked, eval)
    },
    bad_command = function(c) c)
    
    if(inherits(val, "bad_command"))
        return(1) #failure, the parser re-raises the condition
    else
        return(0) #success
}

