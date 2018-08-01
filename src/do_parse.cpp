#include <string>
#include <Rcpp.h>
#include "ado.tab.hpp"

#include "ParseDriver.hpp"

// for C++11 features
// [[Rcpp::plugins("cpp11")]]

// [[Rcpp::export]]
SEXP
do_parse_with_callbacks(std::string text, Rcpp::Function cmd_action,
                        Rcpp::Function macro_value_accessor,
                        Rcpp::Function log_command,
                        int debug_level=0, int echo=1)
{
  try
  {

    ParseDriver *driver = new ParseDriver(1, cmd_action, macro_value_accessor,
                                          log_command, text, debug_level, echo);

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
do_parse(std::string text, Rcpp::Function log_command, int debug_level=0)
{
  try
  {
    Rcpp::List res;
    ParseDriver *driver = new ParseDriver(text, log_command, debug_level);

    // parse the input
    if( driver->parse() != 0 || driver->error_seen != 0)
        return R_NilValue;

    // now take the resulting AST and recursively turn it into an R object
    res = driver->ast->as_R_object();
    
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
    ParseDriver *driver = new ParseDriver(text, DEBUG_NO_PARSE_ERROR);

    if(driver->parse() == 0 && driver->error_seen == 0)
        ret = 1;
    else
        ret = 0;
    
    delete driver;
  } catch(...)
  {
    ret = 0;
  }

  return ret;
}

