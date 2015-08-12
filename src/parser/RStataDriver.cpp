#include <string>
#include <Rcpp.h>
#include "RStata.hpp"

class RStataDriver;
#include "ado.tab.hpp"

#include "RStataDriver.hpp"

void
raise_condition(const std::string& msg, const std::string& type)
{
  Rcpp::List cond;
  cond["message"] = msg;
  cond["call"] = R_NilValue;
  cond.attr("class") = Rcpp::CharacterVector::create(type, "condition");
  Rcpp::Function stopper("stop");
  stopper(cond);
}

RStataDriver::RStataDriver(std::string _text)
{
    text = _text;
}

RStataDriver::~RStataDriver() { }

int
RStataDriver::parse()
{
    int res;
    
    scan_begin();
    yy::RStataParser parser(*this);
    res = parser.parse();
    scan_end();
    
    return res;
}

void
RStataDriver::error(const yy::location& l, const std::string& m)
{
    raise_condition(std::string(": ") + std::string(m), "error");
}

void
RStataDriver::error(const std::string& m)
{
    raise_condition(std::string(m), "error");
}

