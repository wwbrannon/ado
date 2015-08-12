### The REPL, batch-processing and environment-handling logic for rstata

#' @export
#' @useDynLib rstata
#' @import Rcpp
rstata <-
function(dta = NULL, filename=NULL, string=NULL,
         assign.back=TRUE, save.history=TRUE,
         debug_level=0)
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
        
        #Save the command history before we get started
        if(!is.null(save.history) && save.history)
        {
          cmdhist <- tempfile()
          savehistory(cmdhist)
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
                                    get_macro_value=get_macro_value,
                                    debug_level=debug_level)
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
      
      if(!is.null(save.history) && save.history)
        unlink(cmdhist)
    } else if(is.null(filename) && is.null(string))
    {   
        inpt <- readLines(con=stdin(), warn=FALSE)
        inpt <- Reduce(function(x, y) paste(x, y, sep="\n"), inpt)
        inpt <- paste0(inpt, "\n\n\n")
        
        do_parse_with_callbacks(text=inpt, cmd_action=process_cmd,
                                get_macro_value=get_macro_value,
                                debug_level=debug_level)
    } else if(!is.null(filename))
    {
        inpt <- readLines(con=file(filename, "r"))
        inpt <- Reduce(function(x, y) paste(x, y, sep="\n"), inpt)
        inpt <- paste0(inpt, "\n\n\n")
        
        do_parse_with_callbacks(text=inpt, cmd_action=process_cmd,
                                get_macro_value=get_macro_value,
                                debug_level=debug_level)
    } else
    {
        inpt <- readLines(con=textConnection(string))
        inpt <- Reduce(function(x, y) paste(x, y, sep="\n"), inpt)
        inpt <- paste0(inpt, "\n\n\n")
        
        do_parse_with_callbacks(text=inpt, cmd_action=process_cmd,
                                get_macro_value=get_macro_value,
                                debug_level=debug_level)
    }
    
    return(invisible(dta));
}

process_cmd <-
function(ast, debug_level=0)
{
  #Semantic analysis and code generation
  ret_p1 <-
  tryCatch(
  {
    check(ast, debug_level=debug_level)
    
    codegen(ast, debug_level=debug_level)
  },
  error=function(c) c,
  bad_command=function(c) c)
  
  #Raising conditions with custom classes through an intervening
  #C++ layer is quite tricky, so we're going to return ints and have
  #the C++ code re-raise the exceptions in a more controllable way
  if(inherits(ret_p1, "bad_command") || inherits(ret_p1, "error"))
    return(1)

  #Evaluate the generated calls for their side effects and for printable objects
  ret_p2 <-
  tryCatch(
  {
    #FIXME how to incorporate debug level?
    objs <- eval(ret_p1, envir=parent.frame())
  
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
