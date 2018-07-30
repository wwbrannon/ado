context("User-defined commands")

test_that("Adding user commands works", {
    nsenv <- getNamespace('ado')
    pkgenv <- as.environment('package:ado')

    #Make sure that our target name is not already loaded
    expect_false('testprint' %in% ls(envir=nsenv))

    #The function we're turning into a command
    cmd <- function(expression) { return(as.character(expression)) }

    #Hack alert! We have to put this into the globalenv to load it.
    tn <- temporary_name(lst=ls(envir=globalenv()))

    tryCatch(
        {
            assign(tn, cmd, envir=globalenv())

            #Actually load the thing - this is what we're testing here
            st <- 'addCommand ' %p% tn %p% ', newname(testprint)'
            ado(string=st, echo=0, print_results=0)
        }, finally=
        {
            #Tear down - remove this function from the globalenv
            if(tn %in% ls(envir=globalenv()))
                rm(list=tn, envir=globalenv())
        })

    #Check that it worked
    expect_true('ado_cmd_testprint' %in% ls(envir=nsenv) &&
                'ado_cmd_testprint' %not_in% ls(envir=pkgenv))

    if('ado_cmd_testprint' %in% ls(envir=nsenv))
        expect_equal(get('ado_cmd_testprint', envir=nsenv), cmd) 
})
