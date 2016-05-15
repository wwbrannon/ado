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
### Methods to set c-class values
setCClassValue <-
function(name, value)
{
    #FIXME
}
