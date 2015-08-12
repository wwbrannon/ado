#include <Rcpp.h>
#include "RStata.hpp"

using namespace Rcpp;

EmbeddedRCmd::EmbeddedRCmd(std::string _text)
            : GeneralStataCmd("embedded_r")
{
    text = _text;
}

List EmbeddedRCmd::as_R_object() const
{
    List res;
   
    res = List::create(_["func"]            = Symbol("dispatch.rstata.cmd"),
                       _["verb"]            = verb->as_R_object(),
                       _["text"]            = text);
    
    return res;
}

