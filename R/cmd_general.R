#====================================================================
## First, things that are more nearly flow-control constructs than
## "commands" in the usual sense
ado_cmd_quit <-
function(return.match.call=FALSE)
{
    #Don't do anything with return.match.call because otherwise we can't get
    #out of ado() when testing with return.match.call
    raiseCondition("Exit requested", "ExitRequestedException")
}

ado_cmd_continue <-
function(option_list=NULL, return.match.call=FALSE)
{
    #Similarly, we shouldn't return match.call here because
    #then it's impossible to test loops properly, and this command
    #is pretty simple: its arguments are hard to screw up.
    valid_opts <- c("break")
    option_list <- validateOpts(option_list, valid_opts)
    brk <- hasOption(option_list, "break")

    if(brk)
        raiseCondition("Break", "BreakException")
    else
        raiseCondition("Continue", "ContinueException")
}

ado_cmd_do <-
function(expression_list, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    filename <- as.character(expression_list[[1]])
    if(tools::file_ext(filename) == "")
    {
        filename <- filename %p% ".do"
    }

    #Set numbered macros if there are any
    if(length(expression_list) > 1)
    {
        vals <- expression_list[2:length(expression_list)]
        inds <- seq_along(vals)

        for(ind in inds)
        {
            mname <- as.symbol(as.character(ind))
            val <- as.character(vals[ind])

            ado_cmd_local(expression_list=list(mname, val))
        }
    }

    #Set up the connection and execute what's in it, echoing the commands
    #even if we're interactive and that normally wouldn't be done.
    con <- file(filename, "rb")
    on.exit(close(con), add=TRUE)
    repl(con, echo=1)

    #Finally, tear down the numbered macros
    if(length(expression_list) > 1)
    {
        for(ind in inds)
        {
            mname <- as.symbol(as.character(ind))
            ado_cmd_local(expression_list=list(mname))
        }
    }

    return(invisible(TRUE))
}

#The if expr { } construct
ado_cmd_if <-
function(expression, compound_cmd, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_exit <- ado_cmd_quit
ado_cmd_run <- ado_cmd_do

#====================================================================
## Now, more normal commands
ado_cmd_about <-
function(return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    fields <- c("Package", "Authors@R", "Version", "Title", "License", "URL", "BugReports")
    desc <- utils::packageDescription(utils::packageName(), fields=fields)

    return(structure(desc, class=c("ado_cmd_about", class(desc))))
}

ado_cmd_sleep <-
function(expression, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    Sys.sleep(expression[[1]])

    return(invisible(NULL))
}

ado_cmd_display <-
function(expression, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    ret <- eval(expression[[1]])
    return(structure(ret, class=c("ado_cmd_display", class(ret))))
}

ado_cmd_preserve <-
function(option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("memory")
    option_list <- validateOpts(option_list, valid_opts)

    mem <- hasOption(option_list, "memory")

    dt <- get("ado_dta", envir=ado_env)
    dt$preserve(memory=mem)

    return(invisible(NULL))
}

ado_cmd_restore <-
function(option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("not")
    option_list <- validateOpts(option_list, valid_opts)

    cancel <- hasOption(option_list, "not")

    dt <- get("ado_dta", envir=ado_env)
    dt$restore(cancel=cancel)

    return(invisible(NULL))
}

ado_cmd_query <-
function(varlist=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    #Subcommand is accepted for compatibility but (currently) ignored.
    #If the list of settings settles down in the future, we might implement
    #groups of them that this command can print selectively, the way Stata does.
    raiseifnot(is.null(varlist) || length(varlist) == 1,
               msg="Wrong number of arguments to query")

    nm <- allSettings()
    vals <- lapply(nm, getSettingValue)
    names(vals) <- nm

    return(structure(vals, class="ado_cmd_query"))
}

ado_cmd_set <-
function(expression_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    if(is.null(expression_list))
    {
        return(ado_cmd_query())
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

        dt <- get("ado_dta", envir=ado_env)
        dt$set_obs(value)
    } else
    {
        env <- get("ado_settings_env", envir=ado_env)
        assign(setting, value, envir=env)
    }

    return(invisible(NULL))
}

ado_cmd_creturn <-
function(expression, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    #Must be invoked as "creturn list"
    if(as.character(expression[[1]]) != "list")
    {
        raiseCondition("Unrecognized subcommand")
    }

    #Get the values and put them into a list with their names as
    #the list names. This format is easier for the print method
    #to work with.
    nm <- ado_func_c(enum=TRUE)
    vals <- lapply(nm, ado_func_c)
    names(vals) <- nm

    return(structure(vals, class="ado_cmd_creturn"))
}

ado_cmd_return <-
function(expression, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    #Must be invoked as "return list"
    if(as.character(expression[[1]]) != "list")
    {
        raiseCondition("Unrecognized subcommand")
    }

    nm <- ado_func_r(enum=TRUE)
    vals <- lapply(nm, ado_func_r)
    names(vals) <- nm

    return(structure(vals, class="ado_cmd_return"))
}

ado_cmd_ereturn <-
function(expression, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    #Must be invoked as "ereturn list"
    if(as.character(expression[[1]]) != "list")
    {
        raiseCondition("Unrecognized subcommand")
    }

    nm <- ado_func_e(enum=TRUE)
    vals <- lapply(nm, ado_func_e)
    names(vals) <- nm

    return(structure(vals, class="ado_cmd_ereturn"))
}

ado_cmd_log <-
function(expression_list=NULL, using_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("append", "replace", "text", "smcl", "name")
    option_list <- validateOpts(option_list, valid_opts)

    raiseif(!is.null(using_clause) && !is.null(expression_list),
            msg="Cannot specify using clause and a subcommand")

    lg <- get("ado_logger", envir=ado_env)

    if(is.null(using_clause) && is.null(expression_list))
    {
        raiseifnot(is.null(option_list), msg="Cannot specify options here")

        msg <- "Open logging sinks: \n\n"
        for(con in lg$log_sinks)
        {
            msg <- msg %p% con
        }

        return(msg)
    } else if(!is.null(using_clause))
    {
        raiseif(hasOption(option_list, "smcl"), msg="SMCL is not supported")

        lg$register_sink(using_clause, type="log")
    } else #we have a subcommand
    {
        raiseifnot(is.null(option_list), msg="Cannot specify options here")

        cmd <- as.character(expression_list[[1]])
        raiseifnot(cmd %in% c("query", "close", "off", "on"))

        if(cmd == "query")
        {
            msg <- "Open logging sinks: \n\n"
            for(con in lg$log_sinks)
            {
                msg <- msg %p% con
            }

            return(msg)
        } else if(cmd == "close")
        {
            raiseif(length(expression_list) %not_in% c(1,2),
                    msg="Incorrect number of arguments to log close")

            if(length(expression_list) == 1)
            {
                lg$deregister_all_sinks(type="log")
            } else
            {
                lg$deregister_sink(as.character(expression_list[[2]]))
            }
        } else if(cmd == "on")
        {
            lg$log_enabled <- TRUE
        } else if(cmd == "off")
        {
            lg$log_enabled <- FALSE
        }
    }

    return(invisible(NULL))
}

ado_cmd_cmdlog <-
function(expression_list=NULL, using_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("append", "replace", "permanently")
    option_list <- validateOpts(option_list, valid_opts)

    raiseif(!is.null(using_clause) && !is.null(expression_list),
            msg="Cannot specify using clause and a subcommand")

    lg <- get("ado_logger", envir=ado_env)

    if(is.null(using_clause) && is.null(expression_list))
    {
        raiseifnot(is.null(option_list), msg="Cannot specify options here")

        msg <- "Open command logging sinks: \n\n"
        for(con in lg$cmdlog_sinks)
        {
            msg <- msg %p% con
        }

        return(msg)
    } else if(!is.null(using_clause))
    {
        raiseif(hasOption(option_list, "permanently"),
                msg="Permanent option setting is not supported")

        lg$register_sink(using_clause, type="cmdlog")
    } else #we have a subcommand
    {
        raiseifnot(is.null(option_list), msg="Cannot specify options here")

        cmd <- as.character(expression_list[[1]])
        raiseifnot(cmd %in% c("close", "off", "on"))

        if(cmd == "close")
        {
            raiseif(length(expression_list) %not_in% c(1,2),
                    msg="Incorrect number of arguments to cmdlog close")

            if(length(expression_list) == 1)
            {
                lg$deregister_all_sinks(type="cmdlog")
            } else
            {
                lg$deregister_sink(as.character(expression_list[[2]]))
            }
        } else if(cmd == "on")
        {
            lg$cmdlog_enabled <- FALSE
        } else if(cmd == "off")
        {
            lg$cmdlog_enabled <- FALSE
        }
    }

    return(invisible(NULL))
}

ado_cmd_help <-
function(expression, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_di <- ado_cmd_display

