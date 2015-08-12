raiseifnot <-
function(test, cond=simpleError)
{
    msg = paste0("Assertion failed: ", deparse(substitute(test)))
    if(!test)
        signalCondition(cond(msg))
}

errorifnot <-
raiseifnot

warningifnot <-
function(test)
raiseifnot(test, cond=simpleWarning)

messageifnot <-
function(test)
raiseifnot(test, cond=simpleMessage)

#Reverse a vector of strings
rev_string <-
function(str)
{
    pts <- lapply(strsplit(str, NULL), rev)
    pts <- lapply(pts, function(x) paste0(x, collapse=''))

    simplify2array(pts)
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

