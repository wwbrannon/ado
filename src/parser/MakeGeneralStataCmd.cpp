#include <Rcpp.h>
#include "RStata.hpp"

MakeGeneralStataCmd::MakeGeneralStataCmd(std::string Nverb)
{
    _verb = new IdentExprNode(Nverb);
    
    _weight = NULL;
    _varlist = NULL;
    _assign_stmt = NULL;
    _if_exp = NULL;
    _options = NULL;

    _has_range = 0;
    _range_lower = 0;
    _range_upper = 0;

    _using_filename = "";
}

MakeGeneralStataCmd::MakeGeneralStataCmd(IdentExprNode *Nverb)
{
    _verb = Nverb;
    
    _weight = NULL;
    _varlist = NULL;
    _assign_stmt = NULL;
    _if_exp = NULL;
    _options = NULL;

    _has_range = 0;
    _range_lower = 0;
    _range_upper = 0;

    _using_filename = "";
}

GeneralStataCmd *MakeGeneralStataCmd::create()
{
    GeneralStataCmd *cmd = new GeneralStataCmd(_verb, _weight, _using_filename,
                                               _has_range, _range_upper, _range_lower,
                                               _varlist, _assign_stmt, _if_exp, _options);

    return cmd;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::verb(IdentExprNode *Nverb)
{
    _verb = Nverb;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::verb(std::string Nverb)
{
    _verb = new IdentExprNode(Nverb);
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::varlist(BranchExprNode *Nvarlist)
{
    _varlist = Nvarlist;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::assign_stmt(BranchExprNode *Nassign_stmt)
{
    _assign_stmt = Nassign_stmt;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::if_exp(BranchExprNode *Nif_exp)
{
    _if_exp = Nif_exp;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::options(BranchExprNode *Noptions)
{
    _options = Noptions;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::weight(BranchExprNode *Nweight)
{
    _weight = Nweight;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::has_range(int Nhas_range)
{
    _has_range = Nhas_range;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::range_upper(int Nrange_upper)
{
    _range_upper = Nrange_upper;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::range_lower(int Nrange_lower)
{
    _range_lower = Nrange_lower;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::using_filename(std::string Nusing_filename)
{
    _using_filename = Nusing_filename;
    return *this;
}

