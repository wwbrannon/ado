## Add user-defined commands provided at runtime, rather than defined in this
## package's source.

ado_cmd_addCommand <-
function(context, expression, option_list=NULL)
{
    valid_opts <- c("env", "newname")
    option_list <- validateOpts(option_list, valid_opts)

    #Figure out which environment we should look for this function in
    if(hasOption(option_list, "env"))
    {
        env <- optionArgs(option_list, "env")
        raiseif(is.null(env), msg="Must provide an environment with option env")
        raiseif(length(env) > 1, msg="Too many envs")
        env <- env[[1]]

        #Get the environment
        env <- tryCatch(as.environment(env), error=function(e) e)
        raiseif(inherits(env, "error"), msg="No such environment")
    } else
    {
        env <- globalenv()
    }

    #Figure out what name we should use for it
    if(hasOption(option_list, "newname"))
    {
        nm <- optionArgs(option_list, "newname")
        raiseif(is.null(nm), msg="Must provide a new name with option newname")
        raiseif(length(nm) > 1, msg="Too many new names")

        nm <- nm[[1]]
    } else
    {
        nm <- as.character(expression)
    }

    #Get the function from the environment
    src <- as.character(expression)
    fn <- tryCatch(get(src, envir=env, mode="function", inherits=FALSE),
                   error=function(e) e)
    raiseif(inherits(fn, "error"), msg="No such function")

    context$usercmd_set('ado_cmd_' %p% nm, fn)

    return(invisible(NULL))
}

