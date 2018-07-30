## Add user-defined commands provided at runtime, rather than defined in this
## package's source. Even by R standards, this is arcane: it relies on a poorly
## documented (but very stable) set of C macros in the R source code to unlock
## the package environment and inject the user's function. See our C++ function
## that wraps around those macros in src/unlockEnvironment.cpp.

## Here's essentially what we're doing:
# foo <- function(x) x+1
# foo(3)
#
# env <- getNamespace('stats')
# environmentIsLocked(env)
#
# #throws an error
# assign("foo", foo, env)
#
# #not anymore
# ado:::unlockEnvironment(env) # our C++ function
# environmentIsLocked(env)
#
# environment(foo) <- getNamespace('stats')
# assign("foo", foo, env)
#
# lockEnvironment(env)
# environmentIsLocked(env)
#
# stats:::foo

ado_cmd_addCommand <-
function(expression, option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

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

    # possible FIXME? should we allow overriding objects that ship with ado?

    #Get the function from the environment
    src <- as.character(expression)
    fn <- tryCatch(get(src, envir=env, mode="function", inherits=FALSE),
                   error=function(e) e)
    raiseif(inherits(fn, "error"), msg="No such function")

    #Unlock the package environment, make the binding, and relock
    pkenv <- getNamespace('ado')
    if(environmentIsLocked(pkenv))
    {
        unlockEnvironment(pkenv)
    }

    environment(fn) <- pkenv
    assign(paste0('ado_cmd_', nm), fn, pkenv) #need this prefix for codegen
    lockEnvironment(pkenv)

    return(invisible(NULL))
}

