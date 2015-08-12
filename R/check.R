### Semantic analysis - the "weeding" phase of the interpreter. After we get back an
### AST, do some semantic checks on it, including things that Stata considers syntax,
### and raise error conditions if the checks fail.

check <-
function(node)
{
  #General checks all AST nodes should pass
  raiseifnot(node %is% "rstata_ast_node")
  raiseifnot(every(c("type", "data", "children") %in% names(node)))
  
  #Recursively check the children
  if(length(node$children) > 0)
  {
    raiseifnot(length(names(node$children)) == length(unique(names(node$children))))
    
    for(chld in node$children)
      check(chld)
  }
  
  #Check this node in a way appropriate to its type
  verifynode(node)
}

verifynode <-
function(node)
UseMethod("verifynode")

##############################################################################
## Literals
verifynode.rstata_literal <-
function(node)
{
  #Children - length, names, types
  raiseifnot(length(node$children) == 0)
  
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot("value" %in% names(node$data))
  
  NextMethod()
}

verifynode.rstata_ident <-
function(node)
{
  raiseifnot(length(grep("^[A-Za-z_]+$", node$data$value)) > 0)
  raiseifnot(!is.na(as.symbol(node$data$value)) ||
               !is.null(as.symbol(node$data$value)))
  
  invisible(TRUE)
}

verifynode.rstata_number <-
function(node)
{
  val <- as.numeric(node$data$value)
  valid_missings <- c(".", paste0(".", LETTERS, sep=""))
  raiseifnot((!is.na(val) && !is.null(val)) ||
             node$data$value %in% valid_missings)
  
  invisible(TRUE)
}

verifynode.rstata_string_literal <-
function(node)
{
  val <- as.character(node$data$value)
  raiseifnot(!is.na(val) && !is.null(val))

  invisible(TRUE)
}

verifynode.rstata_datetime <-
function(node)
{
  val <- as.POSIXct(strptime(node$data$value, format="%d%b%Y %H:%M:%S"))
  raiseifnot(!is.na(val) && !is.null(val))

  invisible(TRUE)
}

##############################################################################
## Command parts
verifynode.rstata_if_clause <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)
  
  #Children - length, names, types
  raiseifnot(length(node$children) %in% c(0, 1))
  
  if(length(node$children) == 1)
  {
    raiseifnot("if_expression" %in% names(node$children))
    raiseifnot(node$children[[1]] %is% "rstata_expression")
  }
  
  invisible(TRUE)
}

verifynode.rstata_in_clause <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)
  
  #Children - length, names, types
  raiseifnot(length(node$children) %in% c(0, 2))
  
  if(length(node$children) == 2)
  {
    raiseifnot(every(c("upper", "lower") %in% names(node$children)))
  
    raiseifnot(node$children[[1]] %is% "rstata_numeric")
    raiseifnot(node$children[[2]] %is% "rstata_numeric")
  }
  
  invisible(TRUE)
}

verifynode.rstata_using_clause <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  raiseifnot(length(node$children) %in% c(0, 1))
  
  if(length(node$children) == 1)
  {
    raiseifnot("filename" %in% names(node$children))
    
    raiseifnot(node$children[[1]] %is% "rstata_string_literal" ||
               node$children[[1]] %is% "rstata_ident")
  }
  
  invisible(TRUE)
}

verifynode.rstata_weight_clause <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)
  
  #Children - length, names, types
  raiseifnot(length(node$children) %in% c(0, 2))
  
  if(length(node$children) == 2)
  {
    raiseifnot(c("left", "right") %in% names(node$children))
    
    raiseifnot(node$children$left %is% "rstata_ident")
    raiseifnot(node$children$right %is% "rstata_expression")
  }

  invisible(TRUE)  
}

verifynode.rstata_option_list <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)
  
  #Children - length, names, types
  #Length at least 0, checked above
  #No name requirements for children
  good <- vapply(node$children, function(x) x %is% "rstata_option", TRUE)
  raiseifnot(length(which(!good)) != 0)
  
  invisible(TRUE)
}

verifynode.rstata_option <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  raiseifnot(length(node$children) %in% c(1, 2))
  raiseifnot("name" %in% names(node$children))
  
  if(length(node$children) == 2)
  {
    raiseifnot("args" %in% names(node$children))
    raiseifnot(node$children[[2]] %is% "rstata_expression_list")
  }

  invisible(TRUE)
}

##############################################################################
## Compound and atomic commands
verifynode.rstata_compound_cmd <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  #No name requirements for children
  raiseifnot(length(node$children) > 0)
  good <- vapply(node$children, function(x) x %is% "rstata_cmd", TRUE)
  raiseifnot(length(which(!good)) != 0)
  
  invisible(TRUE)
}

verifynode.rstata_modifier_cmd_list <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)
  
  #Children - length, names, types
  raiseifnot(length(node$children) > 0)

  good <- vapply(node$children, function(x) x %is% "rstata_modifier_cmd", TRUE)
  raiseifnot(length(which(!good)) != 0)
}

verifynode.rstata_embedded_r <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot("value" %in% names(node$data))
  raiseifnot(!is.na(as.character(node$data$value)))
  
  #Children - length, names, types
  raiseifnot(length(node$children) == 0)
  
  invisible(TRUE)
}

verifynode.rstata_cmd <-
function(node)
{
  #Children - length, names, types
  raiseifnot(length(node$children) > 0)
  raiseifnot("verb" %in% names(node$children))
  raiseifnot(node$children$verb %is% "rstata_ident")
  
  raiseifnot(every(valid_cmd_part(names(node$children))))
  
  #Data members - length, names, values
  #No restrictions on number, names or values of data members

  NextMethod()
}

verifynode.rstata_modifier_cmd <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)
  
  #Children - length, names, types
  raiseifnot(length(node$children) == 2)
  raiseifnot(names(node$children) %in% c("verb", "main_cmd", "next_modifier"))
  raiseifnot("verb" %in% names(node$children))
  
  raiseifnot(tolower(node$children$verb$value) %in% c("quietly", "noisily", "capture"))
  
  invisible(TRUE)
}

verifynode.rstata_general_cmd <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  func <- paste0("rstata_", tolower(node$children$verb$value))
  raiseifnot(exists(func))
  
  args <- names(formals(get(func)))
  given <- setdiff(names(node$children), c("verb"))
  raiseifnot(every(given %in% args) && every(args %in% given))

  raiseifnot(every(correct_arg_types_for_cmd(node$children)))

  invisible(TRUE)
}

verifynode.rstata_special_cmd <-
function(node)
{
  verb <- tolower(node$children$verb$value)
  func <- paste0("rstata_", verb)
  
  raiseifnot(verb %in% c("merge", "generate", "recast", "display", "format"))
  raiseifnot(exists(func))
  
  args <- names(formals(get(func)))
  given <- setdiff(names(node$children), c("verb"))
  
  raiseifnot(every(given %in% args) && every(args %in% given))
  
  raiseifnot(every(correct_arg_types_for_cmd(node$children)))
  
  #checks of node-specific data
  if(verb == "merge")
  {
    raiseifnot(length(node$data) == 1)
    raiseifnot(names(node$data) == c("merge_spec"))
    raiseifnot(node$data$merge_spec %in% c("m:m", "m:1", "1:m", "1:1"))
  } else if(verb == "generate")
  {
    raiseifnot(length(node$data) %in% c(0, 1))
    
    if(length(node$data == 1))
    {
      raiseifnot(names(node$data) == c("type_spec"))
      raiseifnot(valid_data_type(node$data$type_spec))
    }
  } else if(verb == "recast")
  {
    raiseifnot(length(node$data) == 1)
    raiseifnot(names(node$data) == c("type_spec"))
    raiseifnot(valid_data_type(node$data$type_spec))
  } else if(verb == "display")
  {
    #none needed
  } else if(verb == "format")
  {
    raiseifnot(length(node$data) == 1)
    raiseifnot(names(node$data) == c("format_spec"))
    raiseifnot(valid_format_spec(node$data$format_spec))
  }

  invisible(TRUE)
}

##############################################################################
## Lists of expressions

verifynode.rstata_expression_list <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)
  
  #Children - length, names, types
  raiseifnot(length(node$children) > 0)
  
  good <- vapply(node$children, function(x) x %is% "rstata_expression", TRUE)
  raiseifnot(length(which(!good)) != 0)
  
  invisible(TRUE)
}

verifynode.rstata_type_constructor <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot(names(node$data) == c("type_spec"))
  raiseifnot(valid_data_type(node$data$type_spec))
  
  #Children - length, names, types
  raiseifnot(length(node$children) == 1)
  raiseifnot(names(node$children) == c("varlist"))
  raiseifnot(node$children[[1]] %is% "rstata_expression_list")
  
  invisible(TRUE)
}

verifynode.rstata_argument_expression_list <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)
  
  #Children - length, names, types
  raiseifnot(length(node$children) > 0)
  
  good <- vapply(node$children, function(x) x %is% "rstata_expression", TRUE)
  raiseifnot(length(which(!good)) != 0)
  
  good <- vapply(node$children, function(x) !(x %is% "rstata_assignment_expression"), TRUE)
  raiseifnot(length(which(!good)) != 0)
  
  invisible(TRUE)
}

##############################################################################
## Expression branch nodes - literals are above

verifynode.rstata_expression <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) > 0)
  raiseifnot("verb" %in% names(node$data))
  
  NextMethod()
}

## Labels and tightly binding factor operators
verifynode.rstata_label_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

verifynode.rstata_indicator_expression <-
  function(node)
  {
    #Data members - length, names, values
    #Children - length, names, types
    
  }

verifynode.rstata_baseline_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

verifynode.rstata_continuous_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

verifynode.rstata_omit_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

verifynode.rstata_cross_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

## Arithmetic expressions
verifynode.rstata_unary_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

verifynode.rstata_additive_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

verifynode.rstata_multiplication_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

verifynode.rstata_power_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

## Logical, relational and other expressions
verifynode.rstata_equality_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

verifynode.rstata_logical_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

verifynode.rstata_postfix_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

verifynode.rstata_relational_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}

verifynode.rstata_assignment_expression <-
function(node)
{
  #Data members - length, names, values
  #Children - length, names, types
  
}
