// Stata is a very unusual language, more like the Bourne shell than it is like C.
// A Stata script consists of one or more "commands" in sequence. Each command starts with
// a verb and then has various kinds of arguments and options after it.
// Syntax is not fully linear, so one command is one line. (But there's a /// syntax
// to continue a command across lines, and certain flow-control constructs like forval span
// more than one line as well.)

// The basic Stata command syntax is:
// [ (prefix [arguments])+:] command [varlist | var = exp] [if expression] [in range] [weight] [using filename] [, options]

#ifndef RSTATA_H
#define RSTATA_H

#include <Rcpp.h>

// Options as they occur after commands, prefix or otherwise
class StataOption
{
   

};

// Option lists
class OptionList
{
    public:
        OptionList(std::vector<StataOption> _options);
        Rcpp::Language as_list() const;
    
    private:
        std::vector<StataOption> options;
};

// abstract base class for Stata expressions
class BaseStataExpr
{
    public:
        // method that returns this BaseStataExpr as an R expression
        virtual Rcpp::Language as_expr() const = 0;
};

class NumberStataExpr: public BaseStataExpr
{
    public:
        NumberStataExpr(signed long int _data);
        NumberStataExpr(unsigned long int _data);
        NumberStataExpr(long double _data);
        
        virtual Rcpp::Language as_expr() const;

    private:
        Rcpp::NumericVector data; // a type-generic number already in R format
};

class IdentStataExpr: public BaseStataExpr
{
    public:
        IdentStataExpr(std::string _data);
        
        virtual Rcpp::Language as_expr() const;

    private:
        std::string data;
};

class StringStataExpr: public BaseStataExpr
{
    public:
        StringStataExpr(std::string _data);
        
        virtual Rcpp::Language as_expr() const;

    private:
        std::string data;
};

// all other expressions: assignment expressions, logical expressions,
// equality expressions, relational expressions, arithmetic expressions,
// unary expressions and function calls
class BranchStataExpr: public BaseStataExpr
{
    public:
        BranchStataExpr(std::string _data, std::vector<BaseStataExpr> _children);
        
        virtual Rcpp::Language as_expr() const;
    
    private:
        std::vector<BaseStataExpr> children;
        std::string data;
};

// We don't need to continue the parse tree all the way up to the level of a
// translation unit because the command syntax is so constrained. Breaking it
// out into BaseStataCmd and its derived classes at the top level makes it
// easier to write the R.

// the abstract base class for Stata commands
class BaseStataCmd
{
    public:
        std::string verb; // the command verb
        
        // method that returns this StataCmd as an R list
        virtual Rcpp::List as_list() const = 0;
};

class EmbeddedRCmd: public BaseStataCmd
{
    private:
        std::string text;

    public:
        virtual Rcpp::List as_list() const = 0;
        EmbeddedRCmd(std::string _text);
};

class GeneralStataCmd: public BaseStataCmd
{
    private:
        BaseStataExpr *varlist; // a varlist is a left-deep tree of IDENTs
        BaseStataExpr *assign_stmt; // "var = exp"
        BaseStataExpr *if_exp; // "if expression"
        BaseStataExpr *options; // ", options"
        
        int has_range;
        int range_lower; // the lower range limit
        int range_upper; // the upper range limit
        
        std::string weight; // "weight": the column name of the weight, or NULL
        std::string using_filename; // "using filename": the filename given after using, or NULL
    
    public:
        BaseStataCmd *PrefixCmd;
        virtual Rcpp::List as_list() const;

        GeneralStataCmd(std::string _verb,
                        std::string _weight, std::string _using_filename,
                        int _has_range, int _range_lower, int _range_upper,
                        BaseStataExpr *_varlist, BaseStataExpr *_options
                        BaseStataExpr *_assign_stmt, BaseStataExpr *_if_exp);
};

// positional-only parameters are garbage...
class MakeGeneralStataCmd
{
    public:    
        MakeGeneralStataCmd(std::string _verb);
        
        GeneralStataCmd create();

        MakeGeneralStataCmd& verb(std::string const& _verb);
        MakeGeneralStataCmd& varlist(BaseStataExpr *_varlist);
        MakeGeneralStataCmd& assign_stmt(BaseStataExpr *_assign_stmt);
        MakeGeneralStataCmd& if_exp(BaseStataExpr *_if_exp);
        MakeGeneralStataCmd& options(BaseStataExpr *_options);
        MakeGeneralStataCmd& has_range(int _has_range);
        MakeGeneralStataCmd& range_upper(int _range_upper);
        MakeGeneralStataCmd& range_lower(int _range_lower);
        MakeGeneralStataCmd& weight(std::string _weight);
        MakeGeneralStataCmd& using_filename(std::string _using_filename);
    
    private:
        std::string __verb;
        BaseStataExpr *__varlist;
        BaseStataExpr *__assign_stmt;
        BaseStataExpr *__if_exp;
        BaseStataExpr *__options;
        int __has_range;
        int __range_lower;
        int __range_upper;
        std::string __weight;
        std::string __using_filename;
};

#endif /* RSTATA_H */

