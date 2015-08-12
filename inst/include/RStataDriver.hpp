#ifndef RSTATA_DRIVER_H
#define RSTATA_DRIVER_H

#include <memory>
#include <string>

#include "RStata.hpp"

// forward-declare this to break a circular dependency
typedef struct yy_buffer_state *YY_BUFFER_STATE;

// define the YY_DECL macro for flex
#define YY_DECL yy::RStataParser::symbol_type yylex(RStataDriver& driver)
YY_DECL;

void raise_condition(const std::string& msg, const std::string& type);

class RStataDriver
{
    public:
        RStataDriver(std::string text);
        virtual ~RStataDriver();

        BaseExprNode *ast;

        void scan_begin();
        void scan_end();

        int parse();
        
        void error(const yy::location& l, const std::string& m);
        void error(const std::string& m);

    private:
        std::string        text;
        YY_BUFFER_STATE    buf;
};

#endif /* RSTATA_DRIVER_H */

