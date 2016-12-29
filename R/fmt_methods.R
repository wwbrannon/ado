## The convention here is: every fmt method should include a newline at the
## end of its return value. That's not (currently) done by a call to a
## superlcass method, but all methods need to do it to ensure consistent
## output formatting.

fmt <-
function(x)
{
    UseMethod("fmt")
}

#' @export
fmt.default <-
function(x)
{
    return(paste0(capture.output(print(x)), collapse='\n'))
}

#' @export
fmt.ado_cmd_insheet <-
function(x)
{
    msg <- paste0("(", x[2], " vars, ", x[1], " obs)")
    
    msg <- msg %p% '\n'
    return(msg)
}

#' @export
fmt.ado_cmd_save <-
function(x)
{
    msg <- paste0("file ", x, " saved")
    
    msg <- msg %p% '\n'
    return(msg)
}

#' @export
fmt.ado_cmd_use <-
function(x)
{
    msg <- paste0("(", x, ")")
    
    msg <- msg %p% '\n'
    return(msg)
}

#' @export
fmt.ado_cmd_sysuse <-
function(x)
{
    NextMethod()
}

#' @export
fmt.ado_cmd_about <-
function(x)
{
    NextMethod()
}

#' @export
fmt.ado_cmd_display <-
function(x)
{
    msg <- ""

    if(length(x) == 0)
    {
        msg <- msg %p% " "
    } else if(is.na(x))
    {
        msg <- msg %p% "."
    } else
    {
        msg <- msg %p% x
    }
    
    msg <- msg %p% '\n'
    return(msg)
}

#' @export
fmt.ado_cmd_creturn <-
function(x)
{
    msg <- "System Values: \n\n"

    for(nm in names(x))
    {
        msg <- msg %p% "c(" %p% nm %p% "):    " %p% x[[nm]] %p% "\n"
    }
    
    return(msg)
}

#' @export
fmt.ado_cmd_return <-
function(x)
{
    msg <- "r()-class values: \n\n"

    for(nm in names(x))
    {
        msg <- "r(" %p% nm %p% "):    " %p% x[[nm]] %p% "\n"
    }
    
    return(msg)
}

#' @export
fmt.ado_cmd_ereturn <-
function(x)
{
    msg <- "e()-class values: \n\n"

    for(nm in names(x))
    {
        msg <- "e(" %p% nm %p% "):    " %p% x[[nm]] %p% "\n"
    }
    
    return(msg)
}

#' @export
fmt.ado_cmd_sample <-
function(x)
{
    msg <- "(" %p% as.character(x) %p% " observations deleted)\n"

    return(msg)
}

#' @export
fmt.ado_cmd_query <-
function(x)
{
    msg <- "Setting Values: \n\n"

    for(nm in names(x))
    {
        msg <- msg %p% "set " %p% nm %p% ":    " %p% x[[nm]] %p% "\n"
    }
    
    return(msg)
}
