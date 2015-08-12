/* Methods for the StataOption class */

#include <Rcpp.h>
#include "rstata.hpp"

StataOption::StataOption(std::string _name, std::vector<std::string> _args)
{
    name = _name;
    args = _args;
}

Rcpp::List as_list() const
{
    Rcpp::List res;

    res = List::create(_["name"] = name);
    for(x = 0; x < args.size(); x++)
        res.push_back(args[x]);

    return res;
}

