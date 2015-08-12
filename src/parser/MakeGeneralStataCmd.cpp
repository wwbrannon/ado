#include <Rcpp.h>
#include "rstata.hpp"

MakeGeneralStataCmd::MakeGeneralStataCmd(std::string _verb)
{
    __verb = _verb;
    
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

GeneralStataCmd MakeGeneralStataCmd::create()
{
    GeneralStataCmd *cmd = new GeneralStataCmd(__verb, __weight, __using_filename,
                                               __has_range, __range_upper, __range_lower,
                                               __varlist, __assign_stmt, __if_exp, __options);

    return *cmd;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::verb(std::string const& _verb)
{
    __verb = _verb;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::varlist(BaseExprNode *_varlist)
{
    __varlist = _varlist;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::assign_stmt(BaseExprNode *_assign_stmt)
{
    __assign_stmt = _assign_stmt;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::if_exp(BaseExprNode *_if_exp)
{
    __if_exp = _if_exp;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::options(OptionListExprNode *_options)
{
    __options = _options;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::has_range(int _has_range)
{
    __has_range = _has_range;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::range_upper(int _range_upper)
{
    __range_upper = _range_upper;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::range_lower(int _range_lower)
{
    __range_lower = _range_lower;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::weight(std::string _weight)
{
    __weight = _weight;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::using_filename(std::string _using_filename)
{
    __using_filename = _using_filename;
    return *this;
}

