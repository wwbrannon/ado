#include <Rcpp.h>
#include "RStata.hpp"

using namespace Rcpp;

GeneralStataCmd::GeneralStataCmd(IdentExprNode *_verb,
                   BranchExprNode *_weight, std::string _using_filename,
                   int _has_range, int _range_lower, int _range_upper,
                   BranchExprNode *_varlist, BranchExprNode *_assign_stmt,
                   BranchExprNode *_if_exp, BranchExprNode *_options)
               : BranchExprNode("GeneralStataCmd", "")
{
    verb = _verb;

    varlist = _varlist;
    assign_stmt = _assign_stmt;
    if_exp = _if_exp;
    options = _options;
    weight = _weight;

    has_range = _has_range;
    range_lower = _range_lower;
    range_upper = _range_upper;

    using_filename = _using_filename;
}

// for EmbeddedRCmd
GeneralStataCmd::GeneralStataCmd(std::string _verb)
               : BranchExprNode("GeneralStataCmd", "")
{
    verb = new IdentExprNode(_verb);

    varlist = NULL;
    assign_stmt = NULL;
    if_exp = NULL;
    options = NULL;
    weight = NULL;

    has_range = 0;
    range_lower = 0;
    range_upper = 0;

    using_filename = "";
}

List GeneralStataCmd::as_R_object() const
{
    List res;
   
    res = List::create(_["func"]            = Symbol("dispatch.rstata.cmd"),
                       _["verb"]            = verb->as_R_object(),
                       _["varlist"]         = varlist->as_R_object(),
                       _["assign_stmt"]     = assign_stmt->as_R_object(),
                       _["if_exp"]          = if_exp->as_R_object(),
                       _["options"]         = options->as_R_object(),
                       _["range_lower"]     = range_lower,
                       _["range_upper"]     = range_upper,
                       _["weight"]          = weight->as_R_object(),
                       _["using_filename"]  = using_filename);
    
    return res;
}

