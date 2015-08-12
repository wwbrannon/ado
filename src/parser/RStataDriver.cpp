#include "RStataDriver.hpp"

void raise_condition(const std::string& msg, const std::string& type);

RStataDriver::RstataDriver()
{

}

RStataDriver::~RstataDriver()
{

}

int
RStataDriver::parse(const std::string& s)
{
    scan_begin();
    yy::RStataParser parser(*this);
    int res = parser.parse();
    scan_end();
    
    return res;
}

void
RStataDriver::error(const yy::location& l, const std::string& m)
{
    raise_condition(
}

void
RStataDriver::error(const std::string& m)
{

}

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

