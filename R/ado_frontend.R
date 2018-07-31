##
## A frontend function to the R6 interface
##

#' Interpret ado code interactively or from a file.
#'
#' An interpreter for a dialect of Stata's ado language. The ado dialect is
#' close to the one Stata provides; see the package vignettes for full details.
#'
#' @param df If NULL, start with an empty dataset; if a data.frame, use a copy
#'           of the data.frame to initialize the dataset.
#' @param filename The path to an ado script to execute. At least one of filename
#'                 and string must be NULL.
#' @param string A length-1 character vector to read command input from. At least
#'                 one of filename and string must be NULL.
#' @param assign.back If TRUE, copy the final dataset state to a variable in the
#'                    caller's environment on function exit. The variable name is
#'                    the name (in the caller's environment) of the data.frame
#'                    passed as the df argument, or if df was NULL, the name "df"
#'                    is used. The effect is to modify the passed data.frame, though
#'                    the old value will not necessarily be garbage-collected.
#' @param debug_level How verbose debug messages should be.
#' @param echo Whether to echo command input. Values 0, 1, and NULL are accepted;
#'             if NULL, echo only when running non-interactively.
#' @param print_results Whether to print command results. Values 0 or 1. The value
#'                      passed here becomes the ado setting "print_results".
#'
#' @return Invisible NULL.
#'
#' @export
#' @useDynLib ado, .registration = TRUE
#' @import Rcpp
ado <-
function(df = NULL, filename=NULL, string=NULL, assign.back=FALSE,
         debug_level = 0, print_results = 1, echo = NULL)
{
    ##
    ## Sanity checks
    ##

    # Make sure file and string aren't both set
    if(!is.null(filename) && !is.null(string))
        stop("Cannot specify both the filename and string arguments")

    # Mke sure we get one of filename and string if not in interactive mode
    if(!interactive() && is.null(filename) && is.null(string))
        stop("Must specify filename or string if not in interactive mode")

    ##
    ## Set up the object to read from
    ##

    if(interactive() && is.null(filename) && is.null(string))
    {
        con <- NULL
    } else if(is.null(filename) && is.null(string))
    {
        con <- stdin()
    } else if(!is.null(filename))
    {
        con <- file(filename, "rb")
        on.exit(close(con), add=TRUE)
    } else
    {
        # It's not important to close this type of connection because (as
        # in the R docs for textConnection) it's not really an OS resource.
        con <- textConnection(string)
    }

    ##
    ## Final setup and run
    ##

    #Should we echo input? Don't echo when interactive and reading from
    #stdin, because then the cmd text is already visible on the console.
    if(is.null(echo))
        echo <- as.numeric(!is.null(con))

    #Should we, on exit, put the final dataset back into the variable
    #we were given as if we had a pointer to it?
    if(is.null(df))
        varname <- "df"
    else
        varname <- deparse(substitute(df))

    obj <- AdoInterpreter$new(df=df, print_results=print_results,
                              debug_level=debug_level, echo=echo)

    on.exit(if(assign.back)
    {
        ret <- as.data.frame(obj$dta$as_data_frame)
        assign(varname, ret, pos=parent.frame())
    })

    obj$interpret(con)

    return(invisible((obj$dta$as_data_frame)))
}

