### After we've weeded the AST and know that it satisfies assumptions,
### we need to recursively step through it and evaluate each command.
### We can do that in two steps, leveraging what's already part of R:
###     1) construct an unevaluated call from the AST for each command,
###        where the call is to one of the functions written to implement
###        a Stata command
###     2) call eval :)
### This shouldn't actually be recursive, because R doesn't / can't eliminate
### tail calls. What can we do instead?

#check for each function?
#        if(mode(walked) != "expression")
#        {
#            cond <- simpleError("Bad AST generated")
#            class(cond) <- c(class(cond), "bad_command")
#
#            signalCondition(cond)
#        }

walk <-
function(node)
UseMethod("walk")

## Literals
walk.rstata_ident <-
function(node)
{
    weed(node)

    as.symbol(node$data$value)
}

walk.rstata_number <-
function(node)
{
    weed(node)

    as.numeric(node$data$value)
}

walk.rstata_string_literal <-
function(node)
{
    weed(node)

    as.character(node$data$value)
}

walk.rstata_datetime <-
function(node)
{
    weed(node)

    
}

walk.rstata_type_constructor <-
function(node)
{
    weed(node)


}

## Compound and atomic commands
walk.rstata_compound_cmd <-
function(node)
{
    weed(node)


}

walk.rstata_modifier_cmd_list <- #should this exist?
function(node)
{
    weed(node)


}

walk.rstata_embedded_r_cmd <-
function(node)
{
    weed(node)

    #A stub from an older function - expand
    #vals <- lapply(lapply(parse(text=txt), eval), capture.output)

    #do.call(paste0, c(vals, list(collapse="\n")))

}

walk.rstata_general_cmd <-
function(node)
{
    weed(node)


}

## Command parts and expressions
walk.rstata_expression <-
function(node)
{
    weed(node)


}

walk.rstata_expression_list <-
function(node)
{
    weed(node)


}

walk.rstata_argument_expression_list <-
function(node)
{
    weed(node)


}

walk.rstata_if_clause <-
function(node)
{
    weed(node)


}

walk.rstata_in_clause <-
function(node)
{
    weed(node)


}

walk.rstata_option_list <-
function(node)
{
    weed(node)


}

walk.rstata_option <-
function(node)
{
    weed(node)


}

walk.rstata_using_clause <-
function(node)
{
    weed(node)


}

walk.rstata_weight_clause <-
function(node)
{
    weed(node)


}

