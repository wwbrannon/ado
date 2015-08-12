## Macro management commands

rstata_cmd_local <-
function(expression_list)
{
    env <- get("rstata_macro_env", envir=rstata_env)
    exprs <- expression_list

    if(length(exprs) == 1) #an assignment
    {
        stmt <- exprs[[1]]
        raiseifnot(stmt[[1]] == as.symbol("<-"), "EvalErrorException")

        val <- eval(stmt[[3]]) #the RHS
        val <- as.character(val)

        nm <- paste0("_", as.character(stmt[[2]]))
        assign(nm, val, envir=env)
    } else if(length(exprs) == 2)
    {
        raiseifnot(is.symbol(exprs[[1]]) || is.character(exprs[[1]]), "EvalErrorException")
        raiseifnot(is.character(exprs[[2]]), "EvalErrorException")

        nm <- paste0("_", as.character(exprs[[1]]))
        assign(nm, exprs[[2]], envir=env)
    } else
    {
        raiseCondition("Bad macro assignment", "EvalErrorException")
    }

    invisible(TRUE)
}

#FIXME need to implement the "_all" special name
rstata_cmd_global <-
function(expression_list)
{
    env <- get("rstata_macro_env", envir=rstata_env)
    exprs <- expression_list

    if(length(exprs) == 1) #an assignment
    {
        stmt <- exprs[[1]]
        raiseifnot(stmt[[1]] == as.symbol("<-"), "EvalErrorException")

        val <- eval(stmt[[3]]) #the RHS
        val <- as.character(val)

        assign(as.character(stmt[[2]]), val, envir=env)
    } else if(length(exprs) == 2)
    {
        raiseifnot(is.symbol(exprs[[1]]) || is.character(exprs[[1]]), "EvalErrorException")
        raiseifnot(is.character(exprs[[2]]), "EvalErrorException")

        assign(as.character(exprs[[1]]), exprs[[2]], envir=env)
    } else
    {
        raiseCondition("Bad macro assignment", "EvalErrorException")
    }

    invisible(TRUE)
}

rstata_cmd_tempfile <-
function(expression_list)
{
    env <- get("rstata_macro_env", envir=rstata_env)
    exprs <- expression_list

    raiseifnot(length(exprs) >= 1, "EvalErrorException")
    for(nm in exprs)
    {
        raiseifnot(is.symbol(nm) || is.character(nm), "EvalErrorException")

        val <- paste0("_", as.character(nm))
        assign(val, tempfile(), envir=env)
    }

    invisible(TRUE)
}

rstata_cmd_macro <-
function(expression_list)
{
    env <- get("rstata_macro_env", envir=rstata_env)
    exprs <- expression_list

    raiseifnot(length(exprs) >= 1, "EvalErrorException")
    what <- as.character(exprs[[1]])
    raiseifnot(what %in% c("drop", "dir", "list", "local", "global", "tempfile"),
               "EvalErrorException")

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
        raiseifnot(length(exprs) == 2)
        raiseifnot(is.symbol(exprs[[2]]) || is.character(exprs[[2]]))

        #FIXME - how does Stata handle local vs global macros for drop?
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
