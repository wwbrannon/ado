context("The semantic analyzer accepts all and only valid statements")

expect_accept <- function(str) eval(bquote(expect_equal(analyze(.(str)), 1)))
expect_reject <- function(str) eval(bquote(expect_equal(analyze(.(str)), 0)))

analyze <-
function(str)
{
    val <-
    tryCatch(
    {
        tr <- do_parse(str)
        
        check(tr)
    },
    error=identity)
    
    if(inherits(val, "EvalErrorException") ||
       inherits(val, "BadCommandException"))
    {
        return(0)
    } else
    {
        return(1)
    }
}

