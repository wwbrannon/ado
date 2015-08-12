// Stata is a very unusual language, more like the Bourne shell than it is like C.
// A Stata script consists of one or more "commands" in sequence. Each command starts with
// a verb and then has various kinds of arguments and options after it.
// Syntax is not fully linear, so one command is one line. (But there's a /// syntax
// to continue a command across lines, and certain flow-control constructs like forval span
// more than one line as well.)

// The basic Stata command syntax is:
// [ (modifier [arguments])+:] command [varlist | var = exp] [if expression] [in range] [weight] [using filename] [, options]

#include <Rcpp.h>

#ifndef __RSTATA_H__
#define __RSTATA_H__

class StataExpr
{
    public:
        enum node_type
        {
            STRING_LITERAL_T,
            NUMBER_T,
            IDENT_T,

            MODIFIER_T,
            MODIFIER_LIST_T,
            
            OPTION_T,
            
            ASSIGNMENT_StataExpr,
            LOGICAL_StataExpr,
            EQUALITY_StataExpr,
            RELATIONAL_StataExpr,
            ARITHMETIC_StataExpr,
            UNARY_StataExpr,
            CALL_StataExpr
        } node_type;

        StataExpr *left;
        StataExpr *right;
        
        union data {
                std::string str; // this is character for everything but NUMBER
                int  num;
              } op;

        // method that returns this StataExpr as an R expression or language or whatever
        List as_list()
        {
            return List();
        }
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
                 StataExpr *_options)
        {
            verb = _verb;

            modifiers = _modifiers;
            varlist = _varlist;
            assign_stmt = _assign_stmt;
            if_exp = _if_exp;
            options = _options;

            has_range = _has_range;
            range_lower = _range_lower;
            range_upper = _range_upper;

            weight = _weight;
            using_filename = _using_filename;
        };

        List as_list()
        {
            char *verb, *weight, *using_filename;
            int range_lower, range_upper;
            modifiers, varlist, assign_stmt, if_exp, options; // have to find the right expression type
            List res;
           
            // book-keeping for walking the list of commands
            cur = cmdlist.current;
            next = cmdlist.next;

            // temp variables used to construct the R version of this object
            verb = cur->verb; // this will always be set
            
            if(cur->has_using)
                using_filename = cur->using_filename;
            else
                using_filename = R_NilValue;

            if(cur->has_weight)
                weight = cur->weight;
            else
                weight = R_NilValue;

            if(cur->has_range)
            {
                range_upper = cur->range_upper;
                range_lower = cur->range_lower;
            }
            else
            {
                range_upper = R_NilValue;
                range_lower = R_Nilvalue;
            }

            // and the expression types here

            res = List::create(_["verb"]            = verb,
                               _["modifiers"]       = modifiers,
                               _["varlist"]         = varlist,
                               _["assign_stmt"]     = assign_stmt,
                               _["if_exp"]          = if_exp,
                               _["range_lower"]     = range_lower,
                               _["range_upper"]     = range_upper,
                               _["weight"]          = weight,
                               _["using_filename"]  = using_filename,
                               _["options"]         = options);
            
            return res;
        }
};

// positional-only parameters are garbage...
class MakeStataCmd
{
    public:
        MakeStataCmd(std::string _verb)
        {
            __verb = _verb;
            
            __modifiers = NULL;
            __varlist = NULL;
            __assign_stmt = NULL;
            __if_exp = NULL;
            __options = NULL;

            __has_range = 0;
            __range_lower = 0;
            __range_upper = 0;

            __weight = "";
            __using_filename = "";
        }

        StataCmd create()
        {
            StataCmd *cmd = new StataCmd(__verb, __weight, __using_filename,
                                        __has_range, __range_upper, __range_lower,
                                        __modifiers, __varlist, __assign_stmt,
                                        __if_exp, __options);

            return *cmd;
        }

        MakeStataCmd& verb(std::string const& _verb)
        {
            __verb = _verb;
            return *this;
        }

        MakeStataCmd& modifiers(StataExpr *_modifiers)
        {
            __modifiers = _modifiers;
            return *this;
        }

        MakeStataCmd& varlist(StataExpr *_varlist)
        {
            __varlist = _varlist;
            return *this;
        }

        MakeStataCmd& assign_stmt(StataExpr *_assign_stmt)
        {
            __assign_stmt = _assign_stmt;
            return *this;
        }

        MakeStataCmd& if_exp(StataExpr *_if_exp)
        {
            __if_exp = _if_exp;
            return *this;
        }

        MakeStataCmd& options(StataExpr *_options)
        {
            __options = _options;
            return *this;
        }

        MakeStataCmd& has_range(int _has_range)
        {
            __has_range = _has_range;
            return *this;
        }

        MakeStataCmd& range_upper(int _range_upper)
        {
            __range_upper = _range_upper;
            return *this;
        }

        MakeStataCmd& range_lower(int _range_lower)
        {
            __range_lower = _range_lower;
            return *this;
        }

        MakeStataCmd& weight(std::string _weight)
        {
            __weight = _weight;
            return *this;
        }
        
        MakeStataCmd& using_filename(std::string _using_filename)
        {
            __using_filename = _using_filename;
            return *this;
        }
        
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

// the initial empty command list the update macro will work with,
// and the head pointer to the list
STATA_CMD_LIST_T cmdlist =
{
    NULL, // current
    NULL  // next
};

STATA_CMD_LIST_T *cur = &cmdlist;
STATA_CMD_LIST_T *head = &cmdlist;

#ifndef ADD_TO_CMD_LIST
#define ADD_TO_CMD_LIST(cmd, cmdlist_ptr)           \
{                                                   \
        if(cur->current == NULL)                    \
        {                                           \
            cur->current = &cmd;                    \
        }                                           \
        else                                        \
        {                                           \
            STATA_CMD_LIST_T next_cmdlist =         \
            {                                       \
                &cmd, /* current */                 \
                NULL  /* next */                    \
            };                                      \
                                                    \
            cur->next = &next_cmdlist;              \
            cur = &next_cmdlist;                    \
        }                                           \
        cmdlist_ptr = head;                         \
}
#endif /* ADD_TO_CMD_LIST */

#endif /* __RSTATA_H__ */

