#include <Rcpp.h>
#include "rstata.hpp"
#include "ado.tab.hpp"
#include "lex.yy.hpp"

using namespace Rcpp;

// [[Rcpp::export]]
List do_stata_parse(std::string line)
{
    YY_BUFFER_STATE   buf;
    StataCmd          *obj;
    List              ret;
    
    STATA_CMD_LIST_T  start = { NULL, NULL };
    STATA_CMD_LIST_T  *parsed = &start;

    // handle some buffers and parse the input
    buf = yy_scan_string(line.c_str());
    if( yyparse(parsed) != 0 )
        return R_NilValue;
    yy_delete_buffer(buf);

    // now take the resulting STATA_CMD_LIST_T and turn it into an R call object
    while(true)
    {
        obj = parsed->current;

        // ask the StataCmd object to give us its R form
        Language res = Language("as.call", obj->as_list());
        
        if(ret.length() == 0)
            ret.push_front(res);
        else
            ret = Language("list", ret, res).eval(); // append res to ret
        
        if(parsed->next != NULL)
            parsed = parsed->next;
        else
            break;
    }

    return ret;
}

