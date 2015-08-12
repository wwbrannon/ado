#Look up an e()-class value
rstata_func_e <-
function(val)
{
    cls_env <- get("rstata_eclass_env", envir=env, inherits=FALSE)
    return(get(val, envir=cls_env, inherits=FALSE))
}

#Look up an r()-class value
rstata_func_r <-
function(val)
{
    cls_env <- get("rstata_rclass_env", envir=env, inherits=FALSE)
    return(get(val, envir=cls_env, inherits=FALSE))
}

#Look up a c()-class value
rstata_func_c <-
function(val)
{
    #FIXME
}

#Helper functions for gsort - ascending sort
rstata_func_asc <-
function(vec)
{
    #FIXME
}

#Helper functions for gsort - descending sort
rstata_func_desc <-
function(vec)
{
    #FIXME
}

rstata_func_recode_rule_ident <-
function(args)
{
    #FIXME
}

rstata_func_recode_rule_range <-
function(args)
{
    #FIXME
}

rstata_func_recode_rule_numlist <-
function(args)
{
    #FIXME
}

rstata_func_collapse_stata <-
function(args)
{
    #FIXME
}

rstata_func_collapse_reassign <-
function(args)
{
    #FIXME
}

rstata_func_collapse_newvar <-
function(args)
{
    #FIXME
}

rstata_func_lrtest_termlist <-
function(args)
{
    #FIXME
}

