## Macro management commands
##
## KNOWN BUG: String literal assignment doesn't parse
## ===================================================
## The parser (src/parser/ado.ypp) currently rejects string literal assignment:
##
##   local str "world"           # Parse error: unexpected STRING_LITERAL
##   local str = "world"         # Parse error: unexpected =
##
## The R implementation below (lines 39-51) DOES support the two-argument form
## where exprs[[2]] is a character string, but the Bison grammar doesn't allow
## STRING_LITERAL in assignment expressions or as standalone expressions in
## expression_list.
##
## This works:
##   local x = 5                 # Numeric assignment
##   local str = "foo" + "bar"   # String expression (if supported)
##
## This fails:
##   local str = "world"         # String literal on RHS of =
##   local str "world"           # String literal as second expression
##
## Root cause: The grammar expects STRING_LITERAL only in literal_expression,
## but somewhere in the chain literal_expression → primary_expression → ... →
## logical_expression → expression, string literals aren't accepted in assignment
## context. The error "expecting ( or IDENT" suggests the parser sees the string
## and expects a function call or another identifier.
##
## Fix needed: Trace through ado.ypp to find where string literals are rejected.

ado_cmd_local <-
function(context, expression_list)
{
    if(context$debug_match_call)
        return(match.call())

    exprs <- expression_list

    #Either an assignment or an attempt to clear this macro
    if(length(exprs) == 1)
    {
        stmt <- exprs[[1]]

        if(is.symbol(stmt))
        {
            #Clear the macro. It's not an error if it isn't set.
            nm <- paste0("_", as.character(stmt))
            context$macro_unset(nm)
        } else if(is.call(stmt) && stmt[[1]] == as.symbol("<-"))
        {
            max_macro_namelen <- context$cclass_value("max_macro_namelen")
            raiseifnot(nchar(as.character(stmt[[2]])) <= max_macro_namelen,
                       cls="EvalErrorException",
                       msg="Macro name too long")

            #Disallow macro values long enough to overflow yylex's buffer
            val <- as.character(eval(stmt[[3]])) #the RHS
            raiseifnot(nchar(val) <= 65436, cls="EvalErrorException",
                       msg="Macro value too long")

            nm <- paste0("_", as.character(stmt[[2]]))
            context$macro_set(nm, val)
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
        raiseifnot(nchar(as.character(exprs[[1]])) <= 31, cls="EvalErrorException",
                   msg="Macro name too long")
        raiseifnot(nchar(exprs[[2]]) <= 65436, cls="EvalErrorException",
                   msg="Macro value too long")

        nm <- paste0("_", as.character(exprs[[1]]))
        context$macro_set(nm, exprs[[2]])
    } else
    {
        raiseCondition("Bad macro assignment", "EvalErrorException")
    }

    invisible(TRUE)
}

ado_cmd_global <-
function(context, expression_list)
{
    if(context$debug_match_call)
        return(match.call())

    exprs <- expression_list

    if(length(exprs) == 1) #an assignment
    {
        stmt <- exprs[[1]]

        if(is.symbol(stmt))
        {
            #clear the macro
            context$macro_unset(as.character(stmt))
        } else if(is.call(stmt) && stmt[[1]] == as.symbol("<-"))
        {
            max_macro_namelen <- context$cclass_value("max_macro_namelen")
            raiseifnot(nchar(as.character(stmt[[2]])) <= max_macro_namelen,
                       cls="EvalErrorException",
                       msg="Macro name too long")

            #set the macro
            val <- as.character(eval(stmt[[3]])) #the RHS
            raiseifnot(nchar(val) <= 65436, cls="EvalErrorException",
                       msg="Macro value too long")

            context$macro_set(as.character(stmt[[2]]), val)
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
        raiseifnot(nchar(as.character(exprs[[1]])) <= 32, cls="EvalErrorException",
                   msg="Macro name too long")
        raiseifnot(nchar(exprs[[2]]) <= 65436, cls="EvalErrorException",
                   msg="Macro value too long")

        context$macro_set(as.character(exprs[[1]]), exprs[[2]])
    } else
    {
        raiseCondition("Bad macro assignment", "EvalErrorException")
    }

    invisible(TRUE)
}

ado_cmd_tempfile <-
function(context, expression_list)
{
    if(context$debug_match_call)
        return(match.call())

    exprs <- expression_list

    raiseifnot(length(exprs) >= 1, cls="EvalErrorException",
               msg="No macro name given")

    for(nm in exprs)
    {
        raiseifnot(is.symbol(nm), cls="EvalErrorException",
                   msg="Invalid macro name")

        val <- paste0("_", as.character(nm))

        max_macro_namelen <- context$cclass_value("max_macro_namelen")
        raiseifnot(nchar(val) <= max_macro_namelen,
                   cls="EvalErrorException",
                   msg="Macro name too long")

        context$macro_set(val, tempfile())
    }

    invisible(TRUE)
}

ado_cmd_macro <-
function(context, expression_list)
{
    if(context$debug_match_call)
        return(match.call())

    exprs <- expression_list

    raiseifnot(length(exprs) >= 1, cls="EvalErrorException",
               msg="Invalid macro command")
    what <- as.character(exprs[[1]])
    raiseifnot(what %in% c("drop", "dir", "list", "local", "global", "tempfile"),
               cls="EvalErrorException", msg="Invalid macro command")

    if(what == "local")
    {
        return(ado_cmd_local(context=context, expression_list=exprs[-1]))
    } else if(what == "global")
    {
        return(ado_cmd_global(context=context, expression_list=exprs[-1]))
    } else if(what == "tempfile")
    {
        return(ado_cmd_tempfile(context=context, expression_list=exprs[-1]))
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
            del <- names(context$macro_all())

        for(nm in del)
            context$macro_unset(nm)
    } else if(what == "dir" || what == "list")
    {
        #we don't need to worry about using deparse because only
        #character vectors can ever have been assigned to this table
        return(context$macro_all())
    }

    invisible(TRUE)
}

