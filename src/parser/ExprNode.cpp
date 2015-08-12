/* Methods for most of the derived classes of ExprNode */

#include <utility>
#include <Rcpp.h>
#include "RStata.hpp"

using namespace Rcpp;

ExprNode::ExprNode(std::string _type)
{
    type = _type; // all other members' default constructors make them empty
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
 * Recursively convert to an R data structure
 */
List
ExprNode::as_R_object() const
{
    List res, chld;
    
    CharacterVector node_data(data.size());
    CharacterVector node_data_names(data.size());
    
    std::map<std::string, std::string>::const_iterator it;
    unsigned int x;
    
    // include the node type
    res["type"] = type;
    
    // include the node data
    for(it = data.begin(); it != data.end(); it++)
    {
        node_data_names.push_back(it->first);
        node_data.push_back(it->second);
    }
    node_data.attr("names") = node_data_names;
    res["data"] = node_data;

    // include the children
    for(x = 0; x < children.size(); x++)
    {
        chld.push_back(children[x]->as_R_object());
    }
    chld.attr("names") = names;
    res["children"] = chld;

    return res;
}

