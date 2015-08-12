#include <string>
#include <Rcpp.h>
#include "RStataDriver.hpp"

// [[Rcpp::export]]
Rcpp::List do_stata_parse(std::string text)
{
    RStataDriver *driver = new RStataDriver(text);

    // parse the input
    if( driver->parse() != 0 )
        return R_NilValue;

    // now take the resulting AST and recursively turn it into an R object
    return driver->ast->as_R_object();
}

