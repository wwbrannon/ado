### After we've weeded the AST and know that it satisfies assumptions,
### we need to recursively step through it and evaluate each command.
### We can do that in two steps, leveraging what's already part of R:
###     1) construct an unevaluated call from the AST for each command,
###        where the call is to one of the functions written to implement
###        a Stata command
###     2) call eval :)
### This shouldn't actually be recursive, because R doesn't / can't eliminate
### tail calls. What can we do instead?

evaluate <-
function(node)
UseMethod("evaluate")

## Literals
evaluate.rstata_ident <-
function(node)
{
    as.symbol(node$data$value)
}

evaluate.rstata_number <-
function(node)
{
    as.numeric(node$data$value)
}

evaluate.rstata_string_literal <-
function(node)
{
    as.character(node$data$value)
}

evaluate.rstata_datetime <-
function(node)
{
    
}

evaluate.rstata_type_constructor <-
function(node)
{

}

## Compound and atomic commands
evaluate.rstata_compound_cmd <-
function(node)
{

}

evaluate.rstata_modifier_cmd_list <- #should this exist either?
function(node)
{

}

evaluate.rstata_embedded_r_cmd <-
function(node)
{
    #A stub from an older function - expand
    vals <- lapply(lapply(parse(text=txt), eval), capture.output)

    do.call(paste0, c(vals, list(collapse="\n")))

}

evaluate.rstata_general_cmd <-
function(node)
{

}

## Command parts and expressions
evaluate.rstata_expression <-
function(node)
{

}

evaluate.rstata_expression_list <-
function(node)
{

}

evaluate.rstata_argument_expression_list <-
function(node)
{

}

evaluate.rstata_if_clause <-
function(node)
{

}

evaluate.rstata_in_clause <-
function(node)
{

}

evaluate.rstata_option_list <-
function(node)
{

}

evaluate.rstata_option <-
function(node)
{

}

evaluate.rstata_using_clause <-
function(node)
{

}

evaluate.rstata_weight_clause <-
function(node)
{

}

