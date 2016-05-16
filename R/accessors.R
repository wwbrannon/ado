### ===========================================================================
### Option-list accessor methods

#Validate and unabbreviate the provided options against the list of valid
#options for the function calling this helper.
validateOpts <-
function(option_list, valid_opts)
{
    if(length(option_list) == 0)
        return(option_list)
    
    #Extract the option names as strings
    given <- vapply(option_list, function(x) as.character(x$name), character(1))
    
    #Unabbreviate each option. The unabbreviateName function will raise an
    #error condition if an option is invalid or ambiguous.
    given <- vapply(given, function(x) unabbreviateName(x, valid_opts), character(1))
    
    #The same option can't be given more than once
    raiseifnot(length(given) == length(unique(given)),
               msg="Option given more than once")
    
    #Update the names
    for(i in 1:length(given))
        option_list[[i]]$name <- given[i]
    
    option_list
}

#This function assumes that the option_list has already been validated and
#unabbreviated by the validateOpts function above.
hasOption <-
function(option_list, opt)
{
    nm <- vapply(option_list, function(v) as.character(v$name), character(1))
    opt %in% nm
}

#Get the arguments provided to the option named by opt.
#This function assumes that the option_list has already been validated and
#unabbreviated by the validateOpts function above.
optionArgs <-
function(option_list, opt)
{
    raiseifnot(hasOption(option_list, opt), msg="Option not provided")
    
    #extract the option names as strings
    nm <- vapply(option_list, function(v) as.character(v$name), character(1))
    
    ind <- which(nm == opt)
    if("args" %in% names(option_list[[ind]]))
        return(option_list[[ind]]$args)
    else
        return(NULL)
}

#=============================================================================
### Setting accessor methods
assignSetting <-
function(name, value)
{
    settings_env <- get("rstata_settings_env", envir=rstata_env)
    assign(name, value, envir=settings_env)
}

getSettingValue <-
function(name)
{
    settings_env <- get("rstata_settings_env", envir=rstata_env)
    get(name, envir=settings_env)
}

#=============================================================================
### Setters for (e,r,c)-class values

#One peculiarity of note: for the c-class values, the
#setter method below is the only setter, but the
#getter doesn't just check the c-class environment. It
#also looks up certain c-class values from other places,
#mainly Sys.* R functions and other wrappers around
#system APIs. C-class values not resolved from such
#lookups are looked for here. E-class and r-class
#values don't behave this way, and all values are
#stored in the corresponding environments.

setCClassValue <-
function(name, value)
{
    env <- get("rstata_cclass_env", envir=rstata_env)
    assign(name, value, envir=env)
    
    return(invisible(NULL))
}

setEClassValue <-
function(name, value)
{
    env <- get("rstata_eclass_env", envir=rstata_env)
    assign(name, value, envir=env)
    
    return(invisible(NULL))
}

setRClassValue <-
function(name, value)
{
    env <- get("rstata_rclass_env", envir=rstata_env)
    assign(name, value, envir=env)
    
    return(invisible(NULL))
}

#The rstata_func_{e,r,c} functions are the getters for
#(e,r,c)-class values; the name format is so that the
#code generator can generate calls to them the same way
#it generates calls to every other function. The setters
#don't have this constraint because there's intentionally no
#user-facing way to set a value in these environments, other
#than as a side effect of a command. Stata doesn't allow it
#except through programming functionality that's not supported
#here, and we're not going to come up with another way to do so.

rstata_func_e <-
function(val)
{
    cls_env <- get("rstata_eclass_env", envir=env, inherits=FALSE)
    return(get(val, envir=cls_env, inherits=FALSE))
}

rstata_func_r <-
function(val)
{
    cls_env <- get("rstata_rclass_env", envir=env, inherits=FALSE)
    return(get(val, envir=cls_env, inherits=FALSE))
}

rstata_func_c <-
function(val)
{
    #FIXME - handle special c-class values before falling back to looking val
    #up in the c-class environment. Need to fix a list of which c-class values
    #we'll support to finalize this; may need to set some of them during the
    #still-TODO rstata_env initialization function.
    
    cls_env <- get("rstata_cclass_env", envir=env, inherits=FALSE)
    return(get(val, envir=cls_env, inherits=FALSE))
}
