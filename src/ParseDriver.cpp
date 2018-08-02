#include <string>
#include <Rcpp.h>
#include "Ado.hpp"

// A lot of messy forward declarations of type names to make flex and
// bison play nicely together, and with this driver class
class ParseDriver;
typedef void* yyscan_t;
#include "ado.tab.hpp"
typedef yy::AdoParser::semantic_type YYSTYPE;
#include "lex.yy.hpp"
#include "ParseDriver.hpp"

ParseDriver::ParseDriver(std::string text, Rcpp::Environment context,
                         int debug_level, int echo)
    : text(text), context(context), debug_level(debug_level), echo(echo)
{
    error_seen = 0;
}

ParseDriver::~ParseDriver()
{
    // all the other members still get their destructors called
    if(ast != NULL)
        delete ast;
}

void
ParseDriver::set_ast(ExprNode *node)
{
    this->ast = node;
}

Rcpp::List
ParseDriver::get_ast()
{
    return(this->ast->as_R_object());
}

int
ParseDriver::parse()
{
    int res;
    FILE *tmp;
    yyscan_t yyscanner;

    // Initialize the reentrant scanner
    yylex_init(&yyscanner);

    if( !(tmp = tmpfile()) )
    {
        this->error("Cannot open temp file for writing");
        return 1; // failure
    }

    if(fputs( (this->text).c_str(), tmp)==0 && ferror(tmp))
    {
        this->error("Cannot write to temp file");
        return 1; // failure
    }
    rewind(tmp);

    // We should just be able to do this:
    //     yy_scan_string(text.c_str());
    // but there's a probable flex bug that overflows yytext on unput()
    // when input comes from yy_scan_string(). Instead, let's create a
    // tempfile, because that works correctly.
    yy_switch_to_buffer(yy_create_buffer(tmp, YY_BUF_SIZE, yyscanner),
                        yyscanner);

    yy::AdoParser parser(*this, yyscanner);

    if( (this->debug_level & DEBUG_PARSE_TRACE) != 0 )
        parser.set_debug_level(1);
    else
        parser.set_debug_level(0);

    res = parser.parse();

    // wrap up the scan
    yylex_destroy(yyscanner);
    fclose(tmp);

    return res;
}

void
ParseDriver::wrap_cmd_action(ExprNode *node)
{
    Rcpp::List ret;
    
    // don't do anything if a) we've been told not to, or
    // b) we couldn't parse the input correctly
    if( (this->debug_level & DEBUG_NO_CALLBACKS) != 0 )
        return;

    if(this->error_seen)
        return;

    if(this->echo)
    {
        std::string txt = trim(this->echo_text_buffer, std::string("\n"));
        txt = ". " + txt + std::string("\n");

        Rcpp::Function log_command = this->context["log_command"];
        log_command(txt);
        
        this->echo_text_buffer.clear();
    }
    
    Rcpp::Function cmd_action = this->context["cmd_action"];
    ret = cmd_action(node->as_R_object());

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
ParseDriver::get_macro_value(std::string name)
{
    Rcpp::Function macro_accessor = this->context["macro_accessor"];
    
    return Rcpp::as<std::string>(macro_accessor(name));
}

void
ParseDriver::push_echo_text(std::string echo_text)
{
    if(this->echo)
        this->echo_text_buffer += echo_text;
}

void
ParseDriver::error(const yy::location& l, const std::string& m)
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
ParseDriver::error(const std::string& m)
{
    if( (this->debug_level & DEBUG_NO_PARSE_ERROR) == 0 )
    {
        const std::string msg = std::string("Error: line unknown, column unknown: ") + m;

        Rcpp::Rcerr << msg << std::endl;
    }

    error_seen = 1;
}

using namespace Rcpp;
RCPP_MODULE(class_ParseDriver) {
    class_<ParseDriver>("ParseDriver")

    .constructor<std::string,Rcpp::Environment,int,int>()

    .field_readonly("error_seen", &ParseDriver::error_seen)
    .field_readonly("debug_level", &ParseDriver::debug_level)
    .field_readonly("echo", &ParseDriver::echo)

    .method("parse", &ParseDriver::parse)
    .method("get_ast", &ParseDriver::get_ast)
    ;
}

