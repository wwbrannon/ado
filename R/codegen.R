### Code generation. At this point, we've "weeded" the AST and know it satisfies
### our assumptions. Now it's time to generate a list containing
### one unevaluated call for each Stata command. Next, we'll evaluate these objects
### for a) their side effects, b) values which are objects with print() methods.

#' @export
codegen <-
function(node)
UseMethod("codegen")

##############################################################################
## Compound and atomic commands
#' @export
codegen.rstata_compound_cmd <-
function(node)
{
  lst <- list()
  chlds <- lapply(node$children, codegen)

  for(chld in chlds)
    lst[[length(lst)+1]] <- chld

  do.call(expression, lst)
}

#' @export
codegen.rstata_if_cmd <-
function(node)
{
    as.call(list(as.symbol("rstata_cmd_if"),
            expression=codegen(node$children$expression),
            compound_cmd=codegen(node$children$compound_cmd)))
}

#' @export
codegen.rstata_embedded_code <-
function(node)
{
  if(node$data["lang"] == "R")
    return(parse(text=node$data["value"]))

  if(node$data["lang"] == "shell")
    return(as.call(list(as.symbol("system"), command=node$data["value"])))
}

#' @export
codegen.rstata_cmd <-
function(node)
{
  NextMethod()
}

#' @export
codegen.rstata_general_cmd <-
function(node)
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
function(node)
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
function(node)
{
  verb <- as.character(codegen(node$children$verb))
  verb <- unabbreviateCommand(paste0("rstata_cmd_", verb))
  verb <- get(verb, mode="function")

  as.call(list(verb))
}

#' @export
codegen.rstata_modifier_cmd_list <-
function(node)
{
  lst <- rev(lapply(node$children, codegen))

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
function(node)
{
  codegen(node$children$if_expression)
}

#' @export
codegen.rstata_in_clause <-
function(node)
{
  list(upper=codegen(node$children$upper),
       lower=codegen(node$children$lower))
}

#' @export
codegen.rstata_using_clause <-
function(node)
{
  as.character(codegen(node$children$filename))
}

#' @export
codegen.rstata_weight_clause <-
function(node)
{
  list(variable=codegen(node$children$left),
       weight_expression=codegen(node$children$right))
}

#' @export
codegen.rstata_option <-
function(node)
{
  if("args" %in% names(node$children))
    list(name=codegen(node$children$name),
         args=codegen(node$children$args))
  else
    list(name=codegen(node$children$name))
}

#' @export
codegen.rstata_option_list <-
function(node)
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
function(node)
{
  lapply(node$children, codegen)
}

#' @export
codegen.rstata_argument_expression_list <-
function(node)
{
  lapply(node$children, codegen)
}

##############################################################################
## Expression branch nodes
#' @export
codegen.rstata_expression <-
function(node)
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
function(node)
{
  NextMethod()
}

#' @export
codegen.rstata_ident <-
function(node)
{
  as.symbol(node$data["value"])
}

#' @export
codegen.rstata_number <-
function(node)
{
  as.numeric(node$data["value"])
}

#' @export
codegen.rstata_string_literal <-
function(node)
{
  as.character(node$data["value"])
}

#' @export
codegen.rstata_datetime <-
function(node)
{
  as.POSIXct(node$data["value"])
}
