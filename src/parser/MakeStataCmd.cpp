#include <Rcpp.h>
#include "rstata.hpp"

MakeStataCmd::MakeStataCmd(std::string _verb)
{
    __verb = _verb;
    
    __modifiers = NULL;
    __varlist = NULL;
    __assign_stmt = NULL;
    __if_exp = NULL;
    __options = NULL;

    __has_range = 0;
    __range_lower = 0;
    __range_upper = 0;

    __weight = "";
    __using_filename = "";
}

StataCmd MakeStataCmd::create()
{
    StataCmd *cmd = new StataCmd(__verb, __weight, __using_filename,
                             __has_range, __range_upper, __range_lower,
                             __modifiers, __varlist, __assign_stmt,
                             __if_exp, __options);

    return *cmd;
}

MakeStataCmd& MakeStataCmd::verb(std::string const& _verb)
{
    __verb = _verb;
    return *this;
}

MakeStataCmd& MakeStataCmd::modifiers(BaseStataExpr *_modifiers)
{
    __modifiers = _modifiers;
    return *this;
}

MakeStataCmd& MakeStataCmd::varlist(BaseStataExpr *_varlist)
{
    __varlist = _varlist;
    return *this;
}

MakeStataCmd& MakeStataCmd::assign_stmt(BaseStataExpr *_assign_stmt)
{
    __assign_stmt = _assign_stmt;
    return *this;
}

MakeStataCmd& MakeStataCmd::if_exp(BaseStataExpr *_if_exp)
{
    __if_exp = _if_exp;
    return *this;
}

MakeStataCmd& MakeStataCmd::options(BaseStataExpr *_options)
{
    __options = _options;
    return *this;
}

MakeStataCmd& MakeStataCmd::has_range(int _has_range)
{
    __has_range = _has_range;
    return *this;
}

MakeStataCmd& MakeStataCmd::range_upper(int _range_upper)
{
    __range_upper = _range_upper;
    return *this;
}

MakeStataCmd& MakeStataCmd::range_lower(int _range_lower)
{
    __range_lower = _range_lower;
    return *this;
}

MakeStataCmd& MakeStataCmd::weight(std::string _weight)
{
    __weight = _weight;
    return *this;
}

MakeStataCmd& MakeStataCmd::using_filename(std::string _using_filename)
{
    __using_filename = _using_filename;
    return *this;
}

