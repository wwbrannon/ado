#include <string>
#include <Rcpp.h>
#include "RStata.hpp"

class RStataDriver;
#include "ado.tab.hpp"

#include "RStataDriver.hpp"
#include "RStataExceptions.hpp"

// ctors
RStataDriver::RStataDriver(std::string _text, int _debug_level)
            : cmd_action(Rcpp::Function("identity")),
              macro_value_accessor(Rcpp::Function("identity"))
{
    text = _text;

    callbacks = 0;

    debug_level = _debug_level;
    error_seen = 0;
}

RStataDriver::RStataDriver(int _callbacks, Rcpp::Function _cmd_action,
                           Rcpp::Function _macro_value_accessor,
                           std::string _text, int _debug_level)
            : cmd_action(Rcpp::Function("identity")),
              macro_value_accessor(Rcpp::Function("identity")) // FIXME
{
    text = _text;
    
    callbacks = _callbacks;
    cmd_action = _cmd_action;
    macro_value_accessor = _macro_value_accessor;

    debug_level = _debug_level;
    error_seen = 0;
}

// dtor
RStataDriver::~RStataDriver()
{
    delete ast; // all the other members still get their destructors called
}

int
RStataDriver::parse()
{
    if(scan_begin())
    {
        int res;
    
        yy::RStataParser parser(*this);
        parser.set_debug_level(debug_level);
        
        res = parser.parse();
        
        scan_end();
    
        return res;
    } else
    {
        return 1; // failure on a low-level I/O error
    }
}

void
RStataDriver::wrap_cmd_action(Rcpp::List ast)
{
  Rcpp::List ret = cmd_action(ast, debug_level);
  
  int status = Rcpp::as<int>(ret[0]);
  std::string msg = Rcpp::as<std::string>(ret[1]);

  // success
  if(status == 0)
    return;
  
  // an error in the semantic analyzer or code generator
  if(status == 1)
    throw BadCommandException(msg);

  // a runtime error in evaluation or printing
  if(status == 2)
    throw EvalErrorException(msg);

  if(status == 3)
    throw ExitRequestedException(msg);
}

std::string
RStataDriver::get_macro_value(std::string name)
{
    std::string str = Rcpp::as<std::string>(macro_value_accessor(name));

    return str;
}

std::string
RStataDriver::get_macro_value(const char *name)
{
    std::string s = std::string(name);
    return Rcpp::as<std::string>(macro_value_accessor(s));
}

void
RStataDriver::error(const yy::location& l, const std::string& m)
{
    const std::string msg = "Error: line " + std::to_string(l.begin.line) +
          ", column " + std::to_string(l.begin.column) + ": " + m;
    
    Rcpp::Rcerr << msg << std::endl;

    error_seen = 1;
}

void
RStataDriver::error(const std::string& m)
{
    const std::string msg = "Error: line unknown, column unknown: " + m;
    
    Rcpp::Rcerr << msg << std::endl;

    error_seen = 1;
}

