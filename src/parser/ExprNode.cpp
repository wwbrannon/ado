/* Methods for most of the derived classes of ExprNode */

#include <cstdio>
#include <Rcpp.h>
#include "RStata.hpp"

ExprNode::ExprNode(std::string _type)
{
    types.clear();
    
    types.push_back("rstata_ast_node");
    types.push_back(_type);
}



ExprNode::ExprNode(std::initializer_list<std::string> _types)
{
    types.clear();

    types.push_back("rstata_ast_node");
    for(auto elem : _types)
    {
        types.push_back(elem);
    }
}



ExprNode::~ExprNode()
{
    for(auto elem : children)
    {
        delete elem;
    }
}



/*
 * Adding data
 */
void
ExprNode::addData(std::string _name, std::string _value)
{
    data[_name] = _value;
}



/*
 * Adding children
 */
void
ExprNode::appendChild(std::string _name, ExprNode *_child)
{
    names.push_back(_name);
    children.push_back(_child);
}

void
ExprNode::appendChild(ExprNode *_child)
{
    children.push_back(_child);
    names.push_back(std::string(""));
}

void
ExprNode::setChildren(std::initializer_list<ExprNode *> _children)
{
    children.clear();
    names.clear();

    for(auto elem : _children)
    {
        children.push_back(elem);
        names.push_back(std::string(""));
    }
}

void
ExprNode::setChildren(std::vector<std::string> _names, std::vector<ExprNode *> _children)
{
    names = _names;
    children = _children;
}



/*
 * Counts of members
 */
size_t
ExprNode::nChildren()
{
    return children.size();
}

size_t
ExprNode::nData()
{
    return data.size();
}



/*
 * Recursively convert to an R data structure
 */
Rcpp::List
ExprNode::as_R_object() const
{
    Rcpp::List res, chld;
    
    Rcpp::CharacterVector node_data;
    Rcpp::CharacterVector node_data_names;
    Rcpp::CharacterVector classes;
    
    std::map<std::string, std::string>::const_iterator it;
    
    // include the node data
    for(it = data.begin(); it != data.end(); ++it)
    {
        node_data_names.push_back(it->first);
        node_data.push_back(it->second);
    }
    node_data.attr("names") = node_data_names;
    res["data"] = node_data;

    // include the children
    for(auto elem : children)
    {
        chld.push_back(elem->as_R_object());
    }
    chld.attr("names") = names;
    res["children"] = chld;

    // set classes for S3 method dispatch
    res.attr("class") = types;

    return res;
}

