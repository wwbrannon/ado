#include <Rcpp.h>
#include "rstata.h"
#include "ado.tab.hpp"
#include "lex.yy.hpp"

using namespace Rcpp;

void raise_condition(const std::string& msg,
                     const std::string& type)
{
  List cond;
  cond["message"] = msg;
  cond["call"] = R_NilValue;
  cond.attr("class") = CharacterVector::create(type, "condition");
  Function stopper("stop");
  stopper(cond);
}

// [[Rcpp::export]]
List rcpp_do_stata_parse(std::string line)
{
    YY_BUFFER_STATE buf;
    
    // handle some buffers and parse the input
    buf = yy_scan_string(line.c_str());
    
    if( !yyparse() )
    {
        raise_condition("syntax error", "error");
    }
    
    yy_delete_buffer(buf);

    // now take the resulting STATA_CMD_T** and turn it into an R object

    //all done! pass back the resulting list
    List ret = List::create();
    return ret;
}

