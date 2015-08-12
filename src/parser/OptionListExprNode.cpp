/* Methods for the OptionListExprNode class */

#include <Rcpp.h>
#include "RStata.hpp"

using namespace Rcpp;

OptionListExprNode::OptionListExprNode(std::vector<OptionExprNode> _options)
{
    options = _options;
}

// The method for conversion to R expressions
List OptionListExprNode::as_R_object() const
{
    unsigned int x;
    List res;

    for(x = 0; x < options.size(); x++)
    {
        List y = options[x].as_R_object();
        res.push_back(y);
    }
    
    return res;
}

