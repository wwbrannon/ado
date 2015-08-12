// Stata is a very unusual language. It resembles the Unix shell(s) than more traditional
// programming languages. A Stata script is one or more commands, which are possibly compound
// statement blocks or loops with an associated block, executed in the order they appear in the file.
// Each non-compound command starts with a verb and then has various kinds of arguments and options
// after it. In general, one non-compound command is one line, but there is a /// syntax to continue
// a command across a line break.

// The basic Stata command syntax is:
// [ (prefix [arguments])+:] command [varlist | var = exp] [if expression] [in range] [weight] [using filename] [, options]

#ifndef RSTATA_H
#define RSTATA_H

#include <memory>
#include <Rcpp.h>

// abstract base class for the AST the parser will generate
class BaseExprNode
{
    public:
        // method that returns this BaseExprNode as an R expression
        Rcpp::List as_R_object() const;
};

// The next three classes are AST nodes for literals - string, symbol and numeric
class NumberExprNode: public BaseExprNode
{
    public:
        NumberExprNode(std::string _data);
        
        Rcpp::List as_R_object() const;

    private:
        std::string data;
};

class IdentExprNode: public BaseExprNode
{
    public:
        IdentExprNode(std::string _data);
        
        Rcpp::List as_R_object() const;

    private:
        std::string data;
};

class StringExprNode: public BaseExprNode
{
    public:
        StringExprNode(std::string _data);
        
        Rcpp::List as_R_object() const;

    private:
        std::string data;
};

class DatetimeExprNode: public BaseExprNode
{
    public:
        DatetimeExprNode(std::string _date, std::string _time);
        DatetimeExprNode(std::string _dt);
        
        Rcpp::List as_R_object() const;

    private:
        Rcpp::Datetime dt;
};

// all other expressions: assignment expressions, logical expressions,
// equality expressions, relational expressions, arithmetic expressions,
// function calls, and even statement blocks
class BranchExprNode: public BaseExprNode
{
    public:
        BranchExprNode(std::string _type, std::string _data);
        
        void setChildren(std::vector<BaseExprNode *> _children);
        void setChildren(std::initializer_list<BaseExprNode *> children);
        void appendChild(BaseExprNode *_child);
        
        Rcpp::List as_R_object() const;
    
    private:
        std::vector<BaseExprNode *> children;
        std::string data;
        std::string type;
};

// All non-compound Stata commands
class GeneralStataCmd: public BranchExprNode
{
    private:
        BranchExprNode *varlist;
        BranchExprNode *assign_stmt; // "var = exp"
        BranchExprNode *if_exp; // "if expression"
        BranchExprNode *weight; // "weight"
        BranchExprNode *options; // ", options"
        
        int has_range;
        int range_lower; // the lower range limit
        int range_upper; // the upper range limit
        
        std::string using_filename; // "using filename": the filename given after using, or NULL
    
    public:
        std::string verb;

        Rcpp::List as_R_object() const;

        GeneralStataCmd(std::string _verb);

        GeneralStataCmd(std::string _verb,
                   BranchExprNode *_weight, std::string _using_filename,
                   int _has_range, int _range_lower, int _range_upper,
                   BranchExprNode *_varlist,
                   BranchExprNode *_assign_stmt,
                   BranchExprNode *_if_exp,
                   BranchExprNode *_options);
};

// The "embedded R" block that the lexer recognizes and passes through
class EmbeddedRCmd: public GeneralStataCmd
{
    private:
        std::string text;

    public:
        Rcpp::List as_R_object() const;
        EmbeddedRCmd(std::string _text);
};

// A helper class to avoid typing out all the args to the GeneralStataCmd constructor.
// Positional-only parameters are garbage...
class MakeGeneralStataCmd
{
    public:    
        MakeGeneralStataCmd(std::string _verb);
        
        GeneralStataCmd create();

        MakeGeneralStataCmd& verb(std::string _verb);
        MakeGeneralStataCmd& weight(BranchExprNode *_weight);
        MakeGeneralStataCmd& varlist(BranchExprNode *_varlist);
        MakeGeneralStataCmd& assign_stmt(BranchExprNode *_assign_stmt);
        MakeGeneralStataCmd& if_exp(BranchExprNode *_if_exp);
        MakeGeneralStataCmd& options(BranchExprNode *_options);
        MakeGeneralStataCmd& has_range(int _has_range);
        MakeGeneralStataCmd& range_upper(int _range_upper);
        MakeGeneralStataCmd& range_lower(int _range_lower);
        MakeGeneralStataCmd& using_filename(std::string _using_filename);
    
    private:
        std::string _verb;
        BranchExprNode *_weight;
        BranchExprNode *_varlist;
        BranchExprNode *_assign_stmt;
        BranchExprNode *_if_exp;
        BranchExprNode *_options;
        int _has_range;
        int _range_lower;
        int _range_upper;
        std::string _using_filename;
};

#endif /* RSTATA_H */

