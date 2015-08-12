### The REPL, batch-processing and environment-handling logic for rstata

#' @export
#' @useDynLib rstata
#' @import Rcpp
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
            #each command, invokes the process_cmd callback
            do_parse_with_callbacks(inpt, process_cmd, get_macro_value)
          },
          error = function(c) c)
          
          if(inherits(val, "error"))
          {
            if(inherits(val, "ExitRequestedException"))
            {
              cat("\n") #so the new R prompt is on a new line
              break
            } else if(inherits(val, "BadCommandException"))
            {
              cat(paste0(val$message, sep=""))
              
              next
            } else
            {
              cat(paste0(val$message, sep=""))
              
              on.exit()
              s <- substr(readline("Save dataset? "), 1, 1)
              if(s == "Y" || s == "y")
                assign(varname, dta, pos=parent.frame())
              
              break
            }
          }
        }
    } else if(is.null(filename) && is.null(string))
    {   
        inpt <- readLines(con=stdin(), warn=FALSE)
        inpt <- Reduce(function(x, y) paste(x, y, sep="\n"), inpt)
        inpt <- paste0(inpt, "\n\n\n")
        
        do_parse_with_callbacks(inpt, process_cmd, get_macro_value)
    } else if(!is.null(filename))
    {
        inpt <- readLines(con=file(filename, "r"))
        inpt <- Reduce(function(x, y) paste(x, y, sep="\n"), inpt)
        inpt <- paste0(inpt, "\n\n\n")
        
        do_parse_with_callbacks(inpt, process_cmd, get_macro_value)
    } else
    {
        inpt <- readLines(con=textConnection(string))
        inpt <- Reduce(function(x, y) paste(x, y, sep="\n"), inpt)
        inpt <- paste0(inpt, "\n\n\n")
        
        do_parse_with_callbacks(inpt, process_cmd, get_macro_value)
    }

    return(invisible(dta));
}

process_cmd <-
function(ast)
{
  #Semantic analysis and code generation
  ret_p1 <-
  tryCatch(
  {
    check(ast)
    
    codegen(ast)
  },
  error=function(c) c,
  bad_command=function(c) c)
  
  #Raising conditions with custom classes through an intervening
  #C++ layer is quite tricky, so we're going to return ints and have
  #the C++ code re-raise the exceptions in a more controllable way
  if(inherits(ret_p1, "bad_command") || inherits(ret_p1, "error"))
    return(1)
  else
    cl <- ret_p1

  #Evaluate the generated calls for their side effects and for printable objects
  ret_p2 <-
  tryCatch(
  {
    objs <- eval(cl, envir=parent.frame())
  
    for(obj in objs)
      print(obj) #dispatches to the custom print methods
  },
  error=function(c) c,
  exit=function(c) c)
  
  if(inherits(ret_p2, "error"))
    return(2)
  
  if(inherits(ret_p2, "exit"))
    return(3)
  
  return(0);
}
