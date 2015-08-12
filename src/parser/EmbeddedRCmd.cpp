#include <Rcpp.h>
#include "RStata.hpp"

using namespace Rcpp;

EmbeddedRCmd::EmbeddedRCmd(std::string _text)
            : GeneralStataCmd(_text)
{
    verb = "embedded_r";
    text = _text;
}

List EmbeddedRCmd::as_R_object() const
{
    List res;
   
    res = List::create(_["func"]            = Symbol("dispatch.rstata.cmd"),
                       _["verb"]            = verb,
                       _["text"]            = text);
    
    return res;
}

