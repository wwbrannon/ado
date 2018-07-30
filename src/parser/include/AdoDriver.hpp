#ifndef ADO_DRIVER_H
#define ADO_DRIVER_H

#include <cstdio>
#include <string>
#include <Rcpp.h>
#include "Ado.hpp"

// flags you can bitwise OR to enable debugging features
#define DEBUG_PARSE_TRACE       4
#define DEBUG_MATCH_CALL        8
#define DEBUG_VERBOSE_ERROR     16
#define DEBUG_NO_PARSE_ERROR    32

class AdoDriver
{
    public:
        // ctor for parse_accept
        AdoDriver(std::string text, int debug_level);

        // ctor for do_parse
        AdoDriver(std::string text, Rcpp::Function log_command,
                  int debug_level);

        // ctor for do_parse_with_callbacks
        AdoDriver(int callback, Rcpp::Function cmd_action,
                     Rcpp::Function macro_value_accessor,
                     Rcpp::Function log_command,
                     std::string text, int debug_level, int echo);

        ~AdoDriver();

        ExprNode *ast;

        int parse();

        int callbacks;
        void wrap_cmd_action(Rcpp::List ast);
        Rcpp::Function cmd_action;
        Rcpp::Function macro_value_accessor;
        Rcpp::Function log_command;

        std::string get_macro_value(std::string name);
        std::string get_macro_value(const char *name);

        // error-handling functions and state
        int error_seen;
        void error(const yy::location& l, const std::string& m);
        void error(const std::string& m);
        int debug_level;

        // state and functions for echoing read text
        int echo;
        void push_echo_text(std::string echo_text);
        void write_echo_text();

    private:
        AdoDriver(const AdoDriver& that); // no copy ctor
        AdoDriver& operator=(AdoDriver const&); // no assignment

        std::string text;
        std::string echo_text_buffer;

        // See the comments in ado.fl for an explanation of this awful hack
        FILE *tmp;
};

#endif /* ADO_DRIVER_H */

