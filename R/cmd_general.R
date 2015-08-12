### The initial set of commands to implement. They cover a broad
### selection of Stata features and will help test the infrastructure
### other commands will eventually rely on.

rstata_cmd_about <-
function()
{
    match.call()
}

rstata_cmd_cd <-
function(expression=NULL)
{
    match.call()
}

rstata_cmd_display <-
function(expression, format_spec=NULL)
{
    match.call()
}

rstata_cmd_do <-
function(expression_list, options=NULL)
{
    match.call()
}

rstata_cmd_exit <-
function()
{
    raiseCondition("Exit requested", "ExitRequestedException")
}


rstata_cmd_help <-
function(expression_list, option_list=NULL)
{
    match.call()
}

#the if expr { } construct
rstata_cmd_if <-
function(expression, compound_cmd)
{
    match.call()
}

rstata_cmd_log <-
function(expression_list=NULL, using_clause=NULL, option_list=NULL)
{
    match.call()
}

rstata_cmd_preserve <-
function(option_list=NULL)
{
    match.call()
}

rstata_cmd_pwd <-
function()
{
    match.call()
}

rstata_cmd_query <-
function()
{
    match.call()
}

rstata_cmd_quit <-
function()
{
    raiseCondition("Exit requested", "ExitRequestedException")
}

rstata_cmd_restore <-
function(option_list=NULL)
{
    match.call()
}

rstata_cmd_run <-
function(expression_list, option_list=NULL)
{
    match.call()
}

rstata_cmd_set <-
function(expression_list)
{
    match.call()
}

rstata_cmd_sleep <-
function(expression)
{
    match.call()
}
