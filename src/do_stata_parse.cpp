#include <memory>
#include <Rcpp.h>
#include "rstata.hpp"
#include "ado.tab.hpp"
#include "lex.yy.hpp"

using namespace Rcpp;

// [[Rcpp::export]]
List do_stata_parse(std::string line)
{
    YY_BUFFER_STATE buf;
    
    // yyparse takes a C pointer to something - no use in std::unique_ptr
    std::unique_ptr<BaseExprNode> **parsed;

    // handle some buffers and parse the input
    buf = yy_scan_string(line.c_str());
    if( yyparse(parsed) != 0 )
        return R_NilValue;
    yy_delete_buffer(buf);

    // now take the resulting AST and recursively turn it into an R object
    return (*parsed)->as_R_object();
}

