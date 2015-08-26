### Modifier commands for ado commands: the quietly, noisily, capture prefixes and
### by/xi commands that can accompany other "main" commands. Others may be implemented
### in the future.

rstata_cmd_quietly <-
function(to_call, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    #We do need to eval the to_call command,
    #but we don't need to print anything
    invisible(eval(to_call, envir=parent.frame(), enclos=baseenv()))
}

rstata_cmd_noisily <-
function(to_call, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    #This command is basically a no-op
    eval(to_call, envir=parent.frame(), enclos=baseenv())
}

rstata_cmd_capture <-
function(to_call, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    #Eval the command given in to_call, but catch any exceptions
    #it throws so they don't propagate upward
    
}

#The next three commands (by, bysort, xi) all take an option to_call for
#the subsidiary command object that they should evaluate. The to_call option
#defaults to NULL in by and bysort not because it's an optional argument, but because
#it's built and filled in later in the code generation process than the point
#at which these arguments are checked. If it's not NULL, there's a spurious
#missing-argument error, and it's not currently worth re-architecting to fix that.
#The whole thing is a possible future FIXME.
rstata_cmd_by <-
function(varlist, to_call=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    valid_opts <- c("sort", "rc0")
    option_list <- validateOpts(option_list, valid_opts)
    
    #If requested, sort the dataset by the variables
    if(hasOption(option_list, "sort"))
    {
        cl <- do.call(call, c("arrange", as.symbol("rstata_dta"), varlist), quote=TRUE)
        op <- bquote(rstata_dta <- .(cl))
        
        eval(op, envir=rstata_env)
    }
    
    
}

rstata_cmd_bysort <-
function(varlist, to_call=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    valid_opts <- c("rc0")
    option_list <- validateOpts(option_list, valid_opts)
    
    #No point duplicating this code; let's call the by function
    option_list[[length(option_list)+1]] <- list(name=as.symbol("sort"))
    rstata_cmd_by(varlist, to_call, option_list, return.match.call)
}

rstata_cmd_xi <-
function(expression_list=NULL, option_list=NULL, to_call=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    #validate options
    valid_opts <- c("prefix", "omit", "noomit")
    option_list <- validateOpts(option_list, valid_opts)
    
    #expand the termlist we've gotten into indicator variables, which we'll
    #need to do regardless of whether there's a to_call command to execute
    #FIXME
    
    #to_call is actually optional here. If it's present, we're
    #a modifier command and we need to eval it. If it's missing,
    #we're a main command and we can just return, printing nothing.
    if(!is.null(to_call))
        eval(to_call, envir=parent.frame(), enclos=baseenv())
    else
        invisible(NULL)
}

