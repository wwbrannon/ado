# =============================================================================
ado_cmd_regress <-
function(expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_glm <-
function(expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_binreg <-
function(expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_nbreg <-
function(expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_gnbreg <-
function(expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_logistic <-
function(expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_logit <-
function(expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_poisson <-
function(expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_probit <-
function(expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

# =============================================================================

ado_cmd_ameans <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, option_list=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_anova <-
function(expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_areg <-
function(varlist, option_list, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_bitest <-
function(expression, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_ci <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, option_list=NULL, 
         context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_correlate <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, option_list=NULL, 
         context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_estimates <-
function(expression_list, using_clause=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

#not interpretable as a formula, but still syntactically a varlist
ado_cmd_fvset <-
function(varlist, option_list=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_icc <-
function(varlist, if_clause=NULL, in_clause=NULL, option_list=NULL,
         context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_ivregress <-
function(varlist, option_list, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_ksmirnov <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_kwallis <-
function(expression, option_list, if_clause=NULL, in_clause=NULL,
         context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_lrtest <-
function(expression_list, option_list=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_margins <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_mean <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_ologit <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

#NB: type names may be used; only a minor inconvenience because the vars
#    this command generates have to be some kind of numeric type
ado_cmd_pctile <-
function(expression, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
      return(match.call())
}

#NB: type names may be used; only a minor inconvenience because the vars
#    this command generates have to be some kind of numeric type
ado_cmd_predict <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_prtest <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_pwcorr <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, option_list=NULL, 
         context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_ranksum <-
function(expression, option_list, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_sktest <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_summarize <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_tab1 <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
      return(match.call())
}

ado_cmd_tab2 <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
      return(match.call())
}

ado_cmd_table <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_tabstat <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_tabulate <-
function(varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
      return(match.call())
}

ado_cmd_test <-
function(expression_list, context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_ttest <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_xtile <-
function(expression, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

#FIXME
ado_cmd_power <-
function(..., context=NULL, return.match.call=FALSE)
{
  if(return.match.call)
    return(match.call())
}

ado_cmd_tab <- ado_cmd_tabulate
