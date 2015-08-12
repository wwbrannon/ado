/* Methods for the ImmediateStataCmd class */

#include <utility>
#include <Rcpp.h>
#include "rstata.hpp"

using namespace Rcpp;

ImmediateStataCmd::ImmediateStataCmd(std::vector<std::unique_ptr<BaseStataExpr>> _exprs)
{
    exprs = std::move(_exprs);
}

List ImmediateStataCmd::as_list() const
{
    unsigned int x;
    List res;

    res = List::create(_["func"]            = Symbol("dispatch.rstata.cmd"),
                       _["verb"]            = verb);

    for(x = 0; x < exprs.size(); x++)
    {
        Language y = exprs[x]->as_expr();
        res.push_back(y);
    }

    return res;
}

