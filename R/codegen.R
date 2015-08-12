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

codegen <-
function(node)
UseMethod("codegen")

## Literals
codegen.rstata_ident <-
function(node)
{
    as.symbol(node$data$value)
}

codegen.rstata_number <-
function(node)
{
    as.numeric(node$data$value)
}

codegen.rstata_string_literal <-
function(node)
{
    as.character(node$data$value)
}

codegen.rstata_datetime <-
function(node)
{
    as.POSIXct(strptime(node$data$value, format="%d%b%Y %H:%M:%S"))
}

codegen.rstata_type_constructor <-
function(node)
{

}

## Compound and atomic commands
codegen.rstata_compound_cmd <-
function(node)
{

}

codegen.rstata_modifier_cmd_list <- #should this exist?
function(node)
{

}

codegen.rstata_embedded_r_cmd <-
function(node)
{
    #A stub from an older function - expand
    #vals <- lapply(lapply(parse(text=txt), eval), capture.output)

    #do.call(paste0, c(vals, list(collapse="\n")))

}

codegen.rstata_general_cmd <-
function(node)
{

}

## Command parts and expressions
codegen.rstata_expression <-
function(node)
{

}

codegen.rstata_expression_list <-
function(node)
{

}

codegen.rstata_argument_expression_list <-
function(node)
{

}

codegen.rstata_if_clause <-
function(node)
{

}

codegen.rstata_in_clause <-
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

codegen.rstata_using_clause <-
function(node)
{

}

codegen.rstata_weight_clause <-
function(node)
{

}

