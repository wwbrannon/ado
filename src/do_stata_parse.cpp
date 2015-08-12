#include <Rcpp.h>
#include "rstata.h"
#include "ado.tab.hpp"
#include "lex.yy.hpp"

using namespace Rcpp;

// [[Rcpp::export]]
List do_stata_parse(std::string line)
{
    YY_BUFFER_STATE   buf;
    STATA_CMD_LIST_T  cmdlist;
    StataCmd          *cur, *next;
    List              ret;

    // handle some buffers and parse the input
    buf = yy_scan_string(line.c_str());
    if( yyparse(&cmdlist) != 0 )
        return R_NilValue;
    yy_delete_buffer(buf);

    // now take the resulting STATA_CMD_LIST_T and turn it into an R call object
    do {
        // ask the StataCmd object to give us its R form
        List res = (*cur).as_list();
        
        ret = Language("list", ret, res).eval(); // append res to ret
        
        if(next)
            cmdlist = cmdlist->next;
    } while(next);

    return ret;
}

