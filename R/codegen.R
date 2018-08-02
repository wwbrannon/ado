### Code generation. At this point, we've "weeded" the AST and know it satisfies
### our assumptions. Now it's time to generate a list containing
### one unevaluated call for each Stata command. Next, we'll evaluate these objects
### for a) their side effects, b) values which are objects with print() methods.

### The arguments are as follows:
###     o) node: the AST node to operate on
###     o) context: a reference to the AdoInterpreter instance calling us. In
###        practice, it's the self environment of the calling instance (because
###        environments have reference semantics).

##
## Utility functions used only under codegen()
##

# Take the name of an ado-language operator, whether unary or binary, and return
# a symbol for the R function that implements that operator, as well as a flag
# for whether to pass the context field.
function_for_ado_operator <-
function(name)
{
    if(name %in% c("^", "-", "+", "*", "/", "+", "-"))
    {
        ret <- as.symbol(name) #Arithmetic expressions
        context <- FALSE
    } else if(name %in% c("&", "|", "!", ">", "<", ">=", "<="))
    {
        ret <- as.symbol(name) #Logical, relational and other expressions
        context <- FALSE
    } else if(name == "()")
    {
        ret <- as.symbol("do.call")
        context <- TRUE
    } else if(name == "=")
    {
        ret <- as.symbol("<-")
        context <- FALSE
    } else if(name == "[]")
    {
        ret <- as.symbol("[")
        context <- FALSE
    } else if(name == "==")
    {
        ret <- as.symbol("%==%")
        context <- TRUE
    } else if(name == "c.")
    {
        ret <- as.symbol("op_cont") #Factor operators
        context <- TRUE
    } else if(name == "i.")
    {
        ret <- as.symbol("op_ind")
        context <- TRUE
    } else if(name == "o.")
    {
        ret <- as.symbol("op_omit")
        context <- TRUE
    } else if(name == "ib.")
    {
        ret <- as.symbol("op_base")
        context <- TRUE
    } else if(name == "##")
    {
        ret <- as.symbol("%##%")
        context <- TRUE
    } else if(name == "#")
    {
        ret <- as.symbol("%#%")
        context <- TRUE
    } else if(name == "%anova_nest%")
    {
        ret <- as.symbol("%anova_nest%")
        context <- TRUE
    } else if(name == "%anova_error%")
    {
        ret <- as.symbol("%anova_error%")
        context <- TRUE
    } else if(valid_data_type(name))
    {
        #Type constructors
        if(substr(name, 1, 3) == "str")
            ret <- as.symbol('ado_type_str')
        else
            ret <- as.symbol('ado_type_' %p% name)

        context <- TRUE
    } else
        raiseCondition("Bad operator or function", cls="BadCommandException")

    return(list(symbol=ret, context=context))
}

##
## The code generator
##

codegen <-
function(node, context)
    UseMethod("codegen")

##############################################################################
## Loops
#' @export
codegen.ado_loop <-
function(node, context)
{
    NextMethod()
}

#' @export
codegen.ado_foreach <-
function(node, context)
{
    what <- setdiff(names(node$children), c("macro_name", "text"))
    val <- codegen(node$children[[what]], context=context)

    ret <- list(as.symbol("ado_foreach"),
                context=context,
                macro_name=codegen(node$children$macro_name, context=context),
                text=codegen(node$children$text, context=context))
    ret[[what]] <- val

    as.call(ret)
}

#' @export
codegen.ado_forvalues <-
function(node, context)
{
    macro_name <- codegen(node$children$macro_name, context=context)
    text <- codegen(node$children$text, context=context)

    upper <- codegen(node$children$upper, context=context)
    lower <- codegen(node$children$lower, context=context)

    ret <- list(as.symbol("ado_forvalues"),
                context=context,
                macro_name=macro_name,
                text=text,
                upper=upper,
                lower=lower)

    if("increment" %in% names(node$children))
    {
        ret[["increment"]] <- codegen(node$children$increment, context=context)
    } else if("increment_t" %in% names(node$children))
    {
        ret[["increment_t"]] <- codegen(node$children$increment_t, context=context)
    }

    as.call(ret)
}

##############################################################################
## Compound and atomic commands
#' @export
codegen.ado_compound_cmd <-
function(node, context)
{
    lst <- list()
    chlds <- lapply(node$children, function(x) codegen(x, context=context))

    for(chld in chlds)
        lst[[length(lst)+1]] <- chld

    do.call(expression, lst)
}

#' @export
codegen.ado_if_cmd <-
function(node, context)
{
    exp <- codegen(node$children$expression, context=context)
    cmp <- codegen(node$children$compound_cmd, context=context)

    ret <- c(as.symbol("ado_cmd_if"), list(expression=exp, compound_cmd=cmp),
             context=context)

    as.call(ret)
}

#' @export
codegen.ado_embedded_code <-
function(node, context)
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
function(node, context)
{
    NextMethod()
}

#' @export
codegen.ado_general_cmd <-
function(node, context)
{
    name <- as.character(codegen(node$children$verb, context=context))
    name <- context$cmd_unabbreviate(paste0("ado_cmd_", name)) # validated in check()
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

    args <- lapply(args, function(x) codegen(x, context=context))
    names(args) <- nm

    #No data elements in a general command

    ret <- c(as.symbol(name), args, context=context)

    as.call(ret)
}

#' @export
codegen.ado_modifier_cmd <-
function(node, context)
{
    name <- as.character(codegen(node$children$verb, context=context))
    name <- context$cmd_unabbreviate(paste0("ado_cmd_", name)) # validated in check()
    verb <- get(name, mode="function")

    lst <- list(as.symbol(name), context=context)

    as.call(lst)
}

#' @export
codegen.ado_modifier_cmd_list <-
function(node, context)
{
    lst <- unlist(lapply(node$children, function(x) codegen(x, context=context)))
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
function(node, context)
{
    codegen(node$children$if_expression, context=context)
}

#' @export
codegen.ado_in_clause <-
function(node, context)
{
    upper <- codegen(node$children$upper, context=context)
    lower <- upper

    if("lower" %in% names(node$children))
    {
        lower <- codegen(node$children$lower, context=context)
    }

    list(upper=upper, lower=lower)
}

#' @export
codegen.ado_using_clause <-
function(node, context)
{
    as.character(codegen(node$children$filename, context=context))
}

#' @export
codegen.ado_weight_clause <-
function(node, context)
{
    list(kind=codegen(node$children$left, context=context),
         weight_expression=codegen(node$children$right, context=context))
}

#' @export
codegen.ado_option <-
function(node, context)
{
    if("args" %in% names(node$children))
        list(name=codegen(node$children$name, context=context),
             args=codegen(node$children$args, context=context))
    else
        list(name=codegen(node$children$name, context=context))
}

#' @export
codegen.ado_option_list <-
function(node, context)
{
    nm <- names(node$children)
    ret <- lapply(node$children, function(x) codegen(x, context=context))
    names(ret) <- nm

    ret
}

##############################################################################
## Lists of expressions
#' @export
codegen.ado_expression_list <-
function(node, context)
{
    lapply(node$children, function(x) codegen(x, context=context))
}

#' @export
codegen.ado_argument_expression_list <-
function(node, context)
{
    flatten(lapply(node$children, function(x) codegen(x, context=context)))
}

##############################################################################
## Expression branch nodes
#' @export
codegen.ado_expression <-
function(node, context)
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

    oplist <- function_for_ado_operator(op)
    args <- lapply(args, function(x) codegen(x, context=context))
    names(args) <- NULL

    if(oplist$context)
    {
        args <- c(context=context, args)
    }

    as.call(c(list(oplist$symbol), args))
}

##############################################################################
## Literal expressions
#' @export
codegen.ado_literal <-
function(node, context)
{
    NextMethod()
}

#' @export
codegen.ado_ident <-
function(node, context)
{
    as.symbol(node$data["value"])
}

#' @export
codegen.ado_number <-
function(node, context)
{
    if(node$data["value"] == ".")
        NA
    else
        as.numeric(node$data["value"])
}

#' @export
codegen.ado_string_literal <-
function(node, context)
{
    val <- as.character(node$data["value"])

    if(val == "")
        NA
    else
        val
}

#' @export
codegen.ado_datetime <-
function(node, context)
{
    as.POSIXct(node$data["value"])
}

#' @export
codegen.ado_format_spec <-
function(node, context)
{
    val <- as.character(node$data["value"])

    structure(val, class=c(class(val), "format_spec"))
}

