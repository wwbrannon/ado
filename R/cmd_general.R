## First, things that are more nearly flow-control constructs than
## "commands" in the usual sense

rstata_cmd_quit <-
function(return.match.call=NULL)
{
    #Don't do anything with return.match.call because otherwise we can't get
    #out of rstata() when testing with return.match.call
    raiseCondition("Exit requested", "ExitRequestedException")
}

rstata_cmd_continue <-
function(option_list=NULL, return.match.call=NULL)
{
    if(hasOption(option_list, "break"))
        raiseCondition("Break", "BreakException")
    else
        raiseCondition("Continue", "ContinueException")
    
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

#The if expr { } construct
rstata_cmd_if <-
function(expression, compound_cmd, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_do <-
function(expression_list, options=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_exit <- rstata_cmd_quit
rstata_cmd_run <- rstata_cmd_do

#====================================================================
## Now, more normal commands
rstata_cmd_about <-
function(return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    fields <- c("Package", "Authors@R", "Version", "Title", "License", "URL", "BugReports")
    desc <- packageDescription(packageName(), fields=fields)
    
    return(structure(desc, class=c("rstata_cmd_about", class(desc))))
}

rstata_cmd_sleep <-
function(expression, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    Sys.sleep(expression[[1]])
    
    return(invisible(NULL))
}

rstata_cmd_display <-
function(expression, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    ret <- eval(expression[[1]])
    return(structure(ret, class=c("rstata_cmd_display", class(ret))))
}

rstata_cmd_preserve <-
function(option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    valid_opts <- c("memory")
    option_list <- validateOpts(option_list, valid_opts)
    
    mem <- hasOption(option_list, "memory")
    
    dt <- get("rstata_dta", envir=rstata_env)
    dt$preserve(memory=mem)
    
    return(invisible(NULL))
}

rstata_cmd_restore <-
function(option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    valid_opts <- c("not")
    option_list <- validateOpts(option_list, valid_opts)
    
    cancel <- hasOption(option_list, "not")
    
    dt <- get("rstata_dta", envir=rstata_env)
    dt$restore(cancel=cancel)
    
    return(invisible(NULL))
}

rstata_cmd_creturn <-
function(expression, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    #Must be invoked as "creturn list"
    if(as.character(expression[[1]]) != "list")
    {
        raiseCondition("Unrecognized subcommand to creturn")
    }
    
    #Get the values and put them into a list with their names as
    #the list names. This format is easier for the print method
    #to work with.
    nm <- rstata_func_c(enum=TRUE)
    vals <- lapply(nm, rstata_func_c)
    names(vals) <- nm
    
    return(structure(vals, class="rstata_cmd_creturn"))
}

rstata_cmd_return <-
function(expression, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_ereturn <-
function(expression, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_help <-
function(expression_list, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_log <-
function(expression_list=NULL, using_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_query <-
function(varlist, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_set <-
function(expression_list, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_di <- rstata_cmd_display
