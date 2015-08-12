### The REPL, batch-processing and environment-handling logic for rstata

# FIXME
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
    
    if(interactive() && is.null(filename) && is.null(string))
    {
        #We're reading from stdin as an REPL
        
        #The main read-eval-print loop
        while(TRUE)
        {
            val <-
            tryCatch(
            {
                inpt <- read_interactive()

                #Send the input to the bison parser
                ast <- do_parse(inpt)
                
                ##FIXME when API stabilizes
                #Do post-parsing syntax and semantic checks on the AST,
                #and then recursively transform it to an expression object
                #res <- lapply(ast, function(x) eval(x, dta, environment()))
                #res <- do.call(paste0, c(res, list(collapse="\n")))
                #
                #eval(res) #each called function prints its own output
            },
            error = function(c) c,
            exit = function(c) c)

            if(inherits(val, "error"))
                signalCondition(val);
            
            #The custom condition for ado-language exit commands
            if(inherits(val, "exit"))
            {
                cat("\n");
                break;
            }

            print(val, sep="\n") #this line is unnecessary soon...
        }
    } else if(is.null(filename) && is.null(string))
    {   
        #We're reading from stdin, in batch mode
        
        inpt <- readLines(con=stdin(), warn=FALSE)
        ast <- do_parse(inpt)
        
        ##FIXME when API stabilizes
    } else if(!is.null(filename))
    {
        inpt <- readLines(con=file(filename, "r"))
        ast <- do_parse(inpt)
        
        ##FIXME when API stabilizes
    } else #!is.null(string)
    {
        inpt <- readLines(con=textConnection(string))
        ast <- do_parse(inpt)
        
        ##FIXME when API stabilizes
    }

    return(invisible(dta));
}

