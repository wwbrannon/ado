#ifndef RSTATA_DRIVER_H
#define RSTATA_DRIVER_H

#include <string>
#include <Rcpp.h>
#include "RStata.hpp"

class RStataDriver
{
    public:
        RStataDriver(std::string text, int debug_level);
        RStataDriver(int callback, Rcpp::Function cmd_action,
                     Rcpp::Function macro_value_accessor,
                     std::string text, int debug_level);
        virtual ~RStataDriver();

        ExprNode *ast;
        void delete_ast();

        void scan_begin();
        void scan_end();

        int parse();

        int callbacks;
        void wrap_cmd_action(Rcpp::List ast);
        Rcpp::Function cmd_action;
        
        std::string get_macro_value(std::string name);
        std::string get_macro_value(const char *name);
        Rcpp::Function macro_value_accessor;

        // error-handling functions and state
        int error_seen;
        void error(const yy::location& l, const std::string& m);
        void error(const std::string& m);

        int debug_level;
        
    private:
        std::string text;
};

#endif /* RSTATA_DRIVER_H */

