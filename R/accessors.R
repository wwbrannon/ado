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
allSettings <-
function()
{
    env <- get("rstata_settings_env", envir=rstata_env)
    
    ls(envir=env)
}

assignSetting <-
function(name, value)
{
    env <- get("rstata_settings_env", envir=rstata_env)
    assign(name, value, envir=env)
}

getSettingValue <-
function(name)
{
    env <- get("rstata_settings_env", envir=rstata_env)
    get(name, envir=env)
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
function(val=NULL, enum=FALSE)
{
    if(is.null(val) && !enum)
    {
        raiseCondition("Must provide argument to rstata_func_e")
    }
    
    env <- get("rstata_eclass_env", envir=rstata_env, inherits=FALSE)
    
    if(enum)
    {
        return(ls(envir=env))
    } else
    {
        return(get(val, envir=env, inherits=FALSE))
    }
}

rstata_func_r <-
function(val=NULL, enum=FALSE)
{
    if(is.null(val) && !enum)
    {
        raiseCondition("Must provide argument to rstata_func_r")
    }
    
    env <- get("rstata_rclass_env", envir=rstata_env, inherits=FALSE)
    
    if(enum)
    {
        return(ls(envir=env))
    } else
    {
        return(get(val, envir=env, inherits=FALSE))
    }
}

rstata_func_c <-
function(val=NULL, enum=FALSE)
{
    if(is.null(val) && !enum)
    {
        raiseCondition("Must provide argument to rstata_func_c")
    }
    
    env <- get("rstata_cclass_env", envir=rstata_env, inherits=FALSE)
    
    #If explictly requested, return a list of all the c-class values known.
    #The calls to this function built by codegen() will never have enum=TRUE.
    if(enum)
    {
        ret <- ls(envir=env)
        
        #These are the ones implemented below
        ret <- c(ret, 'current_date', 'current_time', 'rstata_version', 'bit',
                 'processors', 'processors_mach', 'processors_max', 'mode',
                 'console', 'os', 'osdtl', 'rversion', 'hostname', 'machine_type',
                 'byteorder', 'username', 'tmpdir', 'pwd', 'dirsep', 'max_N_theory',
                 'max_k_theory', 'max_width_theory', 'max_macrolen', 'macrolen',
                 'max_cmdlen', 'cmdlen', 'namelen', 'mindouble', 'maxdouble',
                 'epsdouble', 'smallestdouble', 'minlong', 'maxlong', 'minfloat',
                 'maxfloat', 'epsfloat', 'maxstrvarlen', 'maxstrlvarlen', 'N', 'k',
                 'width', 'changed', 'filename', 'filedate', 'memory', 'maxvar',
                 'niceness', 'rng', 'rc', 'rngstate')
                 
        return(ret)
    }
    
    if(val == 'current_date')
    {
        return(Sys.Date())
    } else if(val == 'current_time')
    {
        return(Sys.time())
    } else if(val == 'rstata_version')
    {
        return(packageVersion(packageName()))
    } else if(val == 'bit')
    {
        return(8 * .Machine$sizeof.pointer)
    } else if(val == 'processors')
    {
        return(parallel::detectCores())
    } else if(val == 'processors_mach')
    {
        return(parallel::detectCores())
    } else if(val == 'processors_max')
    {
        return(parallel::detectCores())
    } else if(val == 'mode')
    {
        if(interactive())
        {
            return("")
        } else
        {
            return("batch")
        }
    } else if(val == 'console')
    {
        if(.Platform$GUI == "unknown")
        {
            return("console")
        } else
        {
            return("")
        }
    } else if(val == 'os')
    {
        if(.Platform$OS.type == "windows")
        {
            return("Windows")
        } else if(Sys.info()["sysname"] == "Darwin")
        {
            return("MacOSX")
        } else
        {
            return("Unix")
        }
    } else if(val == 'osdtl')
    {
        s <- Sys.info()
        return(s["release"] %p% " " %p% s["version"])
    } else if(val == 'rversion')
    {
        return(R.version$version.string)
    } else if(val == 'hostname')
    {
        return(Sys.info()["nodename"])
    } else if(val == 'machine_type')
    {
        return(sessionInfo()$platform)
    } else if(val == 'byteorder')
    {
        if(.Platform$endian == 'big')
            return("hilo")
        else
            return("lohi")
    } else if(val == 'username')
    {
        return(Sys.info()["user"])
    } else if(val == 'tmpdir')
    {
        return(tempdir())
    } else if(val == 'pwd')
    {
        return(getwd())
    } else if(val == 'dirsep')
    {
        return(.Platform$file.sep)
    } else if(val == 'max_N_theory')
    {
        return(2^31 - 1)
    } else if(val == 'max_k_theory')
    {
        return(2^31 - 1)
    } else if(val == 'max_width_theory')
    {
        #This corresponds to a data.frame of 2^31 - 1 columns and 2^31 - 1 rows,
        #where each cell is a string of 2^31 - 1 bytes' length. There's a reason that
        #this variable's name ends in "theory".
        return( (2^31 - 1)^3 )
    } else if(val == 'max_macrolen')
    {
        #As hardcoded into our lexer: see ado.fl's redefinition
        #of the C macro YYLMAX
        return(2^16)
    } else if(val == 'macrolen')
    {
        return(2^16)
    } else if(val == 'max_cmdlen')
    {
        #The real limit is on the length of a single lexer token, which can
        #be no longer than 2^16 bytes. There's no limit on the length of
        #commands, provided they can be represented as R strings, and an R
        #string can be no longer than 2^31 - 1 bytes. Note that encountering
        #a single token longer than YYLMAX = 2^16 bytes will cause yylex() to
        #raise an R error condition rather than calling the C exit() function
        #on the R process.
        return(2^31 - 1)
    } else if(val == 'cmdlen')
    {
        return(2^31 - 1)
    } else if(val == 'namelen')
    {
        #The maximum length of the symbol type as of R 2.13.0
        return(10000)
    } else if(val == 'mindouble')
    {
        #Almost if not quite exactly right
        return(-.Machine$double.xmax)
    } else if(val == 'maxdouble')
    {
        return(.Machine$double.xmax)
    } else if(val == 'epsdouble')
    {
        return(.Machine$double.eps)
    } else if(val == 'smallestdouble')
    {
        return(.Machine$double.xmin)
    } else if(val == 'minlong')
    {
        #R does have a 4-byte integer type, even though integers are
        #generally represented as doubles
        return(-2^31 + 1)
    } else if(val == 'maxlong')
    {
        return(2^31 - 1)
    } else if(val == 'minfloat')
    {
        #Almost if not quite exactly right
        return(-.Machine$double.xmax)
    } else if(val == 'maxfloat')
    {
        return(.Machine$double.xmax)
    } else if(val == 'epsfloat')
    {
        return(.Machine$double.eps)
    } else if(val == 'maxstrvarlen')
    {
        return(2^31 - 1)
    } else if(val == 'maxstrlvarlen')
    {
        #The str# and strL types as we implement them are the same
        return(2^31 - 1)
    } else if(val == 'N')
    {
        dt <- get("rstata_dta", envir=rstata_env)
        return(dt$dim[1])
    } else if(val == 'k')
    {
        dt <- get("rstata_dta", envir=rstata_env)
        return(dt$dim[2])
    } else if(val == 'width')
    {
        dt <- get("rstata_dta", envir=rstata_env)
        return(object.size(dt))
    } else if(val == 'changed')
    {
        dt <- get("rstata_dta", envir=rstata_env)
        return(dt$changed)
    } else if(val == 'filename')
    {
        dt <- get("rstata_dta", envir=rstata_env)
        return(dt$filename)
    } else if(val == 'filedate')
    {
        dt <- get("rstata_dta", envir=rstata_env)
        return(dt$filedate)
    } else if(val == 'memory')
    {
        #it's appalling that this is the recommended way to check mem usage
        mem <- gc()
        return( 1024 * (mem[1, "(Mb)"] + mem[2, "(Mb)"]) )
    } else if(val == 'maxvar')
    {
        #This is the limit on vector size hardcoded into R in various places;
        #the newer long vectors can be, of course, longer, but using them is
        #still difficult and we've made no effort to do so.
        return(2^31 - 1)
    } else if(val == 'niceness')
    {
        return(tools::psnice())
    } else if(val == 'rng')
    {
        return(paste0(RNGkind(), collapse=" "))
    } else if(val == 'rngstate')
    {
        return(paste0(.Random.seed, collapse=","))
    } else if(val == 'rc')
    {
        #FIXME - need to implement the machinery for commands to have
        #return codes; it's not clear what this should look like in an
        #implementation where control flow at a low level is based on
        #calls to signalCondition().
        return(0)
    } else
    {
        return(get(val, envir=env, inherits=FALSE))
    }
}
