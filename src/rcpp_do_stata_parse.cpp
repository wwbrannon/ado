#include <Rcpp.h>
#include "rstata.h"
#include "y.tab.h"

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
List rcpp_do_stata_parse(String line)
{
    // handle some buffers and parse the input
    YY_BUFFER_STATE temp = YY_CURRENT_BUFFER;
    yy_scan_string(line.c_str());
    
    if( !yyparse() )
    {
        raise_condition("syntax error", "error")
    }
    
    yy_delete_buffer(YY_CURRENT_BUFFER);
    yy_switch_to_buffer(temp);

    // now take the resulting STATA_CMD_T** and turn it into an R object

    //all done! pass back the resulting list
    List ret = List::create();
    return ret;
}

