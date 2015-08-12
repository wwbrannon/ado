// Stata is a very unusual language, more like the Bourne shell than it is like C.
// A Stata script consists of one or more "commands" in sequence. Each command starts with
// a verb and then has various kinds of arguments and options after it.
// Syntax is not fully linear, so one command is one line. (But there's a /// syntax
// to continue a command across lines, and certain flow-control constructs like forval span
// more than one line as well.)

// The basic Stata command syntax is:
// [ (modifier [arguments])+:] command [varlist | var = exp] [if expression] [in range] [weight] [using filename] [, options]

#ifndef RSTATA_H
#define RSTATA_H

#include <Rcpp.h>

// abstract base class for Stata expressions
class BaseStataExpr
{
    public:
        StataExpr **children; // array length known at parse time
        
        // method that returns this StataExpr as an R expression
        virtual Rcpp::Language as_expr() const = 0;
};

class NumberStataExpr: public BaseStataExpr
{
    public:
        NumberStataExpr(signed long int _data);
        NumberStataExpr(unsigned long int _data);
        NumberStataExpr(signed double _data);
        NumberStataExpr(unsigned double _data);
        
        virtual Rcpp::Language as_expr() const;

    private:
        Rcpp::NumericVector data(1); // a type-generic number already in R format
};

class IdentStataExpr: public BaseStataExpr
{
    public:
        IdentStataExpr(Rcpp::Symbol _data);
        IdentStataExpr(std::string _data);
        
        virtual Rcpp::Language as_expr() const;

    private:
        Rcpp::Symbol data;
};

class StringStataExpr: public BaseStataExpr
{
    public:
        StringStataExpr(std::string _data);
        
        virtual Rcpp::Language as_expr() const;

    private:
        std::string data;
};

// BY, BYSORT, XI, etc.
class ModifierStataExpr: public BaseStataExpr
{
    public:
        ModifierStataExpr(Rcpp::Symbol _data, StataExpr **_children);
        ModifierStataExpr(std::string _data, StataExpr **_children);
        
        virtual Rcpp::Language as_expr() const;
    
    private:
        Rcpp::Symbol data;
};

// OPTION_LIST
class OptionStataExpr: public BaseStataExpr
{
    public:
        OptionStataExpr(Rcpp::Symbol _data, StataExpr **_children);
        OptionStataExpr(std::string _data, StataExpr **_children);
        
        virtual Rcpp::Language as_expr() const;
    
    private:
        Rcpp::Symbol data;
};

// all other expressions: assignment expressions, logical expressions,
// equality expressions, relational expressions, arithmetic expressions,
// unary expressions and function calls
class BranchStataExpr: public BaseStataExpr
{
    public:
        BranchStataExpr(Rcpp::Symbol _data, StataExpr **_children);
        BranchStataExpr(std::string _data, StataExpr **_children);
        
        virtual Rcpp::Language as_expr() const;
    
    private:
        Rcpp::Symbol data;
};

// We don't need to continue the parse tree all the way up to the level of a
// translation unit because the command syntax is so constrained. Breaking it
// out this way makes writing the R easier.
class StataCmd
{
    public:
        std::string verb; // the command verb
        
        StataExpr *modifiers; // "modifiers": a MODIFIER_LIST of the by, bysort, etc, applied
        StataExpr *varlist; // a varlist is a left-deep tree of IDENTs
        StataExpr *assign_stmt; // "var = exp"
        StataExpr *if_exp; // "if expression"
        StataExpr *options; // ", options"
        
        int has_range;
        int range_lower; // the lower range limit
        int range_upper; // the upper range limit
        
        std::string weight; // "weight": the column name of the weight, or NULL
        std::string using_filename; // "using filename": the filename given after using, or NULL
        
        StataCmd(std::string _verb,
                 std::string _weight, std::string _using_filename,
                 int _has_range, int _range_lower, int _range_upper,
                 StataExpr *_modifiers, StataExpr *_varlist,
                 StataExpr *_assign_stmt, StataExpr *_if_exp,
                 StataExpr *_options);
        
        // method that returns this StataCmd as an R list
        Rcpp::List as_list();
};

// positional-only parameters are garbage...
class MakeStataCmd
{
    public:
        MakeStataCmd(std::string _verb);

        StataCmd create();

        MakeStataCmd& verb(std::string const& _verb);
        MakeStataCmd& modifiers(StataExpr *_modifiers);
        MakeStataCmd& varlist(StataExpr *_varlist);
        MakeStataCmd& assign_stmt(StataExpr *_assign_stmt);
        MakeStataCmd& if_exp(StataExpr *_if_exp);
        MakeStataCmd& options(StataExpr *_options);
        MakeStataCmd& has_range(int _has_range);
        MakeStataCmd& range_upper(int _range_upper);
        MakeStataCmd& range_lower(int _range_lower);
        MakeStataCmd& weight(std::string _weight);
        MakeStataCmd& using_filename(std::string _using_filename);
        
    private:
        std::string __verb;
        StataExpr *__modifiers;
        StataExpr *__varlist;
        StataExpr *__assign_stmt;
        StataExpr *__if_exp;
        StataExpr *__options;
        int __has_range;
        int __range_lower;
        int __range_upper;
        std::string __weight;
        std::string __using_filename;
};

typedef struct STATA_CMD_LIST
{
    StataCmd *current;
    struct STATA_CMD_LIST *next;
} STATA_CMD_LIST_T;

#ifndef ADD_TO_CMD_LIST
#define ADD_TO_CMD_LIST(cmd, cur)              \
{                                              \
        if(cur->current == NULL)               \
        {                                      \
            cur->current = &cmd;               \
        }                                      \
        else                                   \
        {                                      \
            STATA_CMD_LIST_T next_cmdlist =    \
            {                                  \
                &cmd, /* current */            \
                NULL  /* next */               \
            };                                 \
                                               \
            cur->next = &next_cmdlist;         \
            cur = &next_cmdlist;               \
        }                                      \
}
#endif /* ADD_TO_CMD_LIST */

#endif /* RSTATA_H */

