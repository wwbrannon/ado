/* Methods for the OptionList class */

#include <Rcpp.h>
#include "rstata.hpp"

OptionList::OptionList(std::vector<StataOption> _options)
{
    options = _options
}

// The as_list method for conversion to R expressions
Rcpp::List OptionList::as_list() const
{
    Rcpp::List res;

    for(x = 0; x < options.size(); x++)
        res.push_back(options[x]);
    
    return res;
}

