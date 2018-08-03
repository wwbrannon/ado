context("User-defined commands")

test_that("Adding user commands works", {
    #The function we're turning into a command
    cmd <- function(context, expression) { return(as.character(expression)) }

    tryCatch(
        {
            #Hack alert! We have to put this into the globalenv to load it.
            tn <- temporary_name(lst=ls(envir=environment()))
            assign(tn, cmd, envir=globalenv())

            #Actually load the thing - this is what we're testing here
            st <- 'addCommand ' %p% tn %p% ', newname(testprint); testprint "foo";'
            ado(string=st, echo=0, print_results=0)

            #Check that it worked
            out <- capture.output(ado(string='testprint "foo";', echo=0))
            out <- Filter(function(x) nchar(x) > 0, out) #remove blank lines
            expect_equal(out, "foo")
        }, finally=
        {
            #Tear down - remove this function from the globalenv
            if(tn %in% ls(envir=globalenv()))
                rm(list=tn, envir=globalenv())
        })

})
