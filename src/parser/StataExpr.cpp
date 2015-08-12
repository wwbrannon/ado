/* Methods for the derived classes of BaseStataExpr */

#include <utility>
#include <Rcpp.h>
#include "rstata.hpp"

using namespace Rcpp;

// Constructors
NumberStataExpr::NumberStataExpr(signed long int _data)
{
    NumericVector x(1);
    x[0] = _data;

    data = x;
}

NumberStataExpr::NumberStataExpr(unsigned long int _data)
{
    NumericVector x(1);
    x[0] = _data;

    data = x;
}

NumberStataExpr::NumberStataExpr(long double _data)
{
    NumericVector x(1);
    x[0] = _data;

    data = x;
}

IdentStataExpr::IdentStataExpr(std::string _data)
{
    data = _data;
}

StringStataExpr::StringStataExpr(std::string _data)
{
    data = _data;
}

BranchStataExpr::BranchStataExpr(std::string _data, std::vector<std::unique_ptr<BaseStataExpr>> _children)
{
    data = _data;
    children = std::move(_children);
}

// The as_expr methods for conversion to R expressions
Language NumberStataExpr::as_expr() const
{
    return Language("c", data);
}

Language IdentStataExpr::as_expr() const
{
    return Language("c", data);
}

Language StringStataExpr::as_expr() const
{
    return Language("c", data);
}

Language BranchStataExpr::as_expr() const
{
    return Language("c", 1, 2); // FIXME
}

