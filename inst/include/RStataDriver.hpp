#ifndef RSTATA_DRIVER_H
#define RSTATA_DRIVER_H

#include <string>
#include "RStata.hpp"

class RStataDriver
{
    public:
        RStataDriver(std::string text);
        virtual ~RStataDriver();

        ExprNode *ast;
        void delete_ast();

        void scan_begin();
        void scan_end();

        int parse();
        
        void error(const yy::location& l, const std::string& m);
        void error(const std::string& m);

    private:
        std::string text;
};

#endif /* RSTATA_DRIVER_H */

