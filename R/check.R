### Semantic analysis - the "weeding" phase of the interpreter. After we get back an
### AST, do some semantic checks on it, including things that Stata considers syntax,
### and raise error conditions if the checks fail.

#' @export
check <-
function(node, debug_level=0)
{
  #General checks all AST nodes should pass
  raiseifnot(node %is% "rstata_ast_node")
  raiseifnot(every(c("data", "children") %in% names(node)))

  #Recursively check the children
  if(length(node$children) > 0)
  {
   named <- names(node$children)[which(names(node$children) != "")]
   raiseifnot(length(named) == length(unique(named)))

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
  raiseifnot(length(node$children) == 0)

  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot("value" %in% names(node$data))

  NextMethod()
}

#' @export
verifynode.rstata_ident <-
function(node, debug_level=0)
{
  raiseifnot(length(grep("^[_A-Za-z][A-Za-z0-9_]*$", node$data["value"])) > 0)
  raiseifnot(!is.null(as.symbol(node$data["value"])))

  invisible(TRUE)
}

#' @export
verifynode.rstata_number <-
function(node, debug_level=0)
{
  val <- as.numeric(node$data["value"])
  valid_missings <- c(".", paste0(".", LETTERS, sep=""))
  raiseifnot((!is.na(val) && !is.null(val)) ||
             node$data["value"] %in% valid_missings)

  invisible(TRUE)
}

#' @export
verifynode.rstata_string_literal <-
function(node, debug_level=0)
{
  val <- as.character(node$data["value"])
  raiseifnot(!is.na(val) && !is.null(val))

  invisible(TRUE)
}

#' @export
verifynode.rstata_datetime <-
function(node, debug_level=0)
{
  val <- as.POSIXct(strptime(node$data["value"], format="%d%b%Y %H:%M:%S"))
  raiseifnot(!is.na(val) && !is.null(val))

  invisible(TRUE)
}

##############################################################################
## Command parts
#' @export
verifynode.rstata_if_clause <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  raiseifnot(length(node$children) %in% c(0, 1))

  if(length(node$children) == 1)
  {
    raiseifnot("if_expression" %in% names(node$children))
    raiseifnot(node$children[[1]] %is% "rstata_expression" ||
               node$children[[1]] %is% "rstata_literal")
  }

  invisible(TRUE)
}

#' @export
verifynode.rstata_in_clause <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  raiseifnot(length(node$children) %in% c(0, 2))

  if(length(node$children) == 2)
  {
    raiseifnot(every(c("upper", "lower") %in% names(node$children)))

    raiseifnot(node$children[[1]] %is% "rstata_number")
    raiseifnot(node$children[[2]] %is% "rstata_number")
  }

  invisible(TRUE)
}

#' @export
verifynode.rstata_using_clause <-
function(node, debug_level=0)
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

#' @export
verifynode.rstata_weight_clause <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  raiseifnot(length(node$children) %in% c(0, 2))

  if(length(node$children) == 2)
  {
    raiseifnot(c("left", "right") %in% names(node$children))

    raiseifnot(node$children$left %is% "rstata_ident")
    raiseifnot(node$children$right %is% "rstata_expression" ||
               node$children$right %is% "rstata_literal")
  }

  invisible(TRUE)
}

#' @export
verifynode.rstata_option_list <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  #Length at least 0, checked above
  #No name requirements for children
  raiseifnot(every(vapply(node$children, function(x) x %is% "rstata_option", TRUE)))

  invisible(TRUE)
}

#' @export
verifynode.rstata_option <-
function(node, debug_level=0)
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
#' @export
verifynode.rstata_compound_cmd <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  #No name requirements for children
  raiseifnot(length(node$children) > 0)
  raiseifnot(every(vapply(node$children,
                          function(x) x %is% "rstata_embedded_code" ||    #embedded R or sh code
                                      x %is% "rstata_cmd" ||              #a usual Stata cmd
                                      x %is% "rstata_modifier_cmd_list",  #a Stata cmd with modifiers
                          TRUE)))

  invisible(TRUE)
}

#' @export
verifynode.rstata_modifier_cmd_list <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  raiseifnot(length(node$children) > 0)
  raiseifnot(every(vapply(node$children,
                          function(x) x %is% "rstata_modifier_cmd" ||
                                      x %is% "rstata_general_cmd",
                          TRUE)))

  named <- names(node$children)[which(names(node$children) != "")]
  raiseifnot(length(named) == 1 && named == c("main_cmd"))

  pos <- match("main_cmd", names(node$children))
  raiseifnot(pos == length(names(node$children)))
}

#' @export
verifynode.rstata_embedded_code <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 2)

  raiseifnot("value" %in% names(node$data))
  raiseifnot(!is.na(as.character(node$data["value"])))

  raiseifnot("lang" %in% names(node$data))
  raiseifnot(!is.na(as.character(node$data["lang"])))

  #Children - length, names, types
  raiseifnot(length(node$children) == 0)

  invisible(TRUE)
}

#' @export
verifynode.rstata_cmd <-
function(node, debug_level=0)
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

#' @export
verifynode.rstata_modifier_cmd <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  raiseifnot(length(node$children) == 1)
  raiseifnot(names(node$children) == c("verb"))
  raiseifnot(node$children$verb %is% "rstata_ident")

  func <- paste0("rstata_cmd_", tolower(node$children$verb$data["value"]))
  func <- unabbreviateCommand(func, "BadCommandException")

  raiseifnot(func %in% paste0("rstata_cmd_", c("quietly", "noisily", "capture")))
  raiseifnot(exists(func))

  invisible(TRUE)
}

#' @export
verifynode.rstata_general_cmd <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  func <- paste0("rstata_cmd_", tolower(node$children$verb$data["value"]))
  func <- unabbreviateCommand(func, "BadCommandException")
  raiseifnot(exists(func))

  args <-
  tryCatch(
  {
    formals(get(func))
  },
  error=function(c) c)

  if(inherits(args, "error"))
  {
    raiseCondition("Command not found", "BadCommandException")
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

  raiseifnot(every(given %in% names(args)))
  raiseifnot(every(vapply(names(args),
                          function(x) is.null(args[[x]]) || x %in% given,
                          TRUE)))

  raiseifnot(every(correct_arg_types_for_cmd(chlds)))

  invisible(TRUE)
}

#' @export
verifynode.rstata_special_cmd <-
function(node, debug_level=0)
{
  func <- tolower(node$children$verb$data["value"])
  func <- paste0("rstata_cmd_", func)
  func <- unabbreviateCommand(func, "BadCommandException")

  raiseifnot(func %in% paste0("rstata_cmd_",
                              c("merge", "generate", "recast", "display", "format", "xi")))
  raiseifnot(exists(func))

  args <-
  tryCatch(
  {
      formals(get(func))
  },
  error=function(c) c)

  if(inherits(args, "error"))
  {
      raiseCondition("Command not found", "BadCommandException")
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
  raiseifnot(every(given %in% names(args)))
  raiseifnot(every(vapply(names(args),
                          function(x) is.null(args[[x]]) || x %in% given,
                          TRUE)))

  raiseifnot(every(correct_arg_types_for_cmd(chlds)))

  #checks of node-specific data
  if(func == "rstata_cmd_merge")
  {
    raiseifnot(length(node$data) == 1)
    raiseifnot(names(node$data) == c("merge_spec"))
    raiseifnot(node$data["merge_spec"] %in% c("m:m", "m:1", "1:m", "1:1"))
  } else if(func == "display")
  {
    raiseifnot(length(node$data) %in% c(0, 1))

    if(length(node$data == 1))
    {
      raiseifnot(names(node$data) == c("format_spec"))
      raiseifnot(valid_format_spec(node$data["format_spec"]))
    }
  } else if(func == "rstata_cmd_format")
  {
    raiseifnot(length(node$data) == 1)
    raiseifnot(names(node$data) == c("format_spec"))
    raiseifnot(valid_format_spec(node$data["format_spec"]))
  } else if(func == "rstata_cmd_xi")
  {
    raiseifnot(length(node$data) == 0)
  }

  invisible(TRUE)
}

##############################################################################
## Lists of expressions
#' @export
verifynode.rstata_expression_list <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  raiseifnot(length(node$children) > 0)

  raiseifnot(every(vapply(node$children, function(x) x %is% "rstata_expression" || x %is% "rstata_literal", TRUE)))

  invisible(TRUE)
}

#' @export
verifynode.rstata_argument_expression_list <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  raiseifnot(length(node$children) > 0)

  raiseifnot(every(vapply(node$children, function(x) x %is% "rstata_expression" || x %is% "rstata_literal", TRUE)))

  raiseifnot(every(vapply(node$children,
                          function(x) !(x %is% "rstata_assignment_expression") &&
                                      !(x %is% "rstata_factor_expression") &&
                                      !(x %is% "rstata_cross_expression"),
                          TRUE)))

  invisible(TRUE)
}

##############################################################################
## Expression branch nodes - literals are above
#' @export
verifynode.rstata_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) > 0)
  raiseifnot("verb" %in% names(node$data))

  NextMethod()
}

#' @export
verifynode.rstata_type_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 0)

  #Children - length, names, types
  raiseifnot(length(node$children) == 1)
  raiseifnot(names(node$children) == c("left"))
  raiseifnot(node$children$left %is% "rstata_expression_list" ||
             node$children$left %is% "rstata_ident")
  if(node$children$left %is% "rstata_expression_list")
    raiseifnot(every(vapply(node$children$left$children, function(x) x %is% "rstata_ident", TRUE)))

  invisible(TRUE)
}

## Tightly binding factor operators
#' @export
verifynode.rstata_factor_expression <-
function(node, debug_level=0)
{
  #Children - length, names, types
  raiseifnot(length(node$children) == 1)
  raiseifnot("left" %in% names(node$children))

  raiseifnot(node$children$left %is% "rstata_ident")

  NextMethod()
}

#' @export
verifynode.rstata_continuous_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)

  invisible(TRUE)
}

#' @export
verifynode.rstata_indicator_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(node$data["verb"] == "i.")

  nm <- setdiff(names(node$data), c("verb"))

  if(length(nm == 0))
    return(invisible(TRUE))
  else if(length(nm) == 1 && nm == c("level"))
    raiseifnot(!is.na(as.numeric(node$data["level"])))
  else if(length(nm) == 2 && ("levelstart" %in% nm && "levelend" %in% nm))
    raiseifnot(!is.na(as.numeric(node$data["levelstart"])) &&
               !is.na(as.numeric(node$data["levelend"])))
  else if(length(grep("level[0-9]+", nm)) == length(nm))
    raiseifnot(every(vapply(nm, function(x) !is.na(as.numeric(x)), TRUE)))
  else
    raiseifnot(1==0, msg="Bad levels for factor operator")

  invisible(TRUE)
}

#' @export
verifynode.rstata_omit_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) > 1)
  raiseifnot(node$data["verb"] == "o.")

  nm <- setdiff(names(node$data), c("verb"))

  if(length(nm) == 1 && nm == c("level"))
    raiseifnot(!is.na(as.numeric(node$data["level"])))
  else if(length(nm) == 2 && ("levelstart" %in% nm && "levelend" %in% nm))
    raiseifnot(!is.na(as.numeric(node$data["levelstart"])) &&
                 !is.na(as.numeric(node$data["levelend"])))
  else if(length(grep("level[0-9]+", nm)) == length(nm))
    raiseifnot(every(vapply(nm, function(x) !is.na(as.numeric(x)), TRUE)))
  else
    raiseifnot(1==0, msg="Bad levels for factor operator")

  invisible(TRUE)
}

#' @export
verifynode.rstata_baseline_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 2)
  raiseifnot(node$data["verb"] == "ib.")

  raiseifnot("level" %in% names(node$data))

  raiseifnot(node$data["level"] %in% c("n", "freq", "last", "first") ||
             !is.na(as.numeric(node$data["level"])))

  invisible(TRUE)
}

#' @export
verifynode.rstata_cross_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot(node$data["verb"] %in% c("##", "#"))

  #Children - length, names, types
  raiseifnot(length(node$children) == 2)
  raiseifnot(every(c("left", "right") %in% names(node$children)))

  raiseifnot(node$children$left %is% "rstata_ident" ||
             node$children$left %is% "rstata_factor_expression")

  raiseifnot(node$children$right %is% "rstata_ident" ||
               node$children$right %is% "rstata_factor_expression")

  invisible(TRUE)
}

## Arithmetic expressions
#' @export
verifynode.rstata_power_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot(node$data["verb"] == "^")

  #Children - length, names, types
  raiseifnot(length(node$children) == 2)
  raiseifnot(every(c("left", "right") %in% names(node$children)))

  raiseifnot(node$children$left %is% "rstata_ident" ||
             node$children$left %is% "rstata_number" ||
             node$children$left %is% "rstata_arithmetic_expression")

  raiseifnot(node$children$right %is% "rstata_ident" ||
               node$children$right %is% "rstata_number" ||
               node$children$right %is% "rstata_arithmetic_expression")

  invisible(TRUE)
}

#' @export
verifynode.rstata_unary_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot(node$data["verb"] %in% c("-", "+", "!"))

  #Children - length, names, types
  raiseifnot(length(node$children) == 1)
  raiseifnot("right" %in% names(node$children))

  raiseifnot(node$children$right %is% "rstata_ident" ||
               node$children$right %is% "rstata_number" ||
               node$children$right %is% "rstata_arithmetic_expression")

  invisible(TRUE)
}

#' @export
verifynode.rstata_multiplication_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot(node$data["verb"] %in% c("*", "/"))

  #Children - length, names, types
  raiseifnot(length(node$children) == 2)
  raiseifnot(every(c("left", "right") %in% names(node$children)))

  raiseifnot(node$children$left %is% "rstata_ident" ||
               node$children$left %is% "rstata_number" ||
               node$children$left %is% "rstata_arithmetic_expression")

  raiseifnot(node$children$right %is% "rstata_ident" ||
               node$children$right %is% "rstata_number" ||
               node$children$right %is% "rstata_arithmetic_expression")

  invisible(TRUE)
}

#' @export
verifynode.rstata_additive_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot(node$data["verb"] %in% c("+", "-"))

  #Children - length, names, types
  raiseifnot(length(node$children) == 2)
  raiseifnot(every(c("left", "right") %in% names(node$children)))

  raiseifnot(node$children$left %is% "rstata_ident" ||
               node$children$left %is% "rstata_number" ||
               node$children$left %is% "rstata_arithmetic_expression")

  raiseifnot(node$children$right %is% "rstata_ident" ||
               node$children$right %is% "rstata_number" ||
               node$children$right %is% "rstata_arithmetic_expression")

  invisible(TRUE)
}

## Logical, relational and other expressions
#' @export
verifynode.rstata_equality_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot(node$data["verb"] %in% c("=="))

  #Children - length, names, types
  raiseifnot(length(node$children) == 2)
  raiseifnot(every(c("left", "right") %in% names(node$children)))

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
    )
  )

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
      )
  )

  invisible(TRUE)
}

#' @export
verifynode.rstata_logical_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot(node$data["verb"] %in% c("&", "|"))

  #Children - length, names, types
  raiseifnot(length(node$children) == 2)
  raiseifnot(every(c("left", "right") %in% names(node$children)))

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
    )
  )

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
    )
  )

  invisible(TRUE)
}

#' @export
verifynode.rstata_relational_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot(node$data["verb"] %in% c(">", "<", ">=", "<="))

  #Children - length, names, types
  raiseifnot(length(node$children) == 2)
  raiseifnot(every(c("left", "right") %in% names(node$children)))

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
    )
  )

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
    )
  )

  invisible(TRUE)
}

#' @export
verifynode.rstata_postfix_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot(node$data["verb"] %in% c("()", "[]"))

  #Children - length, names, types
  raiseifnot(length(node$children) %in% c(1, 2))

  raiseifnot("left" %in% names(node$children))
  raiseifnot(node$children$left %is% "rstata_ident")

  if(length(node$children) == 2)
  {
    raiseifnot("right" %in% names(node$children))
    raiseifnot(
        (
          node$children$right %is% "rstata_expression" ||
          node$children$right %is% "rstata_literal" ||
          node$children$right %is% "rstata_argument_expression_list"
        )
        && !(node$children$right %is% "rstata_factor_expression")
        && !(node$children$right %is% "rstata_cross_expression")
        && !(node$children$right %is% "rstata_type_expression")
    )
  }

  invisible(TRUE)
}

#' @export
verifynode.rstata_assignment_expression <-
function(node, debug_level=0)
{
  #Data members - length, names, values
  raiseifnot(length(node$data) == 1)
  raiseifnot(node$data["verb"] %in% c("="))

  #Children - length, names, types
  raiseifnot(length(node$children) == 2)
  raiseifnot(every(c("left", "right") %in% names(node$children)))

  raiseifnot(node$children$left %is% "rstata_ident")

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
    )
  )

  invisible(TRUE)
}

