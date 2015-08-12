#include <Rcpp.h>
#include "rstata.hpp"
#include "ado.tab.hpp"
#include "lex.yy.hpp"

using namespace Rcpp;

// [[Rcpp::export]]
List do_stata_parse(std::string line)
{
    YY_BUFFER_STATE                    buf;
    std::unique_ptr<BaseStataCmd>      obj;
    List                               ret;
    
    // yyparse takes a C pointer to something
    std::vector<std::unique_ptr<BaseStataCmd>> *parsed = new std::vector<std::unique_ptr<BaseStataCmd>>();

    // handle some buffers and parse the input
    buf = yy_scan_string(line.c_str());
    if( yyparse(parsed) != 0 )
        return R_NilValue;
    yy_delete_buffer(buf);

    // now take the resulting std::vector and turn it into an R call object
    for(int x = 0; x < v->size(); x++)
    {
        obj = (*parsed)[x];

        // ask the BaseStataCmd object to give us its R form
        Language res = Language("as.call", obj->as_list());
        
        if(ret.length() == 0)
            ret.push_front(res);
        else
            ret = Language("list", ret, res).eval(); // append res to ret
    }

    return ret;
}

