### Modifier commands for ado commands: the quietly, noisily, capture prefixes and
### by/xi commands that can accompany other "main" commands. Others may be implemented
### in the future.

ado_cmd_quietly <-
function(context, to_call)
{
    #We do need to eval the to_call command, but we don't need to print anything
    invisible(eval(to_call, envir=parent.frame(), enclos=baseenv()))
}

ado_cmd_noisily <-
function(context, to_call)
{
    #This command is basically a no-op
    eval(to_call, envir=parent.frame(), enclos=baseenv())
}

ado_cmd_capture <-
function(context, to_call)
{
    #Eval the command given in to_call, but catch any exceptions
    #it throws so they don't propagate upward
    val <-
    tryCatch(
    {
        eval(to_call, envir=parent.frame(), enclos=baseenv())
    },
    error=function(c) c,
    BadCommandException=function(c) c,
    EvalErrorException=function(c) c)

    conds <- c("error", "BadCommandException", "EvalErrorException")
    if(!inherits(val, conds))
    {
        return(val) #for printing
    } else
    {
        return(invisible(NULL))
    }
}

ado_cmd_xi <-
function(context, expression_list=NULL, option_list=NULL, to_call=NULL)
{
    valid_opts <- c("prefix", "omit", "noomit")
    option_list <- validateOpts(option_list, valid_opts)
    
    omit <- hasOption(option_list, "omit")
    noomit <- hasOption(option_list, "noomit")
    
    if(omit && noomit)
    {
        raiseCondition("Cannot specify both omit and noomit at once")
    }
    
    if(hasOption(option_list, "prefix"))
    {
        prefix <- optionArgs(option_list, "prefix")[[1]]
    } else
    {
        prefix <- "_I"
    }
    
    #expand the termlist we've gotten into indicator variables, which we'll
    #need to do regardless of whether there's a to_call command to execute
    #FIXME
    
    #to_call is actually optional here. If it's present, we're
    #a modifier command and we need to eval it. If it's missing,
    #we're a main command and we can just return, printing nothing.
    if(!is.null(to_call))
        return(eval(to_call, envir=parent.frame(), enclos=baseenv()))
    else
        return(invisible(NULL))
}

#The to_call argument defaults to NULL in by and bysort not because it's optional,
#but because it's built and filled in later in the code generation process than
#the point at which these arguments are checked. If it's not NULL, there's a spurious
#missing-argument error, and it's not currently worth re-architecting to fix that.
ado_cmd_bysort <-
function(context, varlist, to_call=NULL, option_list=NULL)
{
    if(is.null(to_call))
    {
        raiseCondition("Must specify a command for by/bysort to execute")
    }

    valid_opts <- c("rc0")
    option_list <- validateOpts(option_list, valid_opts)

    #No point duplicating code; let's call the by command
    option_list[[length(option_list)+1]] <- list(name=as.symbol("sort"))
    ado_cmd_by(context=context, varlist=varlist, to_call=to_call,
               option_list=option_list)
}

ado_cmd_by <-
function(context, varlist, to_call=NULL, option_list=NULL)
{
    if(is.null(to_call))
    {
        raiseCondition("Must specify a command for by/bysort to execute")
    }

    valid_opts <- c("sort", "rc0")
    option_list <- validateOpts(option_list, valid_opts)

    varlist <- vapply(varlist, as.character, character(1))

    #If requested, sort the dataset by the variables
    if(hasOption(option_list, "sort"))
        context$dta$sort(varlist)

    #Get the variables saying what to group by
    #idx <- dt$iloc(rows, byvars)

    #if(!hasOption(option_list, "rc0"))
    #{
    #
    #} else
    #{
    #
    #}
    #
    #return(structure(ret, class=c("ado_cmd_by", class(ret))))
}

ado_cmd_xi <-
function(context, expression_list=NULL, option_list=NULL, to_call=NULL)
{
    valid_opts <- c("prefix", "omit", "noomit")
    option_list <- validateOpts(option_list, valid_opts)

    omit <- hasOption(option_list, "omit")
    noomit <- hasOption(option_list, "noomit")

    if(omit && noomit)
    {
        raiseCondition("Cannot specify both omit and noomit at once")
    }

    if(hasOption(option_list, "prefix"))
    {
        prefix <- optionArgs(option_list, "prefix")[[1]]
    } else
    {
        prefix <- "_I"
    }

    #expand the termlist we've gotten into indicator variables, which we'll
    #need to do regardless of whether there's a to_call command to execute
    #FIXME

    #to_call is actually optional here. If it's present, we're
    #a modifier command and we need to eval it. If it's missing,
    #we're a main command and we can just return, printing nothing.
    if(!is.null(to_call))
        return(eval(to_call, envir=parent.frame(), enclos=baseenv()))
    else
        return(invisible(NULL))
}

