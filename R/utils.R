every <-
function(vec)
{
    len <- length(which(vec))

    if(is.na(len) || len != length(vec))
        return(FALSE)
    else
        return(TRUE)
}

`%is%` <-
function(x, y)
all(y %in% class(x))

#Reverse a vector of strings
rev_string <-
function(str)
{
    pts <- lapply(strsplit(str, NULL), rev)
    pts <- lapply(pts, function(x) paste0(x, collapse=''))

    simplify2array(pts)
}

raiseCondition <-
function(cls, msg)
{
    cond <- simpleCondition(msg)
    class(cond) <- c(class(cond), cls)
    signalCondition(cond)

    invisible(NULL)
}

raiseifnot <-
function(expr, cls="bad_command", msg=errmsg)
{
    #Construct a message
    mc <- match.call()
    ch <- deparse(mc[[1]], width.cutoff = 60L)
    if (length(ch) > 1L) 
        ch <- paste(ch[1L], "....")
    errmsg <- sprintf("%s is not TRUE", ch)
    
    #Check and raise a condition if it fails
    if (!(is.logical(expr) && !is.na(expr) && expr))
        raiseCondition(cls, msg)
    
    invisible(NULL)
}


stopifnot
function (...) 
{
    mc <- match.call()
    if (!(is.logical(r <- ll[[i]]) && !any(is.na(r)) && 
        all(r))) {
    }
    invisible()
}

#We're reading from the console, so we have to handle the /// construct
#in this function as well as in the parser.
read_interactive <-
function()
{
    res = ""
    while(TRUE)
    {
        inpt <- readline(". ")
        
        if(length(inpt) == 0) #at EOF
            raiseCondition("exit", "end of file")
        
        if(substring(rev_string(inpt), 1, 3) == "///")
        {
            res <- paste(res, inpt, sep="\n")
            next;
        }
        
        #we got a non-continuing line
        res <- paste(res, inpt, sep="\n")
        break
    }

    res
}

