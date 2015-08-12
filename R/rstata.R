### The REPL, batch-processing and environment-handling logic for rstata

rstata <-
function(what)
UseMethod(what)

# FIXME
rstata.data.frame <-
function(dta = NULL, conn=stdin(), assign.back=TRUE)
{
    #create an empty dataset if none provided,
    #but make sure we have a data frame
    if(is.null(dta))
        dta <- data.frame();
    stopifnot(is.data.frame(dta))
    
    if(!is.null(assign.back) && assign.back)
        varname <- deparse(substitute(dta))
    
    while(TRUE)
    {
        cat(". ")
        inpt <- readLines(conn)

        val <-
        tryCatch(
        {
            expr_list <- do_stata_parse(inpt)
            
            print(expr_list)
            #res <- lapply(expr_list, function(x) eval(x, dta, environment()))
            #res <- do.call(paste0, c(res, list(collapse="\n")))
        },
        error = function(c) c,
        exit = function(c) c)

        if(inherits(val, "error"))
            signalCondition(val);
        
        #the custom condition for ado-language exit commands
        if(inherits(val, "exit"))
            break;

        cat(val, sep="\n")
        cat('\n')
    }

    if(!is.null(assign.back) && assign.back)
        assign(varname, dta, pos=parent.frame())
    
    return(invisible(dta));
}

#The batch-processing version that acts on a file
rstata.character <-
function(filename)
{
    rstata.data.frame(dta=NULL, conn=file(filename, "r"), assign.back=FALSE)
}

#Default to the data frame method, incl if NULL received as first argument
rstata.NULL    <- rstata.data.frame
rstata.default <- rstata.data.frame

