/* Methods for the derived classes of BaseStataExpr */

#include <Rcpp.h>
#include "rstata.hpp"

// Constructors
NumberStataExpr::StataExpr(signed long int _data)
{
    Rcpp::NumericVector x(1);
    x[0] = _data;

    data = x;
}

NumberStataExpr::StataExpr(unsigned long int _data)
{
    Rcpp::NumericVector x(1);
    x[0] = _data;

    data = x;
}

NumberStataExpr::StataExpr(signed double _data)
{
    Rcpp::NumericVector x(1);
    x[0] = _data;

    data = x;
}

NumberStataExpr::StataExpr(unsigned double _data)
{
    Rcpp::NumericVector x(1);
    x[0] = _data;

    data = x;
}

IdentStataExpr::IdentStataExpr(Rcpp::Symbol _data)
{
    data = _data;
}

IdentStataExpr::IdentStataExpr(std::string _data)
{
    data = Rcpp::Symbol(_data);
}

StringStataExpr::StringStataExpr(std::string _data)
{
    data = _data;
}

ModifierStataExpr::ModifierStataExpr(Rcpp::Symbol _data, StataExpr **_children)
{
    data = _data;
    children = _children;
}

ModifierStataExpr::ModifierStataExpr(std::string _data, StataExpr **_children)
{
    data = Rcpp::Symbol(_data);
    children = _children;
}

OptionStataExpr::OptionStataExpr(Rcpp::Symbol _data, StataExpr **_children)
{
    data = _data;
    children = _children;
}

OptionStataExpr::OptionStataExpr(std::string _data, StataExpr **_children)
{
    data = Rcpp::Symbol(_data);
    children = _children;
}

BranchStataExpr::BranchStataExpr(Rcpp::Symbol _data, StataExpr **_children)
{
    data = _data;
    children = _children;
}

BranchStataExpr::BranchStataExpr(std::string _data, StataExpr **_children)
{
    data = Rcpp::Symbol(_data);
    children = _children;
}

// The as_expr methods for conversion to R expressions
Rcpp::Language NumberStataExpr::as_expr() const
{
    return Rcpp::Language("c", data);
}

Rcpp::Language IdentStataExpr::as_expr() const
{
    return data; // Symbol is already a subclass of Language
}

Rcpp::Language StringStataExpr::as_expr() const
{
    return Rcpp::Language("c", data);
}

Rcpp::Language ModifierStataExpr::as_expr() const
{

}

Rcpp::Language OptionStataExpr::as_expr() const
{

}

Rcpp::Language BranchStataExpr::as_expr() const
{

}

