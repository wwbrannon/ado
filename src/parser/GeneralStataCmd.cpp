#include <Rcpp.h>
#include "RStata.hpp"

using namespace Rcpp;

GeneralStataCmd::GeneralStataCmd(std::string _verb,
                   std::string _weight, std::string _using_filename,
                   int _has_range, int _range_lower, int _range_upper,
                   BaseExprNode *_varlist, BaseExprNode *_assign_stmt,
                   BaseExprNode *_if_exp, OptionListExprNode *_options)
{
    verb = _verb;
    ChildCmd = NULL;

    varlist = _varlist;
    assign_stmt = _assign_stmt;
    if_exp = _if_exp;
    options = _options;

    has_range = _has_range;
    range_lower = _range_lower;
    range_upper = _range_upper;

    weight = _weight;
    using_filename = _using_filename;
}

List GeneralStataCmd::as_R_object() const
{
    List res;
   
    res = List::create(_["func"]            = Symbol("dispatch.rstata.cmd"),
                       _["verb"]            = verb,
                       _["child"]           = ChildCmd->as_R_object(),
                       _["varlist"]         = varlist->as_R_object(),
                       _["assign_stmt"]     = assign_stmt->as_R_object(),
                       _["if_exp"]          = if_exp->as_R_object(),
                       _["options"]         = options->as_R_object(),
                       _["range_lower"]     = range_lower,
                       _["range_upper"]     = range_upper,
                       _["weight"]          = weight,
                       _["using_filename"]  = using_filename);
    
    return res;
}

