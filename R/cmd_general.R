### The initial set of commands to implement. They cover a broad
### selection of Stata features and will help test the infrastructure
### other commands will eventually rely on.

## Self-explanatory
rstata_exit <-
function()
{

}

rstata_quit <- rstata_exit

## Data manipulation commands
rstata_generate <-
function(expression, type_spec=NULL, if_clause=NULL, in_clause=NULL, option_list=NULL)
{

}

rstata_insheet <-
function(using_clause, varlist=NULL, option_list=NULL)
{

}

## Immediate commands
rstata_display <-
function(expression, format_spec=NULL)
{

}

## Stats commands
rstata_logit <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL, option_list=NULL)
{

}

rstata_tab <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL, option_list=NULL)
{

}

## Macro management commands
rstata_local <-
function(expression)
{

}

rstata_global <-
function(expression)
{

}

