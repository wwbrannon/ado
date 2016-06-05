### Code generation. At this point, we've "weeded" the AST and know it satisfies
### our assumptions. Now it's time to generate a list containing
### one unevaluated call for each Stata command. Next, we'll evaluate these objects
### for a) their side effects, b) values which are objects with print() methods.

#' @export
codegen <-
function(node, debug_level=0)
    UseMethod("codegen")

##############################################################################
## Loops
#' @export
codegen.rstata_loop <-
function(node, debug_level=0)
{
    NextMethod()
}

#' @export
codegen.rstata_foreach <-
function(node, debug_level=0)
{
    what <- setdiff(names(node$children), c("macro_name", "text"))
    val <- codegen(node$children[[what]], debug_level)
    
    ret <- list(as.symbol("rstata_foreach"),
                macro_name=codegen(node$children$macro_name, debug_level),
                text=codegen(node$children$text, debug_level))
    ret[[what]] <- val
    
    as.call(ret)
}

#' @export
codegen.rstata_forvalues <-
function(node, debug_level=0)
{
    macro_name <- codegen(node$children$macro_name, debug_level)
    text <- codegen(node$children$text, debug_level)
    
    upper <- codegen(node$children$upper, debug_level)
    lower <- codegen(node$children$lower, debug_level)
    
    ret <- list(as.symbol("rstata_forvalues"),
                macro_name=macro_name,
                text=text,
                upper=upper,
                lower=lower)
    
    if("increment" %in% names(node$children))
    {
        ret[["increment"]] <- codegen(node$children$increment, debug_level)
    } else if("increment_t" %in% names(node$children))
    {
        ret[["increment_t"]] <- codegen(node$children$increment_t, debug_level)
    }
    
    as.call(ret)
}

##############################################################################
## Compound and atomic commands
#' @export
codegen.rstata_compound_cmd <-
function(node, debug_level=0)
{
    lst <- list()
    chlds <- lapply(node$children, function(x) codegen(x, debug_level))
    
    for(chld in chlds)
        lst[[length(lst)+1]] <- chld
    
    do.call(expression, lst)
}

#' @export
codegen.rstata_if_cmd <-
function(node, debug_level=0)
{
    exp <- codegen(node$children$expression, debug_level)
    cmp <- codegen(node$children$compound_cmd, debug_level)
    
    if(debug_level)
        ret <- c(as.symbol("rstata_cmd_if"), list(expression=exp, compound_cmd=cmp),
                 return.match.call=TRUE)
    else
        ret <- c(as.symbol("rstata_cmd_if"), list(expression=exp, compound_cmd=cmp))
    
    as.call(ret)
}

#' @export
codegen.rstata_embedded_code <-
function(node, debug_level=0)
{
    if(node$data["lang"] == "R")
        return(parse(text=node$data["value"]))
    
    if(node$data["lang"] == "shell")
        return(as.call(list(as.symbol("system"), command=node$data["value"])))
}

#' @export
codegen.rstata_cmd <-
function(node, debug_level=0)
{
    NextMethod()
}

#' @export
codegen.rstata_general_cmd <-
function(node, debug_level=0)
{
    name <- as.character(codegen(node$children$verb, debug_level))
    name <- unabbreviateCommand(paste0("rstata_cmd_", name))
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
    
    args <- lapply(args, function(x) codegen(x, debug_level))
    names(args) <- nm
    
    #No data elements in a general command
    
    if(debug_level)
        ret <- c(as.symbol(name), args, return.match.call=TRUE)
    else
        ret <- c(as.symbol(name), args)
    
    as.call(ret)
}

#' @export
codegen.rstata_modifier_cmd <-
function(node, debug_level=0)
{
    name <- as.character(codegen(node$children$verb, debug_level))
    name <- unabbreviateCommand(paste0("rstata_cmd_", name))
    verb <- get(name, mode="function")
    
    if(debug_level)
        lst <- list(as.symbol(name), return.match.call=TRUE)
    else
        lst <- list(as.symbol(name))
    
    as.call(lst)
}

#' @export
codegen.rstata_modifier_cmd_list <-
function(node, debug_level=0)
{
    lst <- unlist(lapply(node$children, function(x) codegen(x, debug_level)))
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
codegen.rstata_if_clause <-
function(node, debug_level=0)
{
    codegen(node$children$if_expression, debug_level)
}

#' @export
codegen.rstata_in_clause <-
function(node, debug_level=0)
{
    upper <- codegen(node$children$upper, debug_level)
    lower <- upper
    
    if("lower" %in% names(node$children))
    {
        lower <- codegen(node$children$lower, debug_level)
    }
    
    list(upper=upper, lower=lower)
}

#' @export
codegen.rstata_using_clause <-
function(node, debug_level=0)
{
    as.character(codegen(node$children$filename, debug_level))
}

#' @export
codegen.rstata_weight_clause <-
function(node, debug_level=0)
{
    list(kind=codegen(node$children$left, debug_level),
         weight_expression=codegen(node$children$right, debug_level))
}

#' @export
codegen.rstata_option <-
function(node, debug_level=0)
{
    if("args" %in% names(node$children))
        list(name=codegen(node$children$name, debug_level),
             args=codegen(node$children$args, debug_level))
    else
        list(name=codegen(node$children$name, debug_level))
}

#' @export
codegen.rstata_option_list <-
function(node, debug_level=0)
{
    nm <- names(node$children)
    ret <- lapply(node$children, function(x) codegen(x, debug_level))
    names(ret) <- nm
    
    ret
}

##############################################################################
## Lists of expressions
#' @export
codegen.rstata_expression_list <-
function(node, debug_level=0)
{
    lapply(node$children, function(x) codegen(x, debug_level))
}

#' @export
codegen.rstata_argument_expression_list <-
function(node, debug_level=0)
{
    flatten(lapply(node$children, function(x) codegen(x, debug_level)))
}

##############################################################################
## Expression branch nodes
#' @export
codegen.rstata_expression <-
function(node, debug_level=0)
{
    #Get the function to call and its arguments in lists
    op <- node$data["verb"]
    args <- node$children[names(node$children) != "verb"]
    
    #If we want to be able to pass this function to do.call, it can't
    #have a name like "c" that masks something important from base R.
    #This is kind of a hack, but it works...
    if(op == "()")
    {
        args$left$data["value"] <- paste0("rstata_func_", args$left$data["value"])
    }
    
    op <- function_for_ado_operator(op)
    args <- lapply(args, function(x) codegen(x, debug_level))
    names(args) <- NULL
    
    as.call(c(list(op), args))
}

##############################################################################
## Literal expressions
#' @export
codegen.rstata_literal <-
function(node, debug_level=0)
{
    NextMethod()
}

#' @export
codegen.rstata_ident <-
function(node, debug_level=0)
{
    as.symbol(node$data["value"])
}

#' @export
codegen.rstata_number <-
function(node, debug_level=0)
{
    if(node$data["value"] == ".")
        NA
    else
        as.numeric(node$data["value"])
}

#' @export
codegen.rstata_string_literal <-
function(node, debug_level=0)
{
    val <- as.character(node$data["value"])
    
    if(val == "")
        NA
    else
        val
}

#' @export
codegen.rstata_datetime <-
function(node, debug_level=0)
{
    as.POSIXct(node$data["value"])
}

#' @export
codegen.rstata_format_spec <-
function(node, debug_level=0)
{
    val <- as.character(node$data["value"])
    
    structure(val, class=c(class(val), "format_spec"))
}

