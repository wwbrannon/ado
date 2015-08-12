## Macro management commands

rstata_cmd_local <-
function(expression_list, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    env <- get("rstata_macro_env", envir=rstata_env)
    exprs <- expression_list

    #FIXME should incorporate the "set to nothing" way of clearing a macro
    if(length(exprs) == 1) #either an assignment or an attempt to clear this macro
    {
        stmt <- exprs[[1]]
        raiseifnot(stmt[[1]] == as.symbol("<-"), cls="EvalErrorException",
                   msg="Bad macro assignment")

        val <- eval(stmt[[3]]) #the RHS
        val <- as.character(val)

        nm <- paste0("_", as.character(stmt[[2]]))
        assign(nm, val, envir=env)
    } else if(length(exprs) == 2)
    {
        raiseifnot(is.symbol(exprs[[1]]) || is.character(exprs[[1]]),
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
        raiseifnot(stmt[[1]] == as.symbol("<-"), cls="EvalErrorException",
                   msg="Bad macro assignment")

        val <- eval(stmt[[3]]) #the RHS
        val <- as.character(val)

        assign(as.character(stmt[[2]]), val, envir=env)
    } else if(length(exprs) == 2)
    {
        raiseifnot(is.symbol(exprs[[1]]) || is.character(exprs[[1]]),
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
        raiseifnot(is.symbol(nm) || is.character(nm), cls="EvalErrorException",
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
        raiseifnot(is.symbol(exprs[[2]]) || is.character(exprs[[2]]),
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

