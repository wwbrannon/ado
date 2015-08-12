/* Methods for the StataOption class */

#include <Rcpp.h>
#include "rstata.hpp"

StataOption::StataOption(std::string _name, std::vector<std::string> _args)
{
    name = _name;
    args = _args;
}

Rcpp::Language as_list() const
{
    
}

