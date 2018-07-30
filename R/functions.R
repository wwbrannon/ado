### Functions providing certain infix ado operators, type constructors,
### and Stata function calls. Some of these functions may not need to
### be implemented.

#Helper functions for gsort - ascending sort
ado_func_asc <-
function(context, col)
{
    return(list(asc=TRUE, col=as.character(col)))
}

#Helper functions for gsort - descending sort
ado_func_desc <-
function(context, col)
{
    return(list(asc=FALSE, col=as.character(col)))
}

ado_func_recode_rule_ident <-
function(context, args)
{
    #FIXME
}

ado_func_recode_rule_range <-
function(context, args)
{
    #FIXME
}

ado_func_recode_rule_numlist <-
function(context, args)
{
    #FIXME
}

ado_func_collapse_stata <-
function(context, args)
{
    #FIXME
}

ado_func_collapse_reassign <-
function(context, args)
{
    #FIXME
}

ado_func_collapse_newvar <-
function(context, args)
{
    #FIXME
}

ado_func_lrtest_termlist <-
function(context, args)
{
    #FIXME
}

#the "c." operator
op_cont <-
function(context, arg)
{
    #FIXME
}

#the "i." operator
op_ind <-
function(context, arg)
{
    #FIXME
}

#the "o." operator
op_omit <-
function(context, arg)
{
    #FIXME
}

#the "ib." and "b." operators
op_base <-
function(context, arg)
{
    #FIXME
}

#the "#" operator
`%#%` <-
function(context, left, right)
{
    #FIXME
}

#the "##" operator
`%##%` <-
function(context, left, right)
{
    #FIXME
}

#a version of "==" that handles NA the way Stata does
`%==%` <-
function(context, left, right)
{
    #FIXME
}

#a pair of infix operators allowed only in expressions given
#to the anova command
`%anova_nest%` <-
function(context, left, right)
{
    #FIXME
}

`%anova_error%` <-
function(context, left, right)
{
    #FIXME
}

#type constructor operators
ado_type_double <-
function(context, vars)
{
    #FIXME
}

ado_type_str <-
function(context, vars)
{
    #FIXME
}

ado_type_byte <- ado_type_double
ado_type_int <- ado_type_double
ado_type_long <- ado_type_double
ado_type_float <- ado_type_double
ado_type_double <- ado_type_double

#The ado_func_{e,r,c} functions are the getters for (e,r,c)-class values; the
#name format is so that the code generator can generate calls to them the same
#way it generates calls to every other function. The setters don't have this
#constraint because there's intentionally no user-facing way to set a value in
#these environments, other than as a side effect of a command. Stata doesn't
#allow it except through programming functionality that's not supported here,
#and we're not going to come up with another way to do so.

ado_func_e <-
function(context, val=NULL, enum=FALSE)
{
    return(context$eclass_query(val=val, enum=enum))
}

ado_func_r <-
function(context, val=NULL, enum=FALSE)
{
    return(context$rclass_query(val=val, enum=enum))
}

ado_func_c <-
function(context, val=NULL, enum=FALSE)
{
    return(context$cclass_query(val=val, enum=enum))
}

