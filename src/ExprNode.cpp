#include <Rcpp.h>
#include "Ado.hpp"

ExprNode::ExprNode()
{
    dummy = true;
}

ExprNode::ExprNode(std::string _type)
{
    dummy = false;

    types.clear();
    types.push_back("ado_ast_node");
    types.push_back(_type);
}

ExprNode::ExprNode(std::initializer_list<std::string> _types)
{
    dummy = false;

    types.clear();

    types.push_back("ado_ast_node");
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
ExprNode::prependChild(std::string _name, ExprNode *_child)
{
    names.insert(names.begin(), _name);
    children.insert(children.begin(), _child);
}

void
ExprNode::prependChild(ExprNode *_child)
{
    children.insert(children.begin(), _child);
    names.insert(names.begin(), std::string(""));
}

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
ExprNode::setChildren(std::vector<ExprNode *> _children)
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
    if(_names.size() != _children.size())
        throw std::invalid_argument("Need same number of names as children");

    children.clear();
    names.clear();

    for(auto elem : _children)
        children.push_back(elem);

    for(auto elem : _names)
        names.push_back(elem);
}

/*
 * Accessor methods
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

bool
ExprNode::isDummy()
{
    return dummy;
}

std::vector<ExprNode*>
ExprNode::getChildren()
{
    return(children);
}

std::vector<std::string>
ExprNode::getChildrenNames()
{
    return(names);
}

std::map<std::string, std::string>
ExprNode::getData()
{
    return(data);
}

ExprNode *
ExprNode::pop_at_index(unsigned int index)
{
    ExprNode *ret;

    if(index >= children.size())
    {
        ret = NULL;
    }
    else
    {
        ret = children[index];

        children.erase(children.begin() + index);
        names.erase(names.begin() + index);
    }

    return ret;
}

/*
 * Recursively convert to an R data structure
 */
Rcpp::List
ExprNode::as_R_object() const
{
    Rcpp::List res, chld;
    Rcpp::CharacterVector children_names;

    Rcpp::CharacterVector node_data;
    Rcpp::CharacterVector node_data_names;
    Rcpp::CharacterVector classes;

    std::map<std::string, std::string>::const_iterator it;

    unsigned int i;

    if(dummy)
        return R_NilValue;

    // include the children
    for(i =0; i < children.size(); i++)
    {
        if(children[i]->isDummy())
            continue;
        else
        {
            chld.push_back(children[i]->as_R_object());
            children_names.push_back(names[i]);
        }
    }
    chld.attr("names") = children_names;
    res["children"] = chld;

    // include the node data
    for(it = data.begin(); it != data.end(); ++it)
    {
        node_data_names.push_back(it->first);
        node_data.push_back(it->second);
    }
    node_data.attr("names") = node_data_names;
    res["data"] = node_data;

    // set classes for S3 method dispatch
    res.attr("class") = types;

    return res;
}

