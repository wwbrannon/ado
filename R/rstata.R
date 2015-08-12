#the REPL loop and environment-handling logic for rstata
library(Rcpp)

do_stata_parse <-
function()
{
    .Call('rcpp_do_stata_parse', PACKAGE = 'rstata')
}

eval_stata <-
function(expr_list)
{
    TRUE; #TBD
}

rstata <-
function(dta = NULL, assign.back=TRUE)
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
        line <- readline(". ")

        val <-
        tryCatch(
        {
            #once this actually works, turn this into part of the grammar
            if( line == "exit" || line == "quit" )
            {
                cond <- simpleCondition("exit requested")
                class(cond) <- c(class(cond), "exit")

                signalCondition(cond)
            }
                
            expr_list <- do_stata_parse(line)
            val <- eval_stata(expr_list)
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

