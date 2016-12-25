## Functions for parsing tests
expect_parse_accept <- function(str) eval(bquote(expect_equal(parse_accept(.(str)), 1)))
expect_parse_reject <- function(str) eval(bquote(expect_equal(parse_accept(.(str)), 0)))

## Functions for semantic analysis tests
analyze <-
function(str)
{
  val <-
    tryCatch(
      {
        tr <- do_parse(str, DEBUG_NO_PARSE_ERROR)
        
        #we have to list "error" here explicitly because in the lower-level code,
        #the "error" class is added automatically to a caught C++ exception
        if(identical(tr, list()))
          raiseCondition("Bad command", cls=c("error", "BadCommandException"))
        
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

expect_semantic_accept <- function(str) eval(bquote(expect_equal(analyze(.(str)), 1)))
expect_semantic_reject <- function(str) eval(bquote(expect_equal(analyze(.(str)), 0)))
