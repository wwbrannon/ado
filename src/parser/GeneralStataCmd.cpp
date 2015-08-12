#include <Rcpp.h>
#include "RStata.hpp"

using namespace Rcpp;

GeneralStataCmd::GeneralStataCmd(IdentExprNode *_verb,
                   BranchExprNode *_weight, BranchExprNode *_using_clause,
                   BranchExprNode *_varlist, BranchExprNode *_assign_stmt,
                   BranchExprNode *_if_clause, BranchExprNode *_in_clause,
                   BranchExprNode *_options)
               : BranchExprNode("GeneralStataCmd", "")
{
    verb = _verb;

    varlist = _varlist;
    assign_stmt = _assign_stmt;
    if_clause = _if_clause;
    in_clause = _in_clause;
    options = _options;
    weight = _weight;
    using_clause = _using_clause;
}

// for EmbeddedRCmd
GeneralStataCmd::GeneralStataCmd(std::string _verb)
               : BranchExprNode("GeneralStataCmd", "")
{
    verb = new IdentExprNode(_verb);

    varlist = NULL;
    assign_stmt = NULL;
    if_clause = NULL;
    in_clause = NULL;
    options = NULL;
    weight = NULL;
    using_clause = NULL;
}

List GeneralStataCmd::as_R_object() const
{
    List res;
   
    res = List::create(_["func"]            = Symbol("dispatch.rstata.cmd"),
                       _["verb"]            = verb->as_R_object(),
                       _["varlist"]         = varlist->as_R_object(),
                       _["assign_stmt"]     = assign_stmt->as_R_object(),
                       _["if_clause"]       = if_clause->as_R_object(),
                       _["in_clause"]       = in_clause->as_R_object(),
                       _["options"]         = options->as_R_object(),
                       _["weight"]          = weight->as_R_object(),
                       _["using_clause"]    = using_clause->as_R_object());
    
    return res;
}

