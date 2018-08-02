#include <string>
#include <Rcpp.h>

#include "Ado.hpp"
#include "ado.tab.hpp"
#include "ParseDriver.hpp"

// for C++11 features
// [[Rcpp::plugins("cpp11")]]

// [[Rcpp::export]]
SEXP
do_parse_with_callbacks(std::string text, Rcpp::Environment context,
                        int debug_level=0, int echo=1)
{
    try
    {
        ParseDriver *driver = new ParseDriver(text, context, debug_level, echo);
        driver->parse();
        
        delete driver;
    } catch(std::exception const & e)
    {
        forward_exception_to_r(e);
    } catch(...)
    {
        ::Rf_error( "C++ exception (unknown reason)" );
    }

    return R_NilValue;
}

// [[Rcpp::export]]
Rcpp::List
do_parse(std::string text)
{
    try
    {
        Rcpp::List res;

        // it doesn't matter which env we look for callbacks in, because they
        // won't be used and the lookup will never happen
        Rcpp::Environment context = Rcpp::Environment::global_env();
        int debug_level = DEBUG_NO_PARSE_ERROR | DEBUG_NO_CALLBACKS;
        int echo = 0;
        
        ParseDriver *driver = new ParseDriver(text, context, debug_level, echo);

        if( driver->parse() != 0 || driver->error_seen != 0)
            return R_NilValue;
        res = driver->get_ast();
        
        delete driver;
        return res;
    } catch(std::exception const & e)
    {
        forward_exception_to_r(e);
    } catch(...)
    {
        ::Rf_error( "C++ exception (unknown reason)" );
    }

    return R_NilValue;
}

// [[Rcpp::export]]
int
parse_accept(std::string text)
{
    int ret;
  
    try
    {
        Rcpp::Environment context = Rcpp::Environment::global_env();
        int debug_level = DEBUG_NO_PARSE_ERROR | DEBUG_NO_CALLBACKS;
        int echo = 0;
        
        ParseDriver *driver = new ParseDriver(text, context, debug_level, echo);
    
        if(driver->parse() == 0 && driver->error_seen == 0)
            ret = 1;
        else
            ret = 0;
        
        delete driver;
    } catch(...)
    {
        ret = 0;
        throw;
    }
  
    return ret;
}

