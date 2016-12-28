context("User-defined commands")

test_that("Adding user commands works", {
    nsenv <- getNamespace('ado')
    pkgenv <- as.environment('package:ado')

    cmd <- function(expression) { return(as.character(expression)) }

    expect_false('testprint' %in% ls(envir=nsenv))

    ado(string='addCommand cmd, newname(testprint)')

    expect_true('ado_cmd_testprint' %in% ls(envir=nsenv &&
                'ado_cmd_testprint' %not_in% ls(envir=pkgenv)))
})
