### The "weeding" phase of the interpreter. After we get back an AST, do some
### semantic checks on it, and raise error conditions if the checks fail.
### This function dispatches by the AST node's S3 class.

weed <-
function(node)
UseMethod("weed")

## Literals
weed.rstata_ident <-
function(node)
{

}

weed.rstata_number <-
function(node)
{

}

weed.rstata_string_literal <-
function(node)
{

}

weed.rstata_datetime <-
function(node)
{

}

weed.rstata_type_constructor <-
function(node)
{

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

## Command parts and expressions
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

weed.rstata_if_clause <-
function(node)
{

}

weed.rstata_in_clause <-
function(node)
{

}

weed.rstata_option_list <- #should we actually have an option node?
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

