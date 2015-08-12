## Macro management commands
rstata_cmd_local <-
function(expression_list)
{
}

rstata_cmd_global <-
function(expression_list)
{
    exprs <- expression_list[[2]]

    if(length(exprs) == 1) #an assignment
    {
        val <- eval(exprs)
    } else
    {

    }
}

rstata_cmd_macro <- #for macro drop
function()
{

}

rstata_cmd_tempfile <-
function()
{

}

