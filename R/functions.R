### Functions providing certain infix ado operators, type constructors,
### and Stata function calls. Some of these functions may not need to
### be implemented.

#Helper functions for gsort - ascending sort
ado_func_asc <-
function(col, context=NULL)
{
    return(list(asc=TRUE, col=as.character(col)))
}

#Helper functions for gsort - descending sort
ado_func_desc <-
function(col, context=NULL)
{
    return(list(asc=FALSE, col=as.character(col)))
}

ado_func_recode_rule_ident <-
function(args, context=NULL)
{
    #FIXME
}

ado_func_recode_rule_range <-
function(args, context=NULL)
{
    #FIXME
}

ado_func_recode_rule_numlist <-
function(args, context=NULL)
{
    #FIXME
}

ado_func_collapse_stata <-
function(args, context=NULL)
{
    #FIXME
}

ado_func_collapse_reassign <-
function(args, context=NULL)
{
    #FIXME
}

ado_func_collapse_newvar <-
function(args, context=NULL)
{
    #FIXME
}

ado_func_lrtest_termlist <-
function(args, context=NULL)
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

#The ado_func_{e,r,c} functions are the getters for (e,r,c)-class values; the
#name format is so that the code generator can generate calls to them the same
#way it generates calls to every other function. The setters don't have this
#constraint because there's intentionally no user-facing way to set a value in
#these environments, other than as a side effect of a command. Stata doesn't
#allow it except through programming functionality that's not supported here,
#and we're not going to come up with another way to do so.

ado_func_e <-
function(val=NULL, enum=FALSE, context=NULL)
{
    raiseif(is.null(context), msg="Context must be non-NULL")
    raiseif(is.null(val) && !enum,
            msg="Must provide argument to ado_func_e")

    if(enum)
        return(context$eclass$all_symbols())
    else
        return(context$eclass$symbol_value(val))
}

ado_func_r <-
function(val=NULL, enum=FALSE, context=NULL)
{
    raiseif(is.null(context), msg="Context must be non-NULL")
    raiseif(is.null(val) && !enum,
            msg="Must provide argument to ado_func_r")

    if(enum)
        return(context$rclass$all_symbols())
    else
        return(context$rclass$symbol_value(val))
}

ado_func_c <-
function(val=NULL, enum=FALSE, context=NULL)
{
    raiseif(is.null(context), msg="Context must be non-NULL")
    raiseif(is.null(val) && !enum,
            msg="Must provide argument to ado_func_c")

    #These are the ones implemented in get_varying_cclass_values
    varying <- c('current_date', 'current_time', 'mode', 'console',
                 'hostname', 'username', 'tmpdir', 'pwd', 'N', 'k',
                 'width', 'changed', 'filename', 'filedate', 'memory',
                 'niceness', 'rng', 'rc', 'rngstate')

    if(enum)
        return(c(context$cclass$all_symbols(), varying))
    else if(val %in% varying)
        return(get_varying_cclass_value(val, context=context))
    else
        return(context$cclass$symbol_value(val))

}
