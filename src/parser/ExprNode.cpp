/* Methods for most of the derived classes of BranchExprNode */

#include <utility>
#include <Rcpp.h>
#include "RStata.hpp"

using namespace Rcpp;

// Constructors
NumberExprNode::NumberExprNode(std::string _data)
{
    data = Language("as.numeric", _data).eval(); // FIXME
}

IdentExprNode::IdentExprNode(std::string _data)
{
    data = _data;
}

StringExprNode::StringExprNode(std::string _data)
{
    data = _data;
}

DatetimeExprNode::DatetimeExprNode(std::string _date, std::string _time)
{
    if(_date.empty() && _time.empty())
        dt = R_NilValue;

    if(_date.empty() && !_time.empty())
        dt = Datetime(_time, "%H:%M:%OS");

    if(!_date.empty() && _time.empty())
        dt = Datetime(_date, "%d%b%Y");
    
    if(!_date.empty() && !_time.empty())
        dt = Datetime(_date + " " + _time, "%d%b%Y %H:%M:%OS");
}

DatetimeExprNode::DatetimeExprNode(std::string _dt)
{
    dt = Datetime(_dt, std::string("%d%b%Y %H:%M:%OS"));
}

BranchExprNode::BranchExprNode(std::string _type, std::string _data)
{
    type = _type;
    data = _data;
}

BranchExprNode::BranchExprNode()
{
    type = "";
    data = "";
}

void
BranchExprNode::setChildren(std::initializer_list<BranchExprNode *> list)
{
    children.clear();

    for(auto elem : list)
    {
        children.push_back(elem);
    }
}

void
BranchExprNode::setChildren(std::vector<BranchExprNode *> _children)
{
    children = _children;
}

void
BranchExprNode::appendChild(BranchExprNode *_child)
{
    children.push_back(_child);
}

// The methods for conversion to R expressions
NumericVector NumberExprNode::as_R_object() const
{
    return data;
}

Symbol IdentExprNode::as_R_object() const
{
    return Symbol(data);
}

String StringExprNode::as_R_object() const
{
    return data;
}

Datetime DatetimeExprNode::as_R_object() const
{
    return dt;
}

List BranchExprNode::as_R_object() const
{
    unsigned int x;
    List res;

    res["type"] = type;
    res["data"] = data;
    
    for(x = 0; x < children.size(); x++)
    {
        List y = children[x]->as_R_object();
        res.push_back(y);
    }

    return res;
}

