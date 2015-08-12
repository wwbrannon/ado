/* Methods for the derived classes of BaseExprNode */

#include <utility>
#include <Rcpp.h>
#include "rstata.hpp"

using namespace Rcpp;

// Constructors
NumberExprNode::NumberExprNode(signed long int _data)
{
    NumericVector x(1);
    x[0] = _data;

    data = x;
}

NumberExprNode::NumberExprNode(unsigned long int _data)
{
    NumericVector x(1);
    x[0] = _data;

    data = x;
}

NumberExprNode::NumberExprNode(long double _data)
{
    NumericVector x(1);
    x[0] = _data;

    data = x;
}

IdentExprNode::IdentExprNode(std::string _data)
{
    data = _data;
}

StringExprNode::StringExprNode(std::string _data)
{
    data = _data;
}

BranchExprNode::BranchExprNode(std::string _data, BaseExprNode *_left, BaseExprNode *_right)
{
    data = _data;

    left = _left;
    right = _right;
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

List BranchExprNode::as_R_object() const
{
    List res;

    res.push_back(left->as_R_object());
    res.push_back(right->as_R_object());

    return res;
}

