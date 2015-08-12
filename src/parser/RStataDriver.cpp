#include <cstdio>
#include <string>
#include <Rcpp.h>
#include "RStata.hpp"

// A lot of messy forward declarations of type names to make flex and
// bison play nicely together, and with this driver class
class RStataDriver;
typedef void* yyscan_t;

#include "ado.tab.hpp"
typedef yy::RStataParser::semantic_type YYSTYPE;

#include "lex.yy.hpp"

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
                           std::string _text, int _debug_level, int _echo)
            : cmd_action(Rcpp::Function("identity")),
              macro_value_accessor(Rcpp::Function("identity"))
{
    text = _text;
    
    callbacks = _callbacks;
    cmd_action = _cmd_action;
    macro_value_accessor = _macro_value_accessor;

    debug_level = _debug_level;
    echo = _echo;
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
    // Initialize the reentrant scanner
    yyscan_t yyscanner;
    yylex_init(&yyscanner);

    if( !(this->tmp = tmpfile()) )
    {
        this->error("Cannot open temp file for writing");
        return 1; // failure
    }
    
    if(fputs( (this->text).c_str(), this->tmp)==0 && ferror(this->tmp))
    {
        this->error("Cannot write to temp file");
        return 1; // failure
    }
    rewind(this->tmp);
    
    // We should just be able to do this:
    //     yy_scan_string(text.c_str());
    // but there's a probable flex bug that overflows yytext on unput()
    // when input comes from yy_scan_string(). Instead, let's create a
    // tempfile, because that works correctly.
    yy_switch_to_buffer(yy_create_buffer(this->tmp, YY_BUF_SIZE, yyscanner), yyscanner);

    int res;

    yy::RStataParser parser(*this, yyscanner);
    
    if( (this->debug_level & DEBUG_PARSE_TRACE) != 0 )
        parser.set_debug_level(1);
    else
        parser.set_debug_level(0);
    
    res = parser.parse();
    
    // wrap up the scan
    yylex_destroy(yyscanner);
    fclose(this->tmp);

    return res;
}

void
RStataDriver::wrap_cmd_action(Rcpp::List ast)
{
  Rcpp::List ret = cmd_action(ast, this->debug_level);
  
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
    if( (this->debug_level & DEBUG_NO_PARSE_ERROR) == 0 )
    {
        const std::string msg = "Error: line " + std::to_string(l.begin.line) +
              ", column " + std::to_string(l.begin.column) + ": " + m;
        
        Rcpp::Rcerr << msg << std::endl;
    }
    error_seen = 1;
}

void
RStataDriver::error(const std::string& m)
{
    if( (this->debug_level & DEBUG_NO_PARSE_ERROR) == 0 )
    {
        const std::string msg = "Error: line unknown, column unknown: " + m;
    
        Rcpp::Rcerr << msg << std::endl;
    }

    error_seen = 1;
}

