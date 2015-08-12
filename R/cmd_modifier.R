### Modifier commands for ado commands: the quietly, noisily, capture prefixes and
### by/xi commands that can accompany other "main" commands. Others may be implemented
### in the future.

rstata_cmd_quietly <-
function(to_call, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_noisily <-
function(to_call, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_capture <-
function(to_call, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_by <-
function(varlist, to_call=NULL, option_list=NULL, return.match.call=NULL)
{
    #check that to_call is not actually null
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_bysort <-
function(varlist, to_call=NULL, option_list=NULL, return.match.call=NULL)
{
    #check that to_call is not actually null
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_xi <-
function(expression_list=NULL, option_list=NULL, to_call=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

