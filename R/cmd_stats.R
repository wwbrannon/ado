# =============================================================================
ado_cmd_regress <-
function(context, expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_glm <-
function(context, expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_binreg <-
function(context, expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_nbreg <-
function(context, expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_gnbreg <-
function(context, expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_logistic <-
function(context, expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_logit <-
function(context, expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_poisson <-
function(context, expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_probit <-
function(context, expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

# =============================================================================

ado_cmd_ameans <-
function(context, varlist=NULL, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, option_list=NULL)
{
}

ado_cmd_anova <-
function(context, expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_areg <-
function(context, varlist, option_list, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL)
{
}

ado_cmd_bitest <-
function(context, expression, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_ci <-
function(context, varlist=NULL, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, option_list=NULL)
{
}

ado_cmd_correlate <-
function(context, varlist=NULL, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, option_list=NULL)
{
}

ado_cmd_estimates <-
function(context, expression_list, using_clause=NULL)
{
}

#not interpretable as a formula, but still syntactically a varlist
ado_cmd_fvset <-
function(context, varlist, option_list=NULL)
{
}

ado_cmd_icc <-
function(context, varlist, if_clause=NULL, in_clause=NULL, option_list=NULL)
{
}

ado_cmd_ivregress <-
function(context, varlist, option_list, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL)
{
}

ado_cmd_ksmirnov <-
function(context, expression, if_clause=NULL, in_clause=NULL, option_list=NULL)
{
}

ado_cmd_kwallis <-
function(context, expression, option_list, if_clause=NULL, in_clause=NULL)
{
}

ado_cmd_lrtest <-
function(context, expression_list, option_list=NULL)
{
}

ado_cmd_margins <-
function(context, varlist=NULL, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_mean <-
function(context, varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_ologit <-
function(context, varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

#NB: type names may be used; only a minor inconvenience because the vars
#    this command generates have to be some kind of numeric type
ado_cmd_pctile <-
function(context, expression, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

#NB: type names may be used; only a minor inconvenience because the vars
#    this command generates have to be some kind of numeric type
ado_cmd_predict <-
function(context, expression, if_clause=NULL, in_clause=NULL, option_list=NULL)
{
}

ado_cmd_prtest <-
function(context, expression, if_clause=NULL, in_clause=NULL, option_list=NULL)
{
}

ado_cmd_pwcorr <-
function(context, varlist=NULL, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL, option_list=NULL)
{
}

ado_cmd_ranksum <-
function(context, expression, option_list, if_clause=NULL, in_clause=NULL,
         weight_clause=NULL)
{
}

ado_cmd_sktest <-
function(context, varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_summarize <-
function(context, varlist=NULL, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_tab1 <-
function(context, varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_tab2 <-
function(context, varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_table <-
function(context, varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_tabstat <-
function(context, varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_tabulate <-
function(context, varlist, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

ado_cmd_test <-
function(context, expression_list)
{
}

ado_cmd_ttest <-
function(context, expression, if_clause=NULL, in_clause=NULL, option_list=NULL)
{
}

ado_cmd_xtile <-
function(context, expression, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL)
{
}

#FIXME
ado_cmd_power <-
function(context, ...)
{
}

ado_cmd_tab <- ado_cmd_tabulate

