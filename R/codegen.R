### Code generation. At this point, we've "weeded" the AST and know it satisfies
### our assumptions. Now it's time to generate an expression object containing
### one unevaluated call for each Stata command. Next, we'll evaluate these objects
### for a) their side effects, b) values which are objects with print() methods.

codegen <-
function(node)
UseMethod("codegen")

##############################################################################
## Compound and atomic commands
codegen.rstata_compound_cmd <-
function(node)
{
  lst <- list()
  chlds <- lapply(node$children, codegen)
  
  for(chld in chlds)
  {
    if(!is.expression(chld))
      lst <- c(lst, chld)
    else #we have an "embedded R" cmd, which we should unpack
      lst <- c(lst, as.list(chld))
  }
  
  do.call(expression, lst)
}

codegen.rstata_embedded_r <-
function(node)
{
  parse(text=node$data["value"])
}

codegen.rstata_cmd <-
function(node)
{
  NextMethod()
}

codegen.rstata_modifier_cmd_list <-
function(node)
{
  
}

codegen.rstata_modifier_cmd <-
function(node)
{
}

codegen.rstata_general_cmd <-
function(node)
{
  args <- node$children
  verb <- codegen(args["verb"])
  args <- args[names(args) != "verb"]
  #FIXME
}

codegen.rstata_special_cmd <-
function(node)
{
}

##############################################################################
## Command parts
codegen.rstata_if_clause <-
function(node)
{
}

codegen.rstata_in_clause <-
function(node)
{
}

codegen.rstata_using_clause <-
function(node)
{
}

codegen.rstata_weight_clause <-
function(node)
{
}

codegen.rstata_option_list <-
function(node)
{
}

codegen.rstata_option <-
function(node)
{
}

##############################################################################
## Lists of expressions
codegen.rstata_expression_list <-
function(node)
{
  lapply(node$children, codegen)
}

codegen.rstata_argument_expression_list <-
function(node)
{
  lapply(node$children, codegen)
}

codegen.rstata_type_constructor <-
function(node)
{
}

##############################################################################
## Expression branch nodes
codegen.rstata_expression <-
function(node)
{
  #Get the function to call
  op <- node$children$verb$data["value"]
  op <- function_for_ado_operator(op)
  
  #Get the operator's arguments - one, two, or at least in principle, more
  args <- node$children[names(node$children) != "verb"]
  args <- lapply(args, codegen)
  
  as.call(c(list(op), args))
}

##############################################################################
## Literal expressions
codegen.rstata_literal <-
function(node)
{
  NextMethod()
}

codegen.rstata_ident <-
function(node)
{
  as.symbol(node$data["value"])
}

codegen.rstata_number <-
function(node)
{
  as.numeric(node$data["value"])
}

codegen.rstata_string_literal <-
function(node)
{
  as.character(node$data["value"])
}

codegen.rstata_datetime <-
function(node)
{
  as.POSIXct(node$data["value"])
}
