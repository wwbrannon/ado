rstata_cmd_ameans <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

#FIXME
rstata_cmd_anova <-
function(return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_areg <-
function(varlist, option_list, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_binreg <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_bitest <-
function(expression, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_ci <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, option_list=NULL, by_dta=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_correlate <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, option_list=NULL, by_dta=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_estimates <-
function(expression_list, using_clause=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

#not interpretable as a formula, but still syntactically a varlist
rstata_cmd_fvset <-
function(varlist, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_glm <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_gnbreg <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
      return(match.call())
}

rstata_cmd_icc <-
function(varlist, if_clause=NULL, in_clause=NULL, option_list=NULL,
         by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

#FIXME
rstata_cmd_ivregress <-
function(return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_ksmirnov <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_kwallis <-
function(expression, option_list, if_clause=NULL, in_clause=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_logistic <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_logit <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
      return(match.call())
}

#FIXME
rstata_cmd_lrtest <-
function(return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}


rstata_cmd_margins <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_mean <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_nbreg <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_ologit <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_pctile <-
function(expression, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
      return(match.call())
}

rstata_cmd_poisson <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_predict <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_probit <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_prtest <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_pwcorr <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, option_list=NULL, by_dta=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_ranksum <-
function(expression, option_list, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_regress <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_sktest <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_summarize <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_tab <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
      return(match.call())
}

rstata_cmd_tab1 <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
      return(match.call())
}

rstata_cmd_tab2 <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
      return(match.call())
}

rstata_cmd_table <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_tabstat <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_tabulate <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, by_dta=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
      return(match.call())
}

#FIXME
rstata_cmd_test <-
function(return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_ttest <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         by_dta=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

#FIXME
rstata_cmd_power <-
function(return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

