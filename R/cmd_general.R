#====================================================================
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
    #Similarly, we shouldn't return match.call here because
    #then it's impossible to test loops properly, and this command
    #is pretty simple: its arguments are hard to screw up.
    if(hasOption(option_list, "break"))
        #Whoever thought of "continue, break" should be
        #ashamed of themselves...
        raiseCondition("Break", "BreakException")
    else
        raiseCondition("Continue", "ContinueException")
}

rstata_cmd_do <-
function(expression_list, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    valid_opts <- c("nostop")
    option_list <- validateOpts(option_list, valid_opts)
    nostop <- hasOption(option_list, "nostop")
    
    
}

#The if expr { } construct
rstata_cmd_if <-
function(expression, compound_cmd, return.match.call=NULL)
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

rstata_cmd_query <-
function(varlist=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    #Subcommand is accepted for compatibility but (currently) ignored.
    #If the list of settings settles down in the future, we might implement
    #groups of them that this command can print selectively, the way Stata does.
    raiseifnot(is.null(varlist) || length(varlist) == 1,
               msg="Wrong number of arguments to query")
    
    nm <- allSettings()
    vals <- lapply(nm, getSettingValue)
    names(vals) <- nm
    
    return(structure(vals, class="rstata_cmd_query"))
}

rstata_cmd_set <-
function(expression_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    if(is.null(expression_list))
    {
        return(rstata_cmd_query())
    }
    
    raiseifnot(length(expression_list) == 2,
               msg="Wrong number of arguments to set")
    
    setting <- expression_list[[1]]
    raiseifnot(is.symbol(setting) || is.character(setting),
               msg="Bad setting name")
    if(is.symbol(setting))
    {
        setting <- as.character(setting)
    }
    
    value <- expression_list[[2]]
    if(!is.numeric(value))
    {
        value <- as.character(value)
    }
    
    #Need to handle some settings (seed, rng, rngstate, obs) which affect
    #the R interpreter's internal state, or the dataset object's state,
    #differently from other settings.
    if(setting == "seed")
    {
        if(!is.numeric(value))
        {
            raiseCondition("Bad seed value")
        }
        
        set.seed(value)
    } else if(setting == "rng")
    {
        if(is.numeric(value))
        {
            raiseCondition("Bad RNG kind value")
        }
        
        RNGkind(kind=value)
    } else if(setting == "rngstate")
    {
        if(is.numeric(value))
        {
            raiseCondition("Bad RNG state")
        }
        
        #Deparse the representation in c(rngstate)
        val <- strsplit(value, ",", fixed=TRUE)[[1]]
        val <- vapply(val, as.numeric, numeric(1))
        
        .Random.seed <- val
    } else if(setting == "obs")
    {
        if(!is.numeric(value))
        {
            raiseCondition("Bad # of obs to set")
        }
        
        dt <- get("rstata_dta", envir=rstata_env)
        dt$set_obs(value)
    } else
    {
        env <- get("rstata_settings_env", envir=rstata_env)
        assign(setting, value, envir=env)
    }
    
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
        raiseCondition("Unrecognized subcommand")
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

    #Must be invoked as "return list"
    if(as.character(expression[[1]]) != "list")
    {
        raiseCondition("Unrecognized subcommand")
    }
    
    #Get the values and put them into a list with their names as
    #the list names. This format is easier for the print method
    #to work with.
    nm <- rstata_func_r(enum=TRUE)
    vals <- lapply(nm, rstata_func_r)
    names(vals) <- nm
    
    return(structure(vals, class="rstata_cmd_return"))
}

rstata_cmd_ereturn <-
function(expression, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    #Must be invoked as "ereturn list"
    if(as.character(expression[[1]]) != "list")
    {
        raiseCondition("Unrecognized subcommand")
    }
    
    #Get the values and put them into a list with their names as
    #the list names. This format is easier for the print method
    #to work with.
    nm <- rstata_func_e(enum=TRUE)
    vals <- lapply(nm, rstata_func_e)
    names(vals) <- nm
    
    return(structure(vals, class="rstata_cmd_ereturn"))
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

rstata_cmd_di <- rstata_cmd_display
