#the REPL loop and environment-handling logic for rstata

rstata <-
function(dta = NULL)
{
    #create an empty dataset if none provided,
    #but make sure we have a data frame
    if(is.null(dta))
        dta <- data.frame();
    stopifnot(is.data.frame(dta))

    while(TRUE)
    {
        line <- readline(". ")

        val <-
        tryCatch(
        {
            if( line == "exit" || line == "quit" )
            {
                cond <- simpleCondition("exit requested")
                class(cond) <- c(class(cond), "exit")

                signalCondition(cond)
            }
                
            expr <- parse(textConnection(line))
            val <- eval(expr, parent.frame())      
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

    return(invisible(dta))
}

