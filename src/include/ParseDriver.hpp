#ifndef PARSE_DRIVER_H
#define PARSE_DRIVER_H

#include <string>
#include <Rcpp.h>
#include "Ado.hpp"

// flags you can bitwise OR to enable debugging features
#define DEBUG_PARSE_TRACE       4
#define DEBUG_MATCH_CALL        8
#define DEBUG_VERBOSE_ERROR     16
#define DEBUG_NO_PARSE_ERROR    32
#define DEBUG_NO_CALLBACKS      64

class ParseDriver
{
    public:
        ParseDriver(std::string text, Rcpp::Environment context,
                    int debug_level, int echo);
        ~ParseDriver();

        Rcpp::Environment context;

        int error_seen;
        int debug_level;
        int echo;

        int parse();

        void set_ast(ExprNode *node);
        Rcpp::List get_ast();

        void wrap_cmd_action(ExprNode *node);
        std::string get_macro_value(std::string name);
        void push_echo_text(std::string echo_text);

        void error(const yy::location& l, const std::string& m);
        void error(const std::string& m);

    private:
        ParseDriver(const ParseDriver& that); // no copy ctor
        ParseDriver& operator=(ParseDriver const&); // no assignment

        ExprNode *ast;
        std::string text;
        std::string echo_text_buffer;
};

#endif /* PARSE_DRIVER_H */

