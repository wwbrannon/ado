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
