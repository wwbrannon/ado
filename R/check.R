### Semantic analysis - the "weeding" phase of the interpreter. After we get back an
### AST, do some semantic checks on it, including things that Stata considers syntax,
### and raise error conditions if the checks fail.

#' @export
check <-
function(node, debug_level=0)
{
    #General checks all AST nodes should pass
    raiseifnot(node %is% "rstata_ast_node",
               msg=if(debug_level) NULL else "Missing or malformed command object")
    raiseifnot(every(c("data", "children") %in% names(node)),
               msg=if(debug_level) NULL else "Malformed command object")
    
    #Recursively check the children
    if(length(node$children) > 0)
    {
        named <- names(node$children)[which(names(node$children) != "")]
        raiseifnot(length(named) == length(unique(named)),
                   msg=if(debug_level) NULL else "Malformed command object")
        
        for(chld in node$children)
            check(chld, debug_level)
    }
    
    #Check this node in a way appropriate to its type
    verifynode(node, debug_level)
}

#' @export
verifynode <-
function(node, debug_level=0)
    UseMethod("verifynode")

##############################################################################
## Literals
#' @export
verifynode.rstata_literal <-
function(node, debug_level=0)
{
    #Children - length, names, types
    raiseifnot(length(node$children) == 0,
               msg=if(debug_level) NULL else "Invalid literal: has children")
    
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Invalid literal: bad data members")
    raiseifnot("value" %in% names(node$data),
               msg=if(debug_level) NULL else "Invalid literal: no value")
    
    NextMethod()
}

#' @export
verifynode.rstata_ident <-
function(node, debug_level=0)
{
    raiseifnot(length(grep("^[_A-Za-z][A-Za-z0-9_]*$", node$data["value"])) > 0,
               msg=if(debug_level) NULL else "Invalid identifier")
    raiseifnot(!is.null(as.symbol(node$data["value"])),
               msg=if(debug_level) NULL else "Invalid identifier")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_number <-
function(node, debug_level=0)
{
    if(node$data["value"] == ".")
    {
        invisible(TRUE)
    } else
    {
        val <- as.numeric(node$data["value"])
        raiseifnot((!is.na(val) && !is.null(val)),
                   msg=if(debug_level) NULL else "Invalid numeric literal")
        
        invisible(TRUE)
    }
}

#' @export
verifynode.rstata_string_literal <-
function(node, debug_level=0)
{
    val <- as.character(node$data["value"])
    raiseifnot(!is.na(val) && !is.null(val),
               msg=if(debug_level) NULL else "Invalid string literal")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_datetime <-
function(node, debug_level=0)
{
    val <- as.POSIXct(strptime(node$data["value"], format="%d%b%Y %H:%M:%S"))
    raiseifnot(!is.na(val) && !is.null(val),
               msg=if(debug_level) NULL else "Invalid date/time literal")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_format_spec <-
function(node, debug_level=0)
{
    raiseifnot(valid_format_spec(node$data["value"]),
               msg=if(debug_level) NULL else "Invalid format specifier")
    
    invisible(TRUE)
}

##############################################################################
## Loops
#' @export
verifynode.rstata_loop <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed loop statement")
    
    #Children - length, names, types
    raiseifnot(length(node$children) > 2,
               msg=if(debug_level) NULL else "Malformed loop statement")
    raiseifnot(every(c("macro_name", "text") %in% names(node$children)),
               msg=if(debug_level) NULL else "Malformed loop statement")
    raiseifnot(node$children$macro_name %is% "rstata_ident",
               msg=if(debug_level) NULL else "Malformed loop statement")
    raiseifnot(node$children$text %is% "rstata_string_literal",
               msg=if(debug_level) NULL else "Malformed loop statement")
    
    NextMethod()
}

#' @export
verifynode.rstata_foreach <-
function(node, debug_level=0)
{
    raiseifnot(length(node$children) == 3,
               msg=if(debug_level) NULL else "Malformed foreach statement")
    raiseifnot("numlist" %in% names(node$children) ||
                   "varlist" %in% names(node$children) ||
                   "local_macro_source" %in% names(node$children) ||
                   "global_macro_source" %in% names(node$children),
               msg=if(debug_level) NULL else "Malformed foreach statement")
    
    if("numlist" %in% names(node$children))
    {
        raiseifnot(node$children$numlist %is% "rstata_expression_list",
                   msg=if(debug_level) NULL else "Invalid numlist given to foreach statement")
        
        raiseifnot(every(vapply(node$children$numlist$children, function(v) v %is% "rstata_number", logical(1))),
                   msg=if(debug_level) NULL else "Invalid numlist given to foreach statement")
    } else if("varlist" %in% names(node$children))
    {
        raiseifnot(node$children$varlist %is% "rstata_expression_list",
                   msg=if(debug_level) NULL else "")
        
        raiseifnot(every(vapply(node$children$varlist, function(v) v %is% "rstata_ident", logical(1))),
                   msg=if(debug_level) NULL else "Invalid varlist given to foreach statement")
    } else if("local_macro_source" %in% names(node$children))
    {
        raiseifnot(node$children$local_macro_source %is% "rstata_ident",
                   msg=if(debug_level) NULL else "Invalid source macro name in foreach statement")
    } else if("global_macro_source" %in% names(node$children))
    {
        raiseifnot(node$children$global_macro_source %is% "rstata_ident",
                   msg=if(debug_level) NULL else "Invalid source macro name in foreach statement")
    }
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_forvalues <-
function(node, debug_level=0)
{
    raiseifnot(length(node$children) %in% c(4,5),
               msg=if(debug_level) NULL else "Malformed forvalues statement")
    raiseifnot(every(c("upper", "lower") %in% names(node$children)),
               msg=if(debug_level) NULL else "Malformed forvalues statement")
    
    raiseifnot(node$children$upper %is% "rstata_number",
               msg=if(debug_level) NULL else "Invalid upper bound for forvalues statement")
    raiseifnot(node$children$lower %is% "rstata_number",
               msg=if(debug_level) NULL else "Invalid lower bound for forvalues statement")
    
    if(length(node$children) == 5)
    {
        raiseifnot("increment" %in% names(node$children) ||
                       "increment_t" %in% names(node$children),
                   msg=if(debug_level) NULL else "Malformed forvalues statement")
        
        if("increment" %in% names(node$children))
            raiseifnot(node$children$increment %is% "rstata_number",
                       msg=if(debug_level) NULL else "Invalid increment for forvalues statement")
        if("increment_t" %in% names(node$children))
            raiseifnot(node$children$increment_t %is% "rstata_number",
                       msg=if(debug_level) NULL else "Invalid increment for forvalues statement")
    }
    
    invisible(TRUE)
}

##############################################################################
## Command parts
#' @export
verifynode.rstata_if_clause <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed if clause")
    
    #Children - length, names, types
    raiseifnot(length(node$children) %in% c(0, 1),
               msg=if(debug_level) NULL else "Malformed if clause")
    
    if(length(node$children) == 1)
    {
        raiseifnot("if_expression" %in% names(node$children),
                   msg=if(debug_level) NULL else "Missing expression for if clause")
        raiseifnot(node$children[[1]] %is% "rstata_expression" ||
                       node$children[[1]] %is% "rstata_literal",
                   msg=if(debug_level) NULL else "Bad expression for if clause")
    }
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_in_clause <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed in clause")
    
    #Children - length, names, types
    raiseifnot(length(node$children) %in% c(0, 1, 2),
               msg=if(debug_level) NULL else "Malformed in clause")
    
    #Check that the "upper" child node is present and valid
    raiseifnot("upper" %in% names(node$children),
               msg=if(debug_level) NULL else "Missing limits for in clause")
    
    raiseifnot(node$children$upper %is% "rstata_number" ||
                   (
                       node$children$upper %is% "rstata_unary_expression" &&
                           node$children$upper$children[[1]] %is% "rstata_number"
                   ) ||
                   (
                       node$children$upper %is% "rstata_ident" &&
                           node$children$upper$data["value"] %in% c("f", "F", "l", "L")
                   ),
               msg=if(debug_level) NULL else "Bad limit value for in clause")
    
    #If we got a "lower" node, do the same checks on it
    if(length(node$children) == 2)
    {
        raiseifnot("lower" %in% names(node$children),
                   msg=if(debug_level) NULL else "Missing limits for in clause")
        
        raiseifnot(node$children$lower %is% "rstata_number" ||
                       (
                           node$children$lower %is% "rstata_unary_expression" &&
                               node$children$lower$children[[1]] %is% "rstata_number"
                       ) ||
                       (
                           node$children$lower %is% "rstata_ident" &&
                               node$children$lower$data["value"] %in% c("f", "F", "l", "L")
                       ),
                   msg=if(debug_level) NULL else "Bad limit value for in clause")
    }
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_using_clause <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed using clause")
    
    #Children - length, names, types
    raiseifnot(length(node$children) %in% c(0, 1),
               msg=if(debug_level) NULL else "Malformed using clause")
    
    if(length(node$children) == 1)
    {
        raiseifnot("filename" %in% names(node$children),
                   msg=if(debug_level) NULL else "Missing filename for using clause")
        
        raiseifnot(node$children[[1]] %is% "rstata_string_literal" ||
                       node$children[[1]] %is% "rstata_ident",
                   msg=if(debug_level) NULL else "Bad filename type for using clause")
    }
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_weight_clause <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed weight clause")
    
    #Children - length, names, types
    raiseifnot(length(node$children) %in% c(0, 2),
               msg=if(debug_level) NULL else "Malformed weight clause")
    
    if(length(node$children) == 2)
    {
        raiseifnot(c("left", "right") %in% names(node$children),
                   msg=if(debug_level) NULL else "Missing type or variable for weight clause")
        
        raiseifnot(node$children$left %is% "rstata_ident",
                   msg=if(debug_level) NULL else "Bad weight type for weight clause")
        raiseifnot(node$children$left$data["value"] %in% c("aweight", "iweight", "pweight", "fweight"),
                   msg=if(debug_level) NULL else "Bad weight type for weight clause")
        
        raiseifnot(node$children$right %is% "rstata_expression" ||
                       node$children$right %is% "rstata_literal",
                   msg=if(debug_level) NULL else "Bad variable for weight clause")
    }
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_option_list <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed option list")
    
    #Children - length, names, types
    #Length at least 0, checked above
    #No name requirements for children
    raiseifnot(every(vapply(node$children, function(x) x %is% "rstata_option", TRUE)),
               msg=if(debug_level) NULL else "Non-option in option list")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_option <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed option")
    
    #Children - length, names, types
    raiseifnot(length(node$children) %in% c(1, 2),
               msg=if(debug_level) NULL else "Malformed option")
    raiseifnot("name" %in% names(node$children),
               msg=if(debug_level) NULL else "Missing name for option")
    
    if(length(node$children) == 2)
    {
        raiseifnot("args" %in% names(node$children),
                   msg=if(debug_level) NULL else "Bad arguments to option")
        raiseifnot(node$children[[2]] %is% "rstata_argument_expression_list",
                   msg=if(debug_level) NULL else "Bad arguments to option")
    }
    
    invisible(TRUE)
}

##############################################################################
## Compound and atomic commands
#' @export
verifynode.rstata_compound_cmd <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed compound/block command")
    
    #Children - length, names, types
    #No name requirements for children
    raiseifnot(length(node$children) > 0,
               msg=if(debug_level) NULL else "Empty compound/block command")
    raiseifnot(every(vapply(node$children,
                            function(x) x %is% "rstata_compound_cmd" ||     #they can be nested
                                x %is% "rstata_embedded_code" ||    #embedded R or sh code
                                x %is% "rstata_cmd" ||              #a usual Stata cmd
                                x %is% "rstata_if_cmd" ||           #an if expr { } block
                                x %is% "rstata_loop" ||             #a foreach or forvalues loop
                                x %is% "rstata_modifier_cmd_list",  #a Stata cmd with modifiers
                            TRUE)), msg=if(debug_level) NULL else "Non-command in compound/block command")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_if_cmd <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed if command")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 2,
               msg=if(debug_level) NULL else "Malformed if command")
    raiseifnot(every(c("expression", "compound_cmd") %in% names(node$children)),
               msg=if(debug_level) NULL else "Malformed if command")
    
    raiseifnot(node$children$expression %is% "rstata_expression" ||
                   node$children$expression %is% "rstata_literal",
               msg=if(debug_level) NULL else "Bad expression for if command")
    raiseifnot(node$children$compound_cmd %is% "rstata_compound_cmd",
               msg=if(debug_level) NULL else "Bad compound/block command for if command")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_modifier_cmd_list <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed prefix command list")
    
    #Children - length, names, types
    raiseifnot(length(node$children) > 0,
               msg=if(debug_level) NULL else "Empty prefix command list")
    raiseifnot(every(vapply(node$children,
                            function(x) x %is% "rstata_modifier_cmd_list" ||
                                x %is% "rstata_modifier_cmd" ||
                                x %is% "rstata_general_cmd" ||
                                x %is% "rstata_special_cmd" ||
                                x %is% "rstata_compound_cmd",
                            TRUE)),
               msg=if(debug_level) NULL else "Non-command or bad command in prefix command list")
    
    named <- names(node$children)[which(names(node$children) != "")]
    raiseifnot(length(named) %in% c(0,1),
               msg=if(debug_level) NULL else "Malformed prefix command list")
    
    if(length(named) == 1)
    {
        raiseifnot(named == c("main_cmd"),
                   msg=if(debug_level) NULL else "Missing main command for prefix command list")
        
        pos <- match("main_cmd", names(node$children))
        raiseifnot(pos == length(names(node$children)),
                   msg=if(debug_level) NULL else "Bad main command placement in prefix command list")
    }
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_embedded_code <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 2,
               msg=if(debug_level) NULL else "Malformed embedded code block")
    
    raiseifnot("value" %in% names(node$data),
               msg=if(debug_level) NULL else "No code in embedded code block")
    raiseifnot(!is.na(as.character(node$data["value"])),
               msg=if(debug_level) NULL else "No code in embedded code block")
    
    raiseifnot("lang" %in% names(node$data),
               msg=if(debug_level) NULL else "No language type in embedded code block")
    raiseifnot(!is.na(as.character(node$data["lang"])),
               msg=if(debug_level) NULL else "No language type in embedded code block")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 0,
               msg=if(debug_level) NULL else "Malformed embedded code block")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_cmd <-
function(node, debug_level=0)
{
    #Children - length, names, types
    raiseifnot(length(node$children) > 0,
               msg=if(debug_level) NULL else "Empty command given")
    raiseifnot("verb" %in% names(node$children),
               msg=if(debug_level) NULL else "Malformed command object: no command name")
    raiseifnot(node$children$verb %is% "rstata_ident",
               msg=if(debug_level) NULL else "Malformed command object: bad command name")
    
    raiseifnot(every(valid_cmd_part(names(node$children))),
               msg=if(debug_level) NULL else "Malformed command object")
    
    #Data members - length, names, values
    #No restrictions on number, names or values of data members
    
    NextMethod()
}

#' @export
verifynode.rstata_modifier_cmd <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed prefix command object")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 1,
               msg=if(debug_level) NULL else "Malformed prefix command object")
    raiseifnot(names(node$children) == c("verb"),
               msg=if(debug_level) NULL else "Malformed prefix command object")
    raiseifnot(node$children$verb %is% "rstata_ident",
               msg=if(debug_level) NULL else "Malformed prefix command object")
    
    func <- paste0("rstata_cmd_", node$children$verb$data["value"])
    func <- unabbreviateCommand(func, cls="BadCommandException",
                                msg=if(debug_level) NULL else "Cannot unabbreviate prefix command")
    
    raiseifnot(exists(func), msg=if(debug_level) NULL else "Prefix command not found")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_general_cmd <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed command object")
    
    #Children - length, names, types
    func <- paste0("rstata_cmd_", node$children$verb$data["value"])
    func <- unabbreviateCommand(func, cls="BadCommandException",
                                msg=if(debug_level) NULL else "Cannot unabbreviate command")
    raiseifnot(exists(func), msg=if(debug_level) NULL else "Command not found")
    
    args <-
        tryCatch(
            {
                formals(get(func))
            },
            error=function(c) c)
    
    if(inherits(args, "error"))
    {
        raiseCondition("Command not found", cls="BadCommandException")
        return(invisible(TRUE))
    }
    
    chlds <- node$children
    if("expression_list" %in% names(chlds))
    {
        if("expression_list" %in% names(args))
            TRUE #do nothing
        if("varlist" %in% names(args))
            names(chlds)[names(chlds) == "expression_list"] <- "varlist"
        if("expression" %in% names(args))
            names(chlds)[names(chlds) == "expression_list"] <- "expression"
    }
    given <- setdiff(names(chlds), c("verb"))
    
    raiseifnot(every(given %in% names(args)),
               msg=if(debug_level) NULL else "Incorrect clause or option for command")
    raiseifnot(every(vapply(names(args),
                            function(x) is.null(args[[x]]) || x %in% given,
                            TRUE)),
               msg=if(debug_level) NULL else "Required clause or option missing for command")
    
    raiseifnot(every(correct_arg_types_for_cmd(chlds)),
               msg=if(debug_level) NULL else "Incorrect argument given to command")
    
    invisible(TRUE)
}

##############################################################################
## Lists of expressions
#' @export
verifynode.rstata_expression_list <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed expression or variable list")
    
    #Children - length, names, types
    raiseifnot(length(node$children) > 0,
               msg=if(debug_level) NULL else "Empty expression or variable list")
    
    raiseifnot(every(vapply(node$children, function(x) x %is% "rstata_expression" ||
                                x %is% "rstata_literal", TRUE)),
               msg=if(debug_level) NULL else "Non-expression in expression or variable list")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_argument_expression_list <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 0,
               msg=if(debug_level) NULL else "Malformed function or option argument list")
    
    #Children - length, names, types
    raiseifnot(length(node$children) > 0,
               msg=if(debug_level) NULL else "Empty function or option argument list")
    
    raiseifnot(every(vapply(node$children, function(x) x %is% "rstata_expression_list", TRUE)),
               msg=if(debug_level) NULL else "Invalid argument to function or option")
    
    for(n in node$children)
    {
        raiseifnot(every(vapply(n$children,
                                function(x) !(x %is% "rstata_assignment_expression") &&
                                    !(x %is% "rstata_factor_expression") &&
                                    !(x %is% "rstata_cross_expression"),
                                TRUE)),
                   msg=if(debug_level) NULL else "Incorrect type of expression in argument expression list")
    }
    
    invisible(TRUE)
}

##############################################################################
## Expression branch nodes - literals are above
#' @export
verifynode.rstata_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) > 0,
               msg=if(debug_level) NULL else "Malformed expression object")
    raiseifnot("verb" %in% names(node$data),
               msg=if(debug_level) NULL else "Malformed expression object")
    
    NextMethod()
}

#' @export
verifynode.rstata_type_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed type specifier expression")
    raiseifnot(names(node$data) == c("verb"),
               msg=if(debug_level) NULL else "Malformed type specifier expression")
    raiseifnot(valid_data_type(node$data["verb"]),
               msg=if(debug_level) NULL else "Incorrect data type")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 1,
               msg=if(debug_level) NULL else "Malformed type specifier expression")
    raiseifnot(names(node$children) == c("left"),
               msg=if(debug_level) NULL else "Malformed type specifier expression")
    raiseifnot(node$children$left %is% "rstata_expression_list",
               msg=if(debug_level) NULL else "Malformed type specifier expression")
    raiseifnot(every(vapply(node$children$left$children, function(x) x %is% "rstata_ident", TRUE)),
               msg=if(debug_level) NULL else "Non-variable given as argument to type specifier expression")
    
    invisible(TRUE)
}

## Tightly binding factor operators
#' @export
verifynode.rstata_factor_expression <-
function(node, debug_level=0)
{
    #Children - length, names, types
    raiseifnot(length(node$children) == 1,
               msg=if(debug_level) NULL else "Malformed factor operator expression")
    raiseifnot("left" %in% names(node$children),
               msg=if(debug_level) NULL else "Malformed factor operator expression")
    
    raiseifnot(node$children$left %is% "rstata_ident",
               msg=if(debug_level) NULL else "Non-variable given as argument to factor operator")
    
    NextMethod()
}

#' @export
verifynode.rstata_continuous_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed 'c.' operator expression")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_indicator_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(node$data["verb"] == "i.",
               msg=if(debug_level) NULL else "Malformed 'i.' operator expression")
    
    nm <- setdiff(names(node$data), c("verb"))
    
    if(length(nm == 0))
        return(invisible(TRUE))
    else if(length(nm) == 1 && nm == c("level"))
        raiseifnot(!is.na(as.numeric(node$data["level"])),
                   msg=if(debug_level) NULL else "Bad level given to 'i.' operator")
    else if(length(nm) == 2 && ("levelstart" %in% nm && "levelend" %in% nm))
        raiseifnot(!is.na(as.numeric(node$data["levelstart"])) &&
                       !is.na(as.numeric(node$data["levelend"])),
                   msg=if(debug_level) NULL else "Bad level given to 'i.' operator")
    else if(length(grep("level[0-9]+", nm)) == length(nm))
        raiseifnot(every(vapply(nm, function(x) !is.na(as.numeric(x)), TRUE)),
                   msg=if(debug_level) NULL else "Bad level given to 'i.' operator")
    else
        raiseifnot(1==0, msg=if(debug_level) NULL else "Bad level given to 'i.' operator")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_omit_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) > 1,
               msg=if(debug_level) NULL else "Malformed 'o.' operator expression")
    raiseifnot(node$data["verb"] == "o.",
               msg=if(debug_level) NULL else "Malformed 'o.' operator expression")
    
    nm <- setdiff(names(node$data), c("verb"))
    
    if(length(nm) == 1 && nm == c("level"))
        raiseifnot(!is.na(as.numeric(node$data["level"])),
                   msg=if(debug_level) NULL else "Bad level given to 'o.' operator")
    else if(length(nm) == 2 && ("levelstart" %in% nm && "levelend" %in% nm))
        raiseifnot(!is.na(as.numeric(node$data["levelstart"])) &&
                       !is.na(as.numeric(node$data["levelend"])),
                   msg=if(debug_level) NULL else "Bad level given to 'o.' operator")
    else if(length(grep("level[0-9]+", nm)) == length(nm))
        raiseifnot(every(vapply(nm, function(x) !is.na(as.numeric(x)), TRUE)),
                   msg=if(debug_level) NULL else "Bad level given to 'o.' operator")
    else
        raiseifnot(1==0, msg=if(debug_level) NULL else "Bad level given to 'o.' operator")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_baseline_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 2,
               msg=if(debug_level) NULL else "Malformed 'ib.' operator expression")
    raiseifnot(node$data["verb"] == "ib.",
               msg=if(debug_level) NULL else "Malformed 'ib.' operator expression")
    
    raiseifnot("level" %in% names(node$data),
               msg=if(debug_level) NULL else "Malformed 'ib.' operator expression")
    
    raiseifnot(node$data["level"] %in% c("n", "freq", "last", "first") ||
                   !is.na(as.numeric(node$data["level"])),
               msg=if(debug_level) NULL else "Bad level given to 'ib.' operator")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_cross_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed cross or factorial cross expression")
    raiseifnot(node$data["verb"] %in% c("##", "#"),
               msg=if(debug_level) NULL else "Malformed cross or factorial cross expression")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 2,
               msg=if(debug_level) NULL else "Malformed cross or factorial cross expression")
    raiseifnot(every(c("left", "right") %in% names(node$children)),
               msg=if(debug_level) NULL else "Malformed cross or factorial cross expression")
    
    raiseifnot(node$children$left %is% "rstata_ident" ||
                   node$children$left %is% "rstata_factor_expression",
               msg=if(debug_level) NULL else "Non-variable in cross or factorial cross expression")
    
    raiseifnot(node$children$right %is% "rstata_ident" ||
                   node$children$right %is% "rstata_factor_expression",
               msg=if(debug_level) NULL else "Non-variable in cross or factorial cross expression")
    
    invisible(TRUE)
}

## Arithmetic expressions
#' @export
verifynode.rstata_power_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed exponentiation expression")
    raiseifnot(node$data["verb"] == "^",
               msg=if(debug_level) NULL else "Malformed exponentiation expression")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 2,
               msg=if(debug_level) NULL else "Malformed exponentiation expression")
    raiseifnot(every(c("left", "right") %in% names(node$children)),
               msg=if(debug_level) NULL else "Malformed exponentiation expression")
    
    raiseifnot(node$children$left %is% "rstata_ident" ||
                   node$children$left %is% "rstata_number" ||
                   node$children$left %is% "rstata_arithmetic_expression",
               msg=if(debug_level) NULL else "Incorrect argument to exponentiation operator")
    
    raiseifnot(node$children$right %is% "rstata_ident" ||
                   node$children$right %is% "rstata_number" ||
                   node$children$right %is% "rstata_arithmetic_expression",
               msg=if(debug_level) NULL else "Incorrect argument to exponentiation operator")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_unary_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed unary operator expression")
    raiseifnot(node$data["verb"] %in% c("-", "+", "!"),
               msg=if(debug_level) NULL else "Malformed unary operator expression")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 1,
               msg=if(debug_level) NULL else "Malformed unary operator expression")
    raiseifnot("right" %in% names(node$children),
               msg=if(debug_level) NULL else "Malformed unary operator expression")
    
    raiseifnot(node$children$right %is% "rstata_ident" ||
                   node$children$right %is% "rstata_number" ||
                   node$children$right %is% "rstata_arithmetic_expression",
               msg=if(debug_level) NULL else "Incorrect argument to unary operator")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_multiplication_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed multiplication/division expression")
    raiseifnot(node$data["verb"] %in% c("*", "/"),
               msg=if(debug_level) NULL else "Malformed multiplication/division expression")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 2,
               msg=if(debug_level) NULL else "Malformed multiplication/division expression")
    raiseifnot(every(c("left", "right") %in% names(node$children)),
               msg=if(debug_level) NULL else "Malformed multiplication/division expression")
    
    raiseifnot(node$children$left %is% "rstata_ident" ||
                   node$children$left %is% "rstata_number" ||
                   node$children$left %is% "rstata_arithmetic_expression",
               msg=if(debug_level) NULL else "Incorrect argument to multiplication/division operator")
    
    raiseifnot(node$children$right %is% "rstata_ident" ||
                   node$children$right %is% "rstata_number" ||
                   node$children$right %is% "rstata_arithmetic_expression",
               msg=if(debug_level) NULL else "Incorrect argument to multiplication/division operator")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_additive_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed addition/subtraction expression")
    raiseifnot(node$data["verb"] %in% c("+", "-"),
               msg=if(debug_level) NULL else "Malformed addition/subtraction expression")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 2,
               msg=if(debug_level) NULL else "Malformed addition/subtraction expression")
    raiseifnot(every(c("left", "right") %in% names(node$children)),
               msg=if(debug_level) NULL else "Malformed addition/subtraction expression")
    
    raiseifnot(node$children$left %is% "rstata_ident" ||
                   node$children$left %is% "rstata_number" ||
                   node$children$left %is% "rstata_arithmetic_expression",
               msg=if(debug_level) NULL else "Incorrect argument to addition/subtraction operator")
    
    raiseifnot(node$children$right %is% "rstata_ident" ||
                   node$children$right %is% "rstata_number" ||
                   node$children$right %is% "rstata_arithmetic_expression",
               msg=if(debug_level) NULL else "Incorrect argument to addition/subtraction operator")
    
    invisible(TRUE)
}

## Logical, relational and other expressions
#' @export
verifynode.rstata_equality_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed equality expression")
    raiseifnot(node$data["verb"] %in% c("=="),
               msg=if(debug_level) NULL else "Malformed equality expression")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 2,
               msg=if(debug_level) NULL else "Malformed equality expression")
    raiseifnot(every(c("left", "right") %in% names(node$children)),
               msg=if(debug_level) NULL else "Malformed equality expression")
    
    raiseifnot(
        !(
            node$children$left %is% "rstata_factor_expression" ||
                node$children$left %is% "rstata_type_expression" ||
                node$children$left %is% "rstata_cross_expression"
        )
        
        &&
            
            (
                node$children$left %is% "rstata_expression" ||
                    node$children$left %is% "rstata_literal"
            ),
        msg=if(debug_level) NULL else "Incorrect argument to equality expression")
    
    raiseifnot(
        !(
            node$children$right %is% "rstata_factor_expression" ||
                node$children$right %is% "rstata_type_expression" ||
                node$children$right %is% "rstata_cross_expression"
        )
        
        &&
            
            (
                node$children$right %is% "rstata_expression" ||
                    node$children$right %is% "rstata_literal"
            ),
        msg=if(debug_level) NULL else "Incorrect argument to equality expression")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_logical_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed logical expression")
    raiseifnot(node$data["verb"] %in% c("&", "|"),
               msg=if(debug_level) NULL else "Malformed logical expression")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 2,
               msg=if(debug_level) NULL else "Malformed logical expression")
    raiseifnot(every(c("left", "right") %in% names(node$children)),
               msg=if(debug_level) NULL else "Malformed logical expression")
    
    raiseifnot(
        !(
            node$children$left %is% "rstata_factor_expression" ||
                node$children$left %is% "rstata_type_expression" ||
                node$children$left %is% "rstata_cross_expression"
        )
        
        &&
            
            (
                node$children$left %is% "rstata_expression" ||
                    node$children$left %is% "rstata_literal"
            ),
        msg=if(debug_level) NULL else "Incorrect argument to logical expression")
    
    raiseifnot(
        !(
            node$children$right %is% "rstata_factor_expression" ||
                node$children$right %is% "rstata_type_expression" ||
                node$children$right %is% "rstata_cross_expression"
        )
        
        &&
            
            (
                node$children$right %is% "rstata_expression" ||
                    node$children$right %is% "rstata_literal"
            ),
        msg=if(debug_level) NULL else "Incorrect argument to logical expression")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_relational_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed relational expression")
    raiseifnot(node$data["verb"] %in% c(">", "<", ">=", "<="),
               msg=if(debug_level) NULL else "Malformed relational expression")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 2,
               msg=if(debug_level) NULL else "Malformed relational expression")
    raiseifnot(every(c("left", "right") %in% names(node$children)),
               msg=if(debug_level) NULL else "Malformed relational expression")
    
    raiseifnot(
        !(
            node$children$left %is% "rstata_factor_expression" ||
                node$children$left %is% "rstata_type_expression" ||
                node$children$left %is% "rstata_cross_expression"
        )
        
        &&
            
            (
                node$children$left %is% "rstata_expression" ||
                    node$children$left %is% "rstata_literal"
            ),
        msg=if(debug_level) NULL else "Incorrect argument to relational expression")
    
    raiseifnot(
        !(
            node$children$right %is% "rstata_factor_expression" ||
                node$children$right %is% "rstata_type_expression" ||
                node$children$right %is% "rstata_cross_expression"
        )
        
        &&
            
            (
                node$children$right %is% "rstata_expression" ||
                    node$children$right %is% "rstata_literal"
            ),
        msg=if(debug_level) NULL else "Incorrect argument to relational expression")
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_postfix_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed function call or subscript expression")
    raiseifnot(node$data["verb"] %in% c("()", "[]"),
               msg=if(debug_level) NULL else "Malformed function call or subscript expression")
    
    #Children - length, names, types
    raiseifnot(length(node$children) %in% c(1, 2),
               msg=if(debug_level) NULL else "Malformed function call or subscript expression")
    
    raiseifnot("left" %in% names(node$children),
               msg=if(debug_level) NULL else "Malformed function call or subscript expression")
    raiseifnot(node$children$left %is% "rstata_ident",
               msg=if(debug_level) NULL else "Attempt to call non-function or subscript non-variable")
    
    if(length(node$children) == 2)
    {
        raiseifnot("right" %in% names(node$children),
                   msg=if(debug_level) NULL else "Malformed function call or subscript expression")
        raiseifnot(
            (
                node$children$right %is% "rstata_expression" ||
                    node$children$right %is% "rstata_literal" ||
                    node$children$right %is% "rstata_argument_expression_list"
            )
            && !(node$children$right %is% "rstata_factor_expression")
            && !(node$children$right %is% "rstata_cross_expression")
            && !(node$children$right %is% "rstata_type_expression"),
            msg=if(debug_level) NULL else "Incorrect function argument or subscript expression")
    }
    
    invisible(TRUE)
}

#' @export
verifynode.rstata_assignment_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed assignment expression")
    raiseifnot(node$data["verb"] %in% c("="),
               msg=if(debug_level) NULL else "Malformed assignment expression")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 2,
               msg=if(debug_level) NULL else "Malformed assignment expression")
    raiseifnot(every(c("left", "right") %in% names(node$children)),
               msg=if(debug_level) NULL else "Malformed assignment expression")
    
    raiseifnot(node$children$left %is% "rstata_ident" ||
                   node$children$left %is% "rstata_type_expression",
               msg=if(debug_level) NULL else "Invalid left-hand side in assignment")
    
    raiseifnot(
        !(
            node$children$right %is% "rstata_factor_expression" ||
                node$children$right %is% "rstata_type_expression" ||
                node$children$right %is% "rstata_cross_expression"
        )
        
        &&
            
            (
                node$children$right %is% "rstata_expression" ||
                    node$children$right %is% "rstata_literal"
            ),
        msg=if(debug_level) NULL else "Invalid right-hand side in assignment")
    
    invisible(TRUE)
}

##A pair of operators that are only allowed in arguments to the anova command.
##We're not going to verify that this is an anova command, but the only way
##the parser will generate these classes is if it's seen an ANOVA token.
#' @export
verifynode.rstata_anova_nest_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed anova expression")
    raiseifnot(node$data["verb"] == "%anova_nest%",
               msg=if(debug_level) NULL else "Malformed anova expression")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 2,
               msg=if(debug_level) NULL else "Malformed anova expression")
    raiseifnot(every(c("left", "right") %in% names(node$children)),
               msg=if(debug_level) NULL else "Malformed anova expression")
    
    raiseifnot(node$children$left %is% "rstata_ident" ||
                   node$children$left %is% "rstata_factor_expression" ||
                   node$children$left %is% "rstata_cross_expression" ||
                   node$children$left %is% "rstata_anova_nest_expression",
               msg=if(debug_level) NULL else "Incorrect varlist specification in anova command")
}

#' @export
verifynode.rstata_anova_error_expression <-
function(node, debug_level=0)
{
    #Data members - length, names, values
    raiseifnot(length(node$data) == 1,
               msg=if(debug_level) NULL else "Malformed anova expression")
    raiseifnot(node$data["verb"] == "%anova_error%",
               msg=if(debug_level) NULL else "Malformed anova expression")
    
    #Children - length, names, types
    raiseifnot(length(node$children) == 1,
               msg=if(debug_level) NULL else "Malformed anova expression")
    raiseifnot(every(names(node$children) %in% c("left", "right")),
               msg=if(debug_level) NULL else "Malformed anova expression")
    
    raiseifnot(node$children$left %is% "rstata_ident" ||
                   node$children$left %is% "rstata_factor_expression" ||
                   node$children$left %is% "rstata_cross_expression" ||
                   node$children$left %is% "rstata_anova_nest_expression",
               msg=if(debug_level) NULL else "Incorrect varlist specification in anova command")
}

