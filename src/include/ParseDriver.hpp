#ifndef ADO_DRIVER_H
#define ADO_DRIVER_H

#include <string>
#include <Rcpp.h>
#include "Ado.hpp"

// flags you can bitwise OR to enable debugging features
#define DEBUG_PARSE_TRACE       4
#define DEBUG_MATCH_CALL        8
#define DEBUG_VERBOSE_ERROR     16
#define DEBUG_NO_PARSE_ERROR    32

class ParseDriver
{
    public:
        // ctor for parse_accept
        ParseDriver(std::string text, int debug_level);

        // ctor for do_parse
        ParseDriver(std::string text, Rcpp::Function log_command,
                  int debug_level);

        // ctor for do_parse_with_callbacks
        ParseDriver(int callback, Rcpp::Function cmd_action,
                     Rcpp::Function macro_value_accessor,
                     Rcpp::Function log_command,
                     std::string text, int debug_level, int echo);

        ~ParseDriver();

        ExprNode *ast;

        int parse();

        int callbacks;
        void wrap_cmd_action(ExprNode *ast);
        Rcpp::Function cmd_action;
        Rcpp::Function macro_value_accessor;
        Rcpp::Function log_command;

        std::string get_macro_value(std::string name);

        // error-handling functions and state
        int error_seen;
        void error(const yy::location& l, const std::string& m);
        void error(const std::string& m);
        int debug_level;

        int echo;
        void push_echo_text(std::string echo_text);

    private:
        ParseDriver(const ParseDriver& that); // no copy ctor
        ParseDriver& operator=(ParseDriver const&); // no assignment

        std::string text;
        std::string echo_text_buffer;

        // See the comments in ado.fl for an explanation of this awful hack
        FILE *tmp;
};

#endif /* ADO_DRIVER_H */

