## Macro management commands

rstata_cmd_local <-
function(expression_list, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    env <- get("rstata_macro_env", envir=rstata_env)
    exprs <- expression_list

    #Either an assignment or an attempt to clear this macro
    if(length(exprs) == 1)
    {
        stmt <- exprs[[1]]

        if(is.symbol(stmt))
        {
            #clear the macro
            nm <- paste0("_", as.character(stmt))
            rm(list=nm, envir=env)
        } else if(is.call(stmt) && stmt[[1]] == as.symbol("<-"))
        {
            #set the macro
            val <- as.character(eval(stmt[[3]])) #the RHS

            nm <- paste0("_", as.character(stmt[[2]]))
            assign(nm, val, envir=env)
        } else
        {
            raiseCondition("Bad macro assignment", cls="EvalErrorException")
        }
    } else if(length(exprs) == 2)
    {
        raiseifnot(is.symbol(exprs[[1]]),
                   cls="EvalErrorException", msg="Invalid macro name")
        raiseifnot(is.character(exprs[[2]]), cls="EvalErrorException",
                   msg="Attempt to set macro to non-string value")

        nm <- paste0("_", as.character(exprs[[1]]))
        assign(nm, exprs[[2]], envir=env)
    } else
    {
        raiseCondition("Bad macro assignment", "EvalErrorException")
    }

    invisible(TRUE)
}

rstata_cmd_global <-
function(expression_list, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    env <- get("rstata_macro_env", envir=rstata_env)
    exprs <- expression_list

    if(length(exprs) == 1) #an assignment
    {
        stmt <- exprs[[1]]

        if(is.symbol(stmt))
        {
            #clear the macro
            rm(list=as.character(stmt), envir=env)
        } else if(is.call(stmt) && stmt[[1]] == as.symbol("<-"))
        {
            #set the macro
            val <- as.character(eval(stmt[[3]])) #the RHS

            assign(as.character(stmt[[2]]), val, envir=env)
        } else
        {
            raiseCondition("Bad macro assignment", cls="EvalErrorException")
        }
    } else if(length(exprs) == 2)
    {
        raiseifnot(is.symbol(exprs[[1]]),
                   cls="EvalErrorException", msg="Invalid macro name")
        raiseifnot(is.character(exprs[[2]]), cls="EvalErrorException",
                   msg="Attempt to set macro to non-string value")

        assign(as.character(exprs[[1]]), exprs[[2]], envir=env)
    } else
    {
        raiseCondition("Bad macro assignment", "EvalErrorException")
    }

    invisible(TRUE)
}

rstata_cmd_tempfile <-
function(expression_list, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    env <- get("rstata_macro_env", envir=rstata_env)
    exprs <- expression_list

    raiseifnot(length(exprs) >= 1, cls="EvalErrorException",
               msg="No macro name given")
    for(nm in exprs)
    {
        raiseifnot(is.symbol(nm), cls="EvalErrorException",
                   msg="Invalid macro name")

        val <- paste0("_", as.character(nm))
        assign(val, tempfile(), envir=env)
    }

    invisible(TRUE)
}

rstata_cmd_macro <-
function(expression_list, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    env <- get("rstata_macro_env", envir=rstata_env)
    exprs <- expression_list

    raiseifnot(length(exprs) >= 1, cls="EvalErrorException",
               msg="Invalid macro command")
    what <- as.character(exprs[[1]])
    raiseifnot(what %in% c("drop", "dir", "list", "local", "global", "tempfile"),
               cls="EvalErrorException", msg="Invalid macro command")

    if(what == "local")
    {
        return(rstata_cmd_local(exprs[-1]))
    } else if(what == "global")
    {
        return(rstata_cmd_global(exprs[-1]))
    } else if(what == "tempfile")
    {
        return(rstata_cmd_tempfile(exprs[-1]))
    } else if(what == "drop")
    {
        raiseifnot(length(exprs) == 2, cls="EvalErrorException",
                   msg="Invalid macro drop command")
        raiseifnot(is.symbol(exprs[[2]]),
                   cls="EvalErrorException", msg="Invalid macro name")

        #if you want to drop a local macro, just drop it with its full
        #name that begins with an underscore
        del <- as.character(exprs[[2]])
        if(del == "_all")
            rm(list=ls(envir=env), envir=env)
        else
            rm(list=del, envir=env)
    } else if(what == "dir" || what == "list")
    {
        #we don't need to worry about using deparse because only
        #character vectors can ever have been assigned to this environment
        return(mget(ls(envir=env), envir=env))
    }

    invisible(TRUE)
}

