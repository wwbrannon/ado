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
    STATA_CMD_T       *cur, *next;
    List              ret;

    // handle some buffers and parse the input
    buf = yy_scan_string(line.c_str());
    
    if( yyparse(&cmdlist) != 0 )
        return R_NilValue;
    
    yy_delete_buffer(buf);

    // now take the resulting STATA_CMD_LIST_T and turn it into an R object
    do {
        char *verb, *weight, *using_filename;
        int range_lower, range_upper;
        modifiers, varlist, assign_stmt, if_exp, options; // have to find the right expression type
        List res;
       
        // book-keeping for walking the list of commands
        cur = cmdlist.current;
        next = cmdlist.next;

        // temp variables used to construct the R version of this object
        verb = cur->verb; // this will always be set
        
        if(cur->has_using)
            using_filename = cur->using_filename;
        else
            using_filename = R_NilValue;

        if(cur->has_weight)
            weight = cur->weight;
        else
            weight = R_NilValue;

        if(cur->has_range)
        {
            range_upper = cur->range_upper;
            range_lower = cur->range_lower;
        }
        else
        {
            range_upper = R_NilValue;
            range_lower = R_Nilvalue;
        }

        // and the expression types here

        res = List::create(_["verb"]            = verb,
                           _["modifiers"]       = modifiers,
                           _["varlist"]         = varlist,
                           _["assign_stmt"]     = assign_stmt,
                           _["if_exp"]          = if_exp,
                           _["range_lower"]     = range_lower,
                           _["range_upper"]     = range_upper,
                           _["weight"]          = weight,
                           _["using_filename"]  = using_filename,
                           _["options"]         = options)

        // append res to ret
        ret = Language("list", ret, res).eval();
        
        // advance cmdlist to the next element in the list of Stata commands
        if(next)
            cmdlist = cmdlist->next;
    } while(next);

    //all done! pass back the resulting list
    return ret;
}

