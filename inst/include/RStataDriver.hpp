#ifndef RSTATA_DRIVER_H
#define RSTATA_DRIVER_H

#include <string>
#include <map>

/* define the YY_DECL macro for flex, and declare it for bison */
#define YY_DECL yy::RStataParser::symbol_type yylex(RStataDriver& driver)
YY_DECL;

class RStataDriver
{
    public:
        rstata_driver();
        virtual ~rstata_driver();

        std::map<std::string, int> variables;

        int result;

        void scan_begin();
        void scan_end();

        int parse(const std::string& s);
        
        void error(const yy::location& l, const std::string& m);
        void error(const std::string& m);
};

#endif /* RSTATA_DRIVER_H */

