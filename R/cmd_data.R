rstata_cmd_append <-
function(using_clause, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_clear <-
function(expression=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_codebook <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL,
         option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

#FIXME
rstata_cmd_collapse <-
function(return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_compare <-
function(expression_list, if_clause=NULL, in_clause=NULL, by_dta=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_count <-
function(if_clause=NULL, in_clause=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_decode <-
function(expression, if_clause=NULL, in_clause=NULL, option_list,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_describe <-
function(expression_list=NULL, using_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_destring <-
function(expression_list=NULL, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_dir <-
function(expression=NULL, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_drop <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, by_dta=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_duplicates <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_egen <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL, by_dta=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_encode <-
function(expression, if_clause=NULL, in_clause=NULL, option_list,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_erase <-
function(expression, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_expand <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_flist <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, option_list=NULL,
         by_dta=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_format <-
function(expression_list=NULL, format_spec=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_generate <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL, by_dta=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_gsort <-
function(expression_list, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}


rstata_cmd_insheet <-
function(using_clause, varlist=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_isid <-
function(expression_list, using_clause=NULL, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_keep <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, by_dta=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_label <-
function(expression_list, using_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_list <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, option_list=NULL,
         by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_lookfor <-
function(expression_list, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_ls <-
function(expression, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_merge <-
function(varlist, using_clause, merge_spec, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_mkdir <-
function(expression, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_order <-
function(expression_list, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_recast <-
function(expression, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

#FIXME
rstata_cmd_recode <-
function(return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_rename <-
function(expression_list, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_reshape <-
function(expression_list=NULL, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_rm <-
function(expression, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_rmdir <-
function(expression, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_sample <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL, by_dta=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_save <-
function(expression=NULL, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_separate <-
function(expression, option_list, if_clause=NULL, in_clause=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_sort <-
function(expression, in_clause=NULL, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_split <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_tostring <-
function(expression_list, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_type <-
function(expression, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_use <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, using_clause=NULL,
         option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_xtile <-
function(expression, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

