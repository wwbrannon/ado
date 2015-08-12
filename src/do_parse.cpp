#include <string>
#include <Rcpp.h>
#include "ado.tab.hpp"

#include "RStataDriver.hpp"
#include "RStataExceptions.hpp"

// for C++11 features
// [[Rcpp::plugins("cpp11")]]

// [[Rcpp::export]]
SEXP
do_parse_with_callbacks(std::string text, Rcpp::Function cmd_action,
                        Rcpp::Function macro_value_accessor, int debug_level=0)
{
  try
  {
    
    RStataDriver *driver = new RStataDriver(1, cmd_action, macro_value_accessor,
                                            text, debug_level);

    driver->parse();
    
    driver->delete_ast();
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
do_parse(std::string text, int debug_level=0)
{
  try
  {
    Rcpp::List res;
    RStataDriver *driver = new RStataDriver(text, debug_level);

    // parse the input
    if( driver->parse() != 0 || driver->error_seen != 0)
        return R_NilValue;

    // now take the resulting AST and recursively turn it into an R object
    res = driver->ast->as_R_object();
    
    driver->delete_ast();
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
parse_accept(std::string text, int debug_level=0)
{
  int ret;
  
  try
  {
    RStataDriver *driver = new RStataDriver(text, debug_level);
    
    if(driver->parse() == 0 && driver->error_seen == 0)
        ret = 1;
    else
        ret = 0;

    driver->delete_ast();
    delete driver;
  } catch(...)
  {
    ret = 0;
  }

  return ret;
}

