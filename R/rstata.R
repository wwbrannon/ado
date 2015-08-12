#The REPL and environment-handling logic for rstata
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
            
            res <- lapply(expr_list, function(x) eval(x, dta, environment()))
            res <- do.call(paste0, c(res, list(collapse="\n")))
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

#The dispatcher function for rstata commands.
#The parser constructs calls to this function with one character argument
#named "verb" and the arguments to the particular Stata command named by verb.
dispatch.rstata.cmd <-
function(verb, ...)
{
    args <- as.list(substitute(list(...)))[-1L]
    
    fname <- paste0("rstata.", verb)
    return(capture.output(do.call(fname, args)))
}

#The function to execute embedded R code
embedded_r <-
function(txt)
{
    vals <- lapply(lapply(parse(text=txt), eval), capture.output)

    do.call(paste0, c(vals, list(collapse="\n")))
}

