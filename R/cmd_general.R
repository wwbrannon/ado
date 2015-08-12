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
  rstata_dta <- get("rstata_dta", envir=rstata_env)
  rstata_macro_env <- get("rstata_macro_env", envir=rstata_env)
  rstata_settings_env <- get("rstata_settings_env", envir=rstata_env)
  
  print(rstata_dta)
  print(rstata_macro_env)
  print(rstata_settings_env)
  
  print(match.call())
}

rstata_cmd_insheet <-
function(using_clause, varlist=NULL, option_list=NULL)
{
  print(match.call())
}

## Immediate commands
rstata_cmd_display <-
function(expression, format_spec=NULL)
{
  print(match.call())
}

## Stats commands
rstata_cmd_logit <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL, option_list=NULL)
{
  print(match.call())
}

rstata_cmd_tabulate <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL, option_list=NULL)
{
  print(match.call())
}

## Macro management commands
rstata_cmd_local <-
function(expression)
{
  print(match.call())
}

rstata_cmd_global <-
function(expression)
{
  print(match.call())
}
