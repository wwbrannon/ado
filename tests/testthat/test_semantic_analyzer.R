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


test_that("Numeric literals pass semantic analysis", {
    #FIXME
})

test_that("Arithmetic expressions pass semantic analysis", {
    #FIXME
})

test_that("String expressions, with double and compound double quotes, pass semantic analysis", {
    #FIXME
})

test_that("Factor expressions and factorial operators pass semantic analysis", {
    #FIXME
})

test_that("Type constructors pass semantic analysis", {
    #FIXME
})

test_that("Postfix expressions pass semantic analysis", {
    #FIXME
})

test_that("Relational and equality expressions pass semantic analysis", {
    #FIXME
})

test_that("Logical expressions pass semantic analysis", {
    #FIXME
})

test_that("Assignment expressions pass semantic analysis", {
    #FIXME
})

test_that("Short comments pass semantic analysis", {
    #FIXME
})

test_that("Long comments pass semantic analysis", {
    #FIXME
})

test_that("Both statement delimiters pass semantic analysis", {
    #FIXME
})

test_that("Compound command blocks pass semantic analysis", {
    #FIXME
})

test_that("Empty general commands pass semantic analysis", {
    #FIXME
})

test_that("General commands with an expression_list pass semantic analysis", {
    #FIXME
})

test_that("General commands with an option list pass semantic analysis", {
    #FIXME
})

test_that("General commands with an if clause and an option list pass semantic analysis", {
    #FIXME
})

test_that("General commands with an expression list and an if clause pass semantic analysis", {
    #FIXME
})

test_that("General commands with an expression list and an in clause pass semantic analysis", {
    #FIXME
})

test_that("General commands with an expression list and a weight clause pass semantic analysis", {
    #FIXME
})

test_that("General commands with an expression list and a using clause pass semantic analysis", {
    #FIXME
})

test_that("General commands with an expression list and an option list pass semantic analysis", {
    #FIXME
})

test_that("Embedded code blocks pass semantic analysis", {
    #FIXME
})

test_that("The merge command passes semantic analysis", {
    #FIXME
})

test_that("The xi command passes semantic analysis", {
    #FIXME
})

test_that("The ivregress command passes semantic analysis", {
    #FIXME
})

test_that("The gsort command passes semantic analysis", {
    #FIXME
})

test_that("The collapse command passes semantic analysis", {
    #FIXME
})

test_that("The lrtest command passes semantic analysis", {
    #FIXME
})

test_that("The anova command passes semantic analysis", {
    #FIXME
})

test_that("The recode command passes semantic analysis", {
    #FIXME
})

test_that("Prefix commands pass semantic analysis with a general command", {
    #FIXME
})

test_that("Prefix commands pass semantic analysis with a special command", {
    #FIXME
})

test_that("Macro manipulation commands pass semantic analysis", {
    #FIXME
})

test_that("If statements pass semantic analysis", {
    #FIXME
})

test_that("Forvalues loops pass semantic analysis", {
    #FIXME
})

test_that("Foreach loops pass semantic analysis", {
    #FIXME
})

