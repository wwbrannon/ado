/* Methods for most of the derived classes of BranchExprNode */

#include <utility>
#include <Rcpp.h>
#include "RStata.hpp"

using namespace Rcpp;

// Constructors
NumberExprNode::NumberExprNode(std::string _data)
{
    data = _data;
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

void
BranchExprNode::setChildren(std::initializer_list<BranchExprNode *> list)
{
    std::vector<BranchExprNode *>().swap(children);

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
List NumberExprNode::as_R_object() const
{
    List res;
    
    res.push_back(data);

    return res;
}

List IdentExprNode::as_R_object() const
{
    List res;
    
    res.push_back(data);

    return res;
}

List StringExprNode::as_R_object() const
{
    List res;
    
    res.push_back(data);

    return res;
}

List DatetimeExprNode::as_R_object() const
{
    List res;

    res.push_back(dt);

    return res;
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

