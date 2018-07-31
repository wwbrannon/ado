#include <cstdio>
#include <string>
#include <Rcpp.h>
#include "Ado.hpp"
#include "utils.hpp"

// A lot of messy forward declarations of type names to make flex and
// bison play nicely together, and with this driver class
class AdoDriver;
typedef void* yyscan_t;

#include "ado.tab.hpp"
typedef yy::AdoParser::semantic_type YYSTYPE;

#include "lex.yy.hpp"

#include "AdoDriver.hpp"
#include "AdoExceptions.hpp"

// ctors
AdoDriver::AdoDriver(std::string _text, int _debug_level)
         : cmd_action(Rcpp::Function("identity")),
           macro_value_accessor(Rcpp::Function("identity")),
           log_command(Rcpp::Function("identity"))
{
    text = _text;
    ast = (ExprNode *) NULL;

    callbacks = 0;

    debug_level = _debug_level;
    error_seen = 0;
    echo = 0;
}

AdoDriver::AdoDriver(std::string _text, Rcpp::Function _log_command,
                     int _debug_level)
         : cmd_action(Rcpp::Function("identity")),
           macro_value_accessor(Rcpp::Function("identity")),
           log_command(Rcpp::Function("identity"))
{
    text = _text;

    callbacks = 0; // now a little misleading - doesn't include log_command
    log_command = _log_command;

    debug_level = _debug_level;
    error_seen = 0;
    echo = 0;
}

AdoDriver::AdoDriver(int _callbacks, Rcpp::Function _cmd_action,
                        Rcpp::Function _macro_value_accessor,
                        Rcpp::Function _log_command,
                        std::string _text, int _debug_level, int _echo)
         : cmd_action(Rcpp::Function("identity")),
           macro_value_accessor(Rcpp::Function("identity")),
           log_command(Rcpp::Function("identity"))
{
    text = _text;

    ast = (ExprNode *) NULL;

    callbacks = _callbacks;
    cmd_action = _cmd_action;
    macro_value_accessor = _macro_value_accessor;
    log_command = _log_command;

    debug_level = _debug_level;
    echo = _echo;
    error_seen = 0;
}

// dtor
AdoDriver::~AdoDriver()
{
    if(ast != NULL)
        delete ast; // all the other members still get their destructors called
}

int
AdoDriver::parse()
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

    yy::AdoParser parser(*this, yyscanner);

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
AdoDriver::wrap_cmd_action(Rcpp::List ast)
{
  this->write_echo_text();

  Rcpp::List ret = cmd_action(ast);

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

  if(status == 4)
    throw ContinueException(msg);

  if(status == 5)
    throw BreakException(msg);
}

std::string
AdoDriver::get_macro_value(std::string name)
{
    std::string str = Rcpp::as<std::string>(macro_value_accessor(name));

    return str;
}

std::string
AdoDriver::get_macro_value(const char *name)
{
    std::string s = std::string(name);
    return Rcpp::as<std::string>(macro_value_accessor(s));
}

void
AdoDriver::push_echo_text(std::string echo_text)
{
    if(this->echo)
    {
       this->echo_text_buffer += echo_text;
    }

    return;
}

void
AdoDriver::write_echo_text()
{
    if(this->echo)
    {
        std::string txt = trim(this->echo_text_buffer, std::string("\n"));
        txt = ". " + txt + std::string("\n");

        log_command(txt);
        this->echo_text_buffer.clear();
    }

    return;
}

void
AdoDriver::error(const yy::location& l, const std::string& m)
{
    if( (this->debug_level & DEBUG_NO_PARSE_ERROR) == 0 )
    {
        const std::string msg = std::string("Error: line ") + std::to_string(l.begin.line) +
                                std::string(", column ") + std::to_string(l.begin.column) +
                                std::string(": ") + m;

        Rcpp::Rcerr << msg << std::endl;
    }
    error_seen = 1;
}

void
AdoDriver::error(const std::string& m)
{
    if( (this->debug_level & DEBUG_NO_PARSE_ERROR) == 0 )
    {
        const std::string msg = std::string("Error: line unknown, column unknown: ") + m;

        Rcpp::Rcerr << msg << std::endl;
    }

    error_seen = 1;
}

