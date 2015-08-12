#include <Rcpp.h>
#include "RStata.hpp"

MakeGeneralStataCmd::MakeGeneralStataCmd(std::string Nverb)
{
    _verb = new IdentExprNode(Nverb);
    
    _weight = NULL;
    _varlist = NULL;
    _assign_stmt = NULL;
    _if_clause = NULL;
    _in_clause = NULL;
    _options = NULL;
    _using_clause = NULL;
}

MakeGeneralStataCmd::MakeGeneralStataCmd(IdentExprNode *Nverb)
{
    _verb = Nverb;
    
    _weight = NULL;
    _varlist = NULL;
    _assign_stmt = NULL;
    _if_clause = NULL;
    _in_clause = NULL;
    _options = NULL;
    _using_clause = NULL;
}

GeneralStataCmd *MakeGeneralStataCmd::create()
{
    GeneralStataCmd *cmd = new GeneralStataCmd(_verb, _weight, _using_clause, _varlist,
                                               _assign_stmt, _if_clause, _in_clause, _options);

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

MakeGeneralStataCmd& MakeGeneralStataCmd::if_clause(BranchExprNode *Nif_clause)
{
    _if_clause = Nif_clause;
    return *this;
}

MakeGeneralStataCmd& MakeGeneralStataCmd::in_clause(BranchExprNode *Nin_clause)
{
    _in_clause = Nin_clause;
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

MakeGeneralStataCmd& MakeGeneralStataCmd::using_clause(BranchExprNode *Nusing_clause)
{
    _using_clause = Nusing_clause;
    return *this;
}

