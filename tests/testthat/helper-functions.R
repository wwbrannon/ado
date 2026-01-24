## Functions for parsing tests
parse_accept <-
function(str)
{
    # DEBUG_NO_PARSE_ERROR = 32, DEBUG_NO_CALLBACKS = 64
    debug_level <- bitwOr(32, 64)  # 96
    echo <- 0

    cls <- methods::getRefClass("ParseDriver")
    obj <- cls$new(str, emptyenv(), debug_level, echo)

    ret <- obj$parse()

    ifelse(ret == 0 && obj$error_seen == 0, 1, 0)
}

expect_parse_accept <-
function(str)
{
    eval(bquote(expect_equal(parse_accept(.(str)), 1)))
}

expect_parse_reject <-
function(str)
{
    eval(bquote(expect_equal(parse_accept(.(str)), 0)))
}

## Functions for semantic analysis tests
ado_parse <-
function(str)
{
    # DEBUG_NO_PARSE_ERROR = 32, DEBUG_NO_CALLBACKS = 64
    debug_level <- bitwOr(32, 64)  # 96
    echo <- 0

    cls <- methods::getRefClass("ParseDriver")
    obj <- cls$new(str, emptyenv(), debug_level, echo)

    ret <- obj$parse()

    if(ret == 0 && obj$error_seen == 0)
        return(obj$get_ast())
    else
        return(NULL)
}

analyze <-
function(str)
{
  val <-
    tryCatch(
      {
        tr <- ado_parse(str)

        #we have to list "error" here explicitly because in the lower-level code,
        #the "error" class is added automatically to a caught C++ exception
        if(identical(tr, list()))
          ado:::raiseCondition("Bad command", cls=c("error", "BadCommandException"))

        ado:::check(tr)
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

## Functions for code generation tests
codegen_test <-
function(str)
{
  ast <- ado_parse(str)
  if(is.null(ast))
    return(NULL)

  obj <- ado:::AdoInterpreter$new()
  tryCatch(
    ado:::codegen(ast, context = obj),
    error = function(e) NULL
  )
}

expect_codegen_succeeds <-
function(str)
{
  result <- codegen_test(str)
  eval(bquote(expect_true(!is.null(.(result)))))
}

expect_codegen_fails <-
function(str)
{
  result <- codegen_test(str)
  eval(bquote(expect_null(.(result))))
}
