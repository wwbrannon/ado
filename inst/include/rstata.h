// Stata is a very unusual language, more like the Bourne shell than it is like C.
// A Stata script consists of one or more "commands" in sequence. Each command starts with
// a verb and then has various kinds of arguments and options after it.
// Syntax is not fully linear, so one command is one line. (But there's a /// syntax
// to continue a command across lines, and certain flow-control constructs like forval span
// more than one line as well.)

// The basic Stata command syntax is:
// [ (modifier [arguments])+:] command [varlist | var = exp] [if expression] [in range] [weight] [using filename] [, options]

#ifndef __RSTATA_H__
#define __RSTATA_H__

typedef struct ast_node
{
    enum node_type
    {
        STRING_LITERAL_T,
        NUMBER_T,
        IDENT_T,

        MODIFIER_T,
        MODIFIER_LIST_T,
        
        OPTION_T,
        
        ASSIGNMENT_EXPR_T,
        LOGICAL_EXPR_T,
        EQUALITY_EXPR_T,
        RELATIONAL_EXPR_T,
        ARITHMETIC_EXPR_T,
        UNARY_EXPR_T,
        CALL_EXPR_T
    } node_type;

    struct ast_node *left;
    struct ast_node *right;
    
    union data {
            char *str; // this is character for everything but NUMBER
            int  num;
          } op;
} EXPR_T;

// We don't need to continue the parse tree all the way up to the level of a
// translation unit because the command syntax is so constrained. Breaking it
// out this way makes writing the R easier
typedef struct STATA_CMD
{
    // the command verb
    char *verb;
    
    // "modifiers": a MODIFIER_LIST of the by, bysort, etc applied to the command
    int has_modifiers; // 1 if there were modifiers applied, 0 otherwise
    EXPR_T *modifiers;

    // "varlist"
    int has_varlist; // 1 if a varlist was provided, 0 otherwise
    EXPR_T *varlist; // a varlist is a left-deep tree of IDENTs
    
    // "var = exp"
    int has_assign; // 1 if an assignment expression was provided, 0 otherwise
    EXPR_T *assign_stmt;
    
    // "if expression"
    int has_if; // 1 if "if expression" was given, 0 otherwise
    EXPR_T *if_exp;
    
    // "in range"
    int has_range; // 1 if "in x/y" was given, 0 otherwise
    int range_lower; // the lower range limit, or NULL
    int range_upper; // the upper range limit, or NULL
    
    // "weight": the column name of the weight, or NULL
    int has_weight;
    char *weight;
    
    // "using filename": the filename given after using, or NULL
    int has_using; // 1 if a using clause with filename was given, 0 otherwise
    char *using_filename;

    // ", options"
    int has_options; // 1 if any options were given, 0 otherwise
    EXPR_T *options;
} STATA_CMD_T;

typedef struct STATA_CMD_LIST
{
    STATA_CMD_T *current;
    STATA_CMD_T *next;
} STATA_CMD_LIST_T;

#endif /* __RSTATA_H__ */

