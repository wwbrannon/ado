weed <-
function(node)
UseMethod("weed")

weed.general.cmd
<- 










eval.ast.node <-
function(node)
{
    if(!("rstata.ast.node" %in% class(node)))
    {
        signalCondition(simpleError("Not called on an AST node"))
    }


}

#The function to execute embedded R code
embedded_r <-
function(txt)
{
    vals <- lapply(lapply(parse(text=txt), eval), capture.output)

    do.call(paste0, c(vals, list(collapse="\n")))
}

