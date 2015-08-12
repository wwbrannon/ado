### The REPL, batch-processing and environment-handling logic for rstata

rstata <-
function(dta = NULL, filename=NULL, string=NULL, assign.back=TRUE)
{
    #Sanity checks: create an empty dataset if none provided,
    #but make sure we have a data frame
    if(is.null(dta))
    {
        dta <- data.frame()
        varname <- "dta"
    } else
    {
        varname <- deparse(substitute(dta))
    }

    stopifnot(is.data.frame(dta))
    
    #Sanity checks: make sure file and string aren't both set
    if(!is.null(filename) && !is.null(string))
    {
        stop("Cannot specify both the filename and string arguments")
    }
    
    #Should we put the final dataset back into the variable
    #we were given, pointer-style, on exit?
    if(!is.null(assign.back) && assign.back)
        on.exit(assign(varname, dta, pos=parent.frame()))
    
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
              error = function(c) c)
              
              if(inherits(val, "error"))
              {
                if(inherits(val, "exit"))
                {
                  cat("\n")
                  break
                } else if(inherits(val, "bad_command"))
                {
                  cat(paste0(val$message, "\n", sep=""))
                  next
                } else
                {
                  cat(paste0(val$message, "\n", sep=""))
                  
                  on.exit("")
                  s <- substr(readline("Will now exit. Save data? "), 1, 1)
                  if(s == "Y" || s == "y")
                    assign(varname, dta, pos=parent.frame())
                  
                  break
                }
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
    # FIXME: conditions are not propagating correctly, or being handled
    # correctly in the caller
    
    #Do semantic analysis and run checks, including for things that Stata
    #considers syntax, and raise error conditions if the checks fail.
    weed(ast)
    
    #Code generation: convert the raw AST into an R call object
    cl <- codegen(ast)
    
    #Evaluate the generated calls
    #    a) for their side effects
    #    b) for printable objects
    objs <- eval(cl, envir=parent.frame())
    
    for(obj in objs)
      print(obj) #dispatches to the custom print methods

    return(0); #a compatible type for the C++ layer
}
