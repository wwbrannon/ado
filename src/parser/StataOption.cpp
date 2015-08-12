/* Methods for the StataOption class */

#include <Rcpp.h>
#include "rstata.hpp"

using namespace Rcpp;

StataOption::StataOption(std::string _name, std::vector<std::string> _args)
{
    name = _name;
    args = _args;
}

List StataOption::as_list() const
{
    unsigned int x;
    List res;

    res = List::create(_["name"] = name);
    for(x = 0; x < args.size(); x++)
        res.push_back(args[x]);

    return res;
}

