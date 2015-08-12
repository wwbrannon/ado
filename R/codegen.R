### Code generation. At this point, we've "weeded" the AST and know it satisfies
### our assumptions. Now it's time to generate a list containing
### one unevaluated call for each Stata command. Next, we'll evaluate these objects
### for a) their side effects, b) values which are objects with print() methods.

#' @export
codegen <-
function(node, debug_level=0)
UseMethod("codegen")

##############################################################################
## Compound and atomic commands
#' @export
codegen.rstata_compound_cmd <-
function(node, debug_level=0)
{
  lst <- list()
  chlds <- lapply(node$children, codegen)

  for(chld in chlds)
    lst[[length(lst)+1]] <- chld

  do.call(expression, lst)
}

#' @export
codegen.rstata_embedded_code <-
function(node, debug_level=0)
{
  if(node$data["type"] == "R")
    return(parse(text=node$data["value"]))

  if(node$data["type"] == "shell")
    return(as.call(list(as.symbol("system", command=node$data["value"]))))
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
  verb <- as.character(codegen(node$children$verb))
  verb <- unabbreviateCommand(paste0("rstata_cmd_", verb))
  verb <- get(verb, mode="function")

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

  args <- lapply(args, codegen)
  names(args) <- nm

  #No data elements in a general command

  ret <- c(verb, args)
  ret <- as.call(ret)

  ret
}

#' @export
codegen.rstata_special_cmd <-
function(node, debug_level=0)
{
  verb <- as.character(codegen(node$children$verb))
  verb <- unabbreviateCommand(paste0("rstata_cmd_", verb))
  verb <- get(verb, mode="function")

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

  args <- lapply(args, codegen)
  names(args) <- nm

  ret <- c(verb, args, node$data)
  ret <- as.call(ret)

  ret
}

#' @export
codegen.rstata_modifier_cmd <-
function(node, debug_level=0)
{
  verb <- as.character(codegen(node$children$verb))
  verb <- unabbreviateCommand(paste0("rstata_cmd_", verb))
  verb <- get(verb, mode="function") #FIXME is this right?

  as.call(list(verb))
}

#' @export
codegen.rstata_modifier_cmd_list <-
function(node, debug_level=0)
{
  lst <- lapply(node$children, codegen)

  Reduce(function(x, y)
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
  codegen(node$children$if_expression)
}

codegen.rstata_in_clause <-
function(node, debug_level=0)
{
  list(upper=codegen(node$children$upper),
       lower=codegen(node$children$lower))
}

#' @export
codegen.rstata_using_clause <-
function(node, debug_level=0)
{
  as.character(codegen(node$children$filename))
}

#' @export
codegen.rstata_weight_clause <-
function(node, debug_level=0)
{
  list(variable=codegen(node$children$left),
       weight_expression=codegen(node$children$right))
}

#' @export
codegen.rstata_option <-
function(node, debug_level=0)
{
  if("args" %in% names(node$children))
    list(name=codegen(node$children$name),
         args=codegen(node$children$args))
  else
    list(name=codegen(node$children$name))
}

#' @export
codegen.rstata_option_list <-
function(node, debug_level=0)
{
  nm <- names(node$children)
  ret <- lapply(node$children, codegen)
  names(ret) <- nm

  ret
}

##############################################################################
## Lists of expressions
#' @export
codegen.rstata_expression_list <-
function(node, debug_level=0)
{
  list(NULL, lapply(node$children, codegen))
}

#' @export
codegen.rstata_argument_expression_list <-
function(node, debug_level=0)
{
  list(NULL, lapply(node$children, codegen))
}

#' @export
codegen.rstata_type_constructor <-
function(node, debug_level=0)
{
  list(node$data["type_spec"], lapply(node$children, codegen))
}

##############################################################################
## Expression branch nodes
#' @export
codegen.rstata_expression <-
function(node, debug_level=0)
{
  #Get the function to call
  op <- node$data["verb"]
  op <- function_for_ado_operator(op)

  #Get the operator's arguments - one, two, or at least in principle, more
  args <- node$children[names(node$children) != "verb"]
  args <- lapply(args, codegen)

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
  as.numeric(node$data["value"])
}

#' @export
codegen.rstata_string_literal <-
function(node, debug_level=0)
{
  as.character(node$data["value"])
}

#' @export
codegen.rstata_datetime <-
function(node, debug_level=0)
{
  as.POSIXct(node$data["value"])
}
