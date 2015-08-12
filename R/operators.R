### Functions providing certain infix ado operators.
### Several of these functions don't need to be implemented, but
### having stubs here to document their existence is clearer.

#type constructor operators don't appear here, but the
#function_for_ado_operator function can return each valid
#type name as a symbol

#the "c." operator
op_cont <-
function(arg)
{

}

#the "i." operator
op_ind <-
function(arg)
{

}

#the "o." operator
op_omit <-
function(arg)
{

}

#the "ib." and "b." operators
op_base <-
function(arg)
{

}

#the "#" operator
`%#%` <-
function(left, right)
{

}

#the "##" operator
`%##%` <-
function(left, right)
{

}

#a version of "==" that handles NA the way Stata does
`%==%` <-
function(left, right)
{
  
}

#a pair of infix operators allowed only in expressions given
#to the anova command
`%anova_nest%` <-
function(left, right)
{

}

`%anova_error%` <-
function(left, right)
{

}

