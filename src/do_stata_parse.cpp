#include <string>
#include <Rcpp.h>
#include "ado.tab.hpp"
#include "RStataDriver.hpp"

// for C++11 features
// [[Rcpp::plugins("cpp11")]]

// [[Rcpp::export]]
Rcpp::List
do_stata_parse(std::string text, int debug_level=0)
{
    Rcpp::List res;
    RStataDriver *driver = new RStataDriver(text, debug_level);

    // parse the input
    if( driver->parse() != 0 || driver->error_seen != 0)
        return R_NilValue;

    // now take the resulting AST and recursively turn it into an R object
    res = driver->ast->as_R_object();
    driver->delete_ast();

    return res;
}

