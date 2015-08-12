/* Methods for the derived classes of BaseStataExpr */

#include <Rcpp.h>
#include "rstata.hpp"

using namespace Rcpp;

OptionStataExpr::OptionStataExpr(std::string _data, BaseStataExpr **_children)
{
    data = _data;
    children = _children;
}

// The as_expr methods for conversion to R expressions
Language OptionStataExpr::as_expr() const
{
    
}

