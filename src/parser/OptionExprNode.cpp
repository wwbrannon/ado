/* Methods for the OptionExprNode class */

#include <Rcpp.h>
#include "rstata.hpp"

using namespace Rcpp;

OptionExprNode::OptionExprNode(std::string _name, std::vector<std::string> _args)
{
    name = _name;
    args = _args;
}

List OptionExprNode::as_R_object() const
{
    unsigned int x;
    List res;

    res = List::create(_["name"] = name);
    for(x = 0; x < args.size(); x++)
        res.push_back(args[x]);

    return res;
}

