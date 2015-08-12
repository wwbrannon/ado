### Semantic analysis - the "weeding" phase of the interpreter. After we get back an
### AST, do some semantic checks on it, including things that Stata considers "syntax,"
### and raise error conditions if the checks fail.

## What to verify?
##    number and type of child nodes
##    number and type of data members
##    presence of particular named data members

## What to verify? Recursively:
##    


weed <-
function(node)
UseMethod("weed")

## Literals
weed.rstata_ident <-
function(node)
{
    raiseifnot(length(node$children) == 0)
    raiseifnot(length(node$data) == 1)
    raiseifnot("value" %in% names(node$data))
    
    raiseifnot(length(grep("^[A-Za-z_]+$", node$data$value)) > 0)
    raiseifnot(!is.na(as.symbol(node$data$value)) ||
                 !is.null(as.symbol(node$data$value)))
    
    invisible(NULL)
}

weed.rstata_number <-
function(node)
{
    raiseifnot(length(node$children) == 0)
    raiseifnot(length(node$data) == 1)
    raiseifnot("value" %in% names(node$data))

    raiseifnot(!is.na(as.numeric(node$data$value)) ||
               !is.null(as.numeric(node$data$value)))

    invisible(NULL)
}

weed.rstata_string_literal <-
function(node)
{
  raiseifnot(length(node$children) == 0)
  raiseifnot(length(node$data) == 1)
  raiseifnot("value" %in% names(node$data))

  raiseifnot(!is.na(as.character(node$data$value)) &&
               !is.null(as.character(node$data$value)))

  invisible(NULL)  
}

weed.rstata_datetime <-
function(node)
{
  raiseifnot(length(node$children) == 0)
  raiseifnot(length(node$data) == 1)
  raiseifnot("value" %in% names(node$data))
  
  val <- as.POSIXct(strptime(node$data$value, format="%d%b%Y %H:%M:%S"))
  raiseifnot(!is.na(val) && !is.null(val))

  invisible(NULL)
}

## Compound and atomic commands
weed.rstata_compound_cmd <-
function(node)
{

}

weed.rstata_modifier_cmd_list <- #should this exist either?
function(node)
{

}

weed.rstata_embedded_r_cmd <-
function(node)
{

}

weed.rstata_general_cmd <-
function(node)
{

}

## Expressions and lists of expressions
weed.rstata_expression <-
function(node)
{

}

weed.rstata_expression_list <-
function(node)
{

}

weed.rstata_argument_expression_list <-
function(node)
{

}

weed.rstata_type_constructor <-
function(node)
{
  
}

## Command parts
weed.rstata_if_clause <-
function(node)
{

}

weed.rstata_in_clause <-
function(node)
{

}

weed.rstata_option_list <-
function(node)
{

}

weed.rstata_option <-
function(node)
{

}

weed.rstata_using_clause <-
function(node)
{

}

weed.rstata_weight_clause <-
function(node)
{

}
