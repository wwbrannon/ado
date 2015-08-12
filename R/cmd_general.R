### The initial set of commands to implement. They cover a broad
### selection of Stata features and will help test the infrastructure
### other commands will eventually rely on.

## Quitting the REPL
rstata_cmd_exit <-
function()
{
  raiseCondition("Exit requested", "ExitRequestedException")
}

rstata_cmd_quit <-
function()
{
  raiseCondition("Exit requested", "ExitRequestedException")
}

## Data manipulation commands
rstata_cmd_generate <-
function(expression, type_spec=NULL, if_clause=NULL, in_clause=NULL, option_list=NULL)
{
  match.call()
}

rstata_cmd_insheet <-
function(using_clause, varlist=NULL, option_list=NULL)
{
  match.call()
}

## Immediate commands
rstata_cmd_display <-
function(expression, format_spec=NULL)
{
  match.call()
}

## Stats commands
rstata_cmd_logit <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL, option_list=NULL)
{
  match.call()
}

rstata_cmd_tabulate <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL, option_list=NULL)
{
  match.call()
}

#Others
rstata_cmd_about <-
function()
{

}

rstata_cmd_help <-
function()
{

}

rstata_cmd_log <-
function()
{

}

rstata_cmd_set <-
function()
{

}

rstata_cmd_file <-
function()
{

}

rstata_cmd_preserve <-
function()
{

}

rstata_cmd_restore <-
function()
{

}

rstata_cmd_sleep <-
function()
{

}

rstata_cmd_do <-
function()
{

}
