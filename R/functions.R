### Functions providing certain infix ado operators, type constructors,
### and Stata function calls. Some of these functions may not need to
### be implemented, but having stubs here to document their existence
### makes things clearer.

#Helper functions for gsort - ascending sort
ado_func_asc <-
function(col)
{
    return(list(asc=TRUE, col=as.character(col)))
}

#Helper functions for gsort - descending sort
ado_func_desc <-
function(col)
{
    return(list(asc=FALSE, col=as.character(col)))
}

ado_func_recode_rule_ident <-
function(args)
{
    #FIXME
}

ado_func_recode_rule_range <-
function(args)
{
    #FIXME
}

ado_func_recode_rule_numlist <-
function(args)
{
    #FIXME
}

ado_func_collapse_stata <-
function(args)
{
    #FIXME
}

ado_func_collapse_reassign <-
function(args)
{
    #FIXME
}

ado_func_collapse_newvar <-
function(args)
{
    #FIXME
}

ado_func_lrtest_termlist <-
function(args)
{
    #FIXME
}

#the "c." operator
op_cont <-
function(arg)
{
    #FIXME
}

#the "i." operator
op_ind <-
function(arg)
{
    #FIXME
}

#the "o." operator
op_omit <-
function(arg)
{
    #FIXME
}

#the "ib." and "b." operators
op_base <-
function(arg)
{
    #FIXME
}

#the "#" operator
`%#%` <-
function(left, right)
{
    #FIXME
}

#the "##" operator
`%##%` <-
function(left, right)
{
    #FIXME
}

#a version of "==" that handles NA the way Stata does
`%==%` <-
function(left, right)
{
    #FIXME
}

#a pair of infix operators allowed only in expressions given
#to the anova command
`%anova_nest%` <-
function(left, right)
{
    #FIXME
}

`%anova_error%` <-
function(left, right)
{
    #FIXME
}

#type constructor operators
ado_type_double <-
function(vars)
{
    #FIXME
}

ado_type_str <-
function(vars)
{
    #FIXME
}

ado_type_byte <- ado_type_double
ado_type_int <- ado_type_double
ado_type_long <- ado_type_double
ado_type_float <- ado_type_double
ado_type_double <- ado_type_double
