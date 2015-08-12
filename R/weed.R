### Semantic analysis - the "weeding" phase of the interpreter. After we get back an
### AST, do some semantic checks on it, including things that Stata considers syntax,
### and raise error conditions if the checks fail.

weed <-
function(node)
{
  #General checks all AST nodes should pass
  raiseifnot(node %is% "rstata_ast_node")
  raiseifnot(every(c("type", "data", "children") %in% names(node)))
  
  #Recursively check the children
  if(length(node$children) > 0)
  {
    for(chld in node$children)
      weed(chld)
  }
  
  #Check this node
  UseMethod("weed")
}

##############################################################################
## Literals
weed.rstata_literal <-
function(node)
{
  #Children - length, names, types
  raiseifnot(length(node$children) == 0)
  
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot("value" %in% names(node$data))
  
  NextMethod()
}

weed.rstata_ident <-
function(node)
{
  raiseifnot(length(grep("^[A-Za-z_]+$", node$data$value)) > 0)
  raiseifnot(!is.na(as.symbol(node$data$value)) ||
               !is.null(as.symbol(node$data$value)))
  
  invisible(TRUE)
}

weed.rstata_number <-
function(node)
{
  val <- as.numeric(node$data$value)
  valid_missings <- c(".", paste0(".", LETTERS, sep=""))
  raiseifnot((!is.na(val) && !is.null(val)) ||
             node$data$value %in% valid_missings)
  
  invisible(TRUE)
}

weed.rstata_string_literal <-
function(node)
{
  val <- as.character(node$data$value)
  raiseifnot(!is.na(val) && !is.null(val))

  invisible(TRUE)
}

weed.rstata_datetime <-
function(node)
{
  val <- as.POSIXct(strptime(node$data$value, format="%d%b%Y %H:%M:%S"))
  raiseifnot(!is.na(val) && !is.null(val))

  invisible(TRUE)
}

##############################################################################
## Command parts
weed.rstata_if_clause <-
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

weed.rstata_in_clause <-
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

weed.rstata_using_clause <-
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

weed.rstata_weight_clause <-
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

weed.rstata_option_list <-
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

weed.rstata_option <-
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
weed.rstata_compound_cmd <-
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

weed.rstata_embedded_r <-
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

weed.rstata_cmd <-
function(node)
{
  #Children - length, names, types
  raiseifnot(length(node$children) > 0)
  raiseifnot("verb" %in% names(node$children))

  valid_children <- c("main_cmd", "next_modifier", "verb", "varlist",
                      "if_clause", "in_clause", "weight_clause",
                      "using_clause", "option_list", "expression")
  
  raiseifnot(every(names(node$children) %in% valid_children))
  
  #Data members - length, names, values
  #No restrictions on number, names or values of data members

  NextMethod()
}

weed.rstata_modifier_cmd <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)
  
  #Children - length, names, types
  raiseifnot(length(node$children) == 2)
  raiseifnot(names(node$children) %in% c("verb", "main_cmd", "next_modifier"))
  
  invisible(TRUE)
}

weed.rstata_modifier_cmd_list <-
function(node)
{
  #Children - length, names, types
  #Data members - length, names, values
}

#FIXME: how should we check these?
weed.rstata_general_cmd <-
function(node)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)
  
  #Children - length, names, types
  #use formals()
}

weed.rstata_special_cmd <-
function(node)
{
  #use formals()
}

##############################################################################
## Expressions and lists of expressions
weed.rstata_expression <-
function(node)
{
  #Children - length, names, types
  #Data members - length, names, values
}

weed.rstata_expression_list <-
function(node)
{
  #Children - length, names, types
  #Data members - length, names, values
}

weed.rstata_argument_expression_list <-
function(node)
{
  #Children - length, names, types
  #Data members - length, names, values
}

weed.rstata_type_constructor <-
function(node)
{
  #Children - length, names, types
  #Data members - length, names, values
}
