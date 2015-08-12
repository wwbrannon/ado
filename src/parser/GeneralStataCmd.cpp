#include <Rcpp.h>
#include "rstata.hpp"

using namespace Rcpp;

GeneralStataCmd::GeneralStataCmd(std::string _verb,
                   std::string _weight, std::string _using_filename,
                   int _has_range, int _range_lower, int _range_upper,
                   BaseStataExpr *_modifiers, BaseStataExpr *_varlist,
                   BaseStataExpr *_assign_stmt, BaseStataExpr *_if_exp,
                   BaseStataExpr *_options)
{
    verb = _verb;
    PrefixCmd = NULL;

    modifiers = _modifiers;
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

List GeneralStataCmd::as_list() const
{
    List res;
   
    res = List::create(_["func"]            = Symbol("dispatch.rstata.cmd"),
                       _["verb"]            = verb,
                       _["prefix"]          = PrefixCmd->as_list()
                       _["varlist"]         = varlist->as_expr(),
                       _["assign_stmt"]     = assign_stmt->as_expr(),
                       _["if_exp"]          = if_exp->as_expr(),
                       _["options"]         = options->as_expr(),
                       _["range_lower"]     = range_lower,
                       _["range_upper"]     = range_upper,
                       _["weight"]          = weight,
                       _["using_filename"]  = using_filename);
    
    return res;
}

