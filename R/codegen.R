### Code generation. At this point, we've "weeded" the AST and know it satisfies
### our assumptions. Now it's time to generate a list containing
### one unevaluated call for each Stata command. Next, we'll evaluate these objects
### for a) their side effects, b) values which are objects with print() methods.

### The arguments are as follows:
###     o) node: the AST node to operate on
###     o) context: a reference to the AdoInterpreter instance calling us. In
###        practice, it's the self environment of the calling instance (because
###        environments have reference semantics).
###     o) debug_level: has no effect on codegen's own message output, but it's
###        passed through into the generated code. Calls to commands will be
###        generated with more or less debugging output depending on the value
###        of this argument.

##
## Utility functions used only under codegen()
##

#Take the name of an ado-language operator, whether unary or binary, and return
#a symbol for the R function that implements that operator.
function_for_ado_operator <-
function(name)
{
    #Arithmetic expressions
    if(name %in% c("^", "-", "+", "*", "/", "+", "-"))
        return(as.symbol(name))

    #Logical, relational and other expressions
    if(name %in% c("&", "|", "!", ">", "<", ">=", "<="))
        return(as.symbol(name))

    if(name == "()")
        return(as.symbol("do.call"))

    if(name == "=")
        return(as.symbol("<-"))

    if(name == "[]")
        return(as.symbol("["))

    if(name == "==")
        return(as.symbol("%==%"))

    #Factor operators
    if(name == "c.")
        return(as.symbol("op_cont"))

    if(name == "i.")
        return(as.symbol("op_ind"))

    if(name == "o.")
        return(as.symbol("op_omit"))

    if(name == "ib.")
        return(as.symbol("op_base"))

    if(name == "##")
        return(as.symbol("%##%"))

    if(name == "#")
        return(as.symbol("%#%"))

    if(name == "%anova_nest%")
        return(as.symbol("%anova_nest%"))

    if(name == "%anova_error%")
        return(as.symbol("%anova_error%"))

    #Type constructors
    if(valid_data_type(name))
    {
        if(substr(name, 1, 3) == "str")
        {
            return(as.symbol('ado_type_str'))
        }
        else
        {
            return(as.symbol('ado_type_' %p% name))
        }
    }

    raiseCondition("Bad operator or function", cls="BadCommandException")
}

##
## The code generator
##

codegen <-
function(node, context, debug_level=0)
    UseMethod("codegen")

##############################################################################
## Loops
#' @export
codegen.ado_loop <-
function(node, context, debug_level=0)
{
    NextMethod()
}

#' @export
codegen.ado_foreach <-
function(node, context, debug_level=0)
{
    what <- setdiff(names(node$children), c("macro_name", "text"))
    val <- codegen(node$children[[what]], context=context, debug_level=debug_level)

    ret <- list(as.symbol("ado_foreach"),
                context=context,
                macro_name=codegen(node$children$macro_name, context=context, debug_level=debug_level),
                text=codegen(node$children$text, context=context, debug_level=debug_level))
    ret[[what]] <- val

    as.call(ret)
}

#' @export
codegen.ado_forvalues <-
function(node, context, debug_level=0)
{
    macro_name <- codegen(node$children$macro_name, context=context, debug_level=debug_level)
    text <- codegen(node$children$text, context=context, debug_level=debug_level)

    upper <- codegen(node$children$upper, context=context, debug_level=debug_level)
    lower <- codegen(node$children$lower, context=context, debug_level=debug_level)

    ret <- list(as.symbol("ado_forvalues"),
                context=context,
                macro_name=macro_name,
                text=text,
                upper=upper,
                lower=lower)

    if("increment" %in% names(node$children))
    {
        ret[["increment"]] <- codegen(node$children$increment, context=context, debug_level=debug_level)
    } else if("increment_t" %in% names(node$children))
    {
        ret[["increment_t"]] <- codegen(node$children$increment_t, context=context, debug_level=debug_level)
    }

    as.call(ret)
}

##############################################################################
## Compound and atomic commands
#' @export
codegen.ado_compound_cmd <-
function(node, context, debug_level=0)
{
    lst <- list()
    chlds <- lapply(node$children, function(x) codegen(x, context=context, debug_level=debug_level))

    for(chld in chlds)
        lst[[length(lst)+1]] <- chld

    do.call(expression, lst)
}

#' @export
codegen.ado_if_cmd <-
function(node, context, debug_level=0)
{
    exp <- codegen(node$children$expression, context=context, debug_level=debug_level)
    cmp <- codegen(node$children$compound_cmd, context=context, debug_level=debug_level)

    if(debug_level)
        return.match.call <- TRUE
    else
        return.match.call <- FALSE

    ret <- c(as.symbol("ado_cmd_if"), list(expression=exp, compound_cmd=cmp),
             context=context, return.match.call=return.match.call)

    as.call(ret)
}

#' @export
codegen.ado_embedded_code <-
function(node, context, debug_level=0)
{
    if(node$data["lang"] == "R")
        return(parse(text=node$data["value"]))

    if(node$data["lang"] == "shell")
    {
        cmd <- list(as.symbol("system"), command=node$data["value"], intern=TRUE)
        return(as.call(cmd))
    }
}

#' @export
codegen.ado_cmd <-
function(node, context, debug_level=0)
{
    NextMethod()
}

#' @export
codegen.ado_general_cmd <-
function(node, context, debug_level=0)
{
    name <- as.character(codegen(node$children$verb, context=context, debug_level=debug_level))
    name <- unabbreviateCommand(paste0("ado_cmd_", name))
    verb <- get(name, mode="function")

    args <- node$children
    args <- args[names(args) != "verb"]

    nm <- names(args)
    forms <- names(formals(verb))
    if("expression_list" %in% nm)
    {
        if("expression_list" %in% forms)
            TRUE #do nothing
        if("varlist" %in% forms)
            nm[nm == "expression_list"] <- "varlist"
        if("expression" %in% forms)
            nm[nm == "expression_list"] <- "expression"
    }

    args <- lapply(args, function(x) codegen(x, context=context, debug_level=debug_level))
    names(args) <- nm

    #No data elements in a general command

    if(debug_level)
        return.match.call <- TRUE
    else
        return.match.call <- FALSE

    ret <- c(as.symbol(name), args, context=context,
             return.match.call=return.match.call)

    as.call(ret)
}

#' @export
codegen.ado_modifier_cmd <-
function(node, context, debug_level=0)
{
    name <- as.character(codegen(node$children$verb, context=context, debug_level=debug_level))
    name <- unabbreviateCommand(paste0("ado_cmd_", name))
    verb <- get(name, mode="function")

    if(debug_level)
        return.match.call <- TRUE
    else
        return.match.call <- FALSE

    lst <- list(as.symbol(name), context=context,
                return.match.call=return.match.call)

    as.call(lst)
}

#' @export
codegen.ado_modifier_cmd_list <-
function(node, context, debug_level=0)
{
    lst <- unlist(lapply(node$children, function(x) codegen(x, context=context, debug_level=debug_level)))
    lst <- rev(lst)

    Reduce(function(y, x)
    {
        x[[length(x)+1]] <- y

        #length(x) is one larger now
        names(x)[length(x)] <- "to_call"

        x
    }, lst)
}

##############################################################################
## Command parts
#' @export
codegen.ado_if_clause <-
function(node, context, debug_level=0)
{
    codegen(node$children$if_expression, context=context, debug_level=debug_level)
}

#' @export
codegen.ado_in_clause <-
function(node, context, debug_level=0)
{
    upper <- codegen(node$children$upper, context=context, debug_level=debug_level)
    lower <- upper

    if("lower" %in% names(node$children))
    {
        lower <- codegen(node$children$lower, context=context, debug_level=debug_level)
    }

    list(upper=upper, lower=lower)
}

#' @export
codegen.ado_using_clause <-
function(node, context, debug_level=0)
{
    as.character(codegen(node$children$filename, context=context, debug_level=debug_level))
}

#' @export
codegen.ado_weight_clause <-
function(node, context, debug_level=0)
{
    list(kind=codegen(node$children$left, context=context, debug_level=debug_level),
         weight_expression=codegen(node$children$right, context=context, debug_level=debug_level))
}

#' @export
codegen.ado_option <-
function(node, context, debug_level=0)
{
    if("args" %in% names(node$children))
        list(name=codegen(node$children$name, context=context, debug_level=debug_level),
             args=codegen(node$children$args, context=context, debug_level=debug_level))
    else
        list(name=codegen(node$children$name, context=context, debug_level=debug_level))
}

#' @export
codegen.ado_option_list <-
function(node, context, debug_level=0)
{
    nm <- names(node$children)
    ret <- lapply(node$children, function(x) codegen(x, context=context, debug_level=debug_level))
    names(ret) <- nm

    ret
}

##############################################################################
## Lists of expressions
#' @export
codegen.ado_expression_list <-
function(node, context, debug_level=0)
{
    lapply(node$children, function(x) codegen(x, context=context, debug_level=debug_level))
}

#' @export
codegen.ado_argument_expression_list <-
function(node, context, debug_level=0)
{
    flatten(lapply(node$children, function(x) codegen(x, context=context, debug_level=debug_level)))
}

##############################################################################
## Expression branch nodes
#' @export
codegen.ado_expression <-
function(node, context, debug_level=0)
{
    #Get the function to call and its arguments in lists
    op <- node$data["verb"]
    args <- node$children[names(node$children) != "verb"]

    #If we want to be able to pass this function to do.call, it can't
    #have a name like "c" that masks something important from base R.
    #This is kind of a hack, but it works...
    if(op == "()")
    {
        args$left$data["value"] <- paste0("ado_func_", args$left$data["value"])
    }

    op <- function_for_ado_operator(op)
    args <- lapply(args, function(x) codegen(x, context=context, debug_level=debug_level))
    names(args) <- NULL

    if(op == "()")
    {
        args <- c(args, context=context)
    }

    as.call(c(list(op), args))
}

##############################################################################
## Literal expressions
#' @export
codegen.ado_literal <-
function(node, context, debug_level=0)
{
    NextMethod()
}

#' @export
codegen.ado_ident <-
function(node, context, debug_level=0)
{
    as.symbol(node$data["value"])
}

#' @export
codegen.ado_number <-
function(node, context, debug_level=0)
{
    if(node$data["value"] == ".")
        NA
    else
        as.numeric(node$data["value"])
}

#' @export
codegen.ado_string_literal <-
function(node, context, debug_level=0)
{
    val <- as.character(node$data["value"])

    if(val == "")
        NA
    else
        val
}

#' @export
codegen.ado_datetime <-
function(node, context, debug_level=0)
{
    as.POSIXct(node$data["value"])
}

#' @export
codegen.ado_format_spec <-
function(node, context, debug_level=0)
{
    val <- as.character(node$data["value"])

    structure(val, class=c(class(val), "format_spec"))
}

