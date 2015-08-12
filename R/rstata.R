#the REPL loop and environment-handling logic for rstata
library(Rcpp)

rstata <-
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
            val <- eval_stata(expr_list, envir=dta, enclos=environment())
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

