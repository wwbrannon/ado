#ifndef RSTATA_DRIVER_H
#define RSTATA_DRIVER_H

#include <memory>
#include <string>

#include "RStata.hpp"

void raise_condition(const std::string& msg, const std::string& type);

class RStataDriver
{
    public:
        RStataDriver(std::string text);
        virtual ~RStataDriver();

        BranchExprNode *ast;

        void scan_begin();
        void scan_end();

        int parse();
        
        void error(const yy::location& l, const std::string& m);
        void error(const std::string& m);

    private:
        std::string        text;
};

#endif /* RSTATA_DRIVER_H */

