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
// out this way makes writing the R easier.
class StataCmd
{
    public:
        std::string n_verb; // the command verb
        
        EXPR_T *modifiers; // "modifiers": a MODIFIER_LIST of the by, bysort, etc, applied
        EXPR_T *varlist; // a varlist is a left-deep tree of IDENTs
        EXPR_T *assign_stmt; // "var = exp"
        EXPR_T *if_exp; // "if expression"
        EXPR_T *options; // ", options"
        
        int has_range;
        int range_lower; // the lower range limit
        int range_upper; // the upper range limit
        
        std::string *weight; // "weight": the column name of the weight, or NULL
        std::string *using_filename; // "using filename": the filename given after using, or NULL
        
        StataCmd(std::string n_verb,
                 std::string n_weight = "", std::string n_using_filename = "",
                 int n_has_range = 0, int n_range_lower = 0, int n_range_upper = 0,
                 EXPR_T *n_modifiers = NULL, EXPR_T *n_varlist = NULL,
                 EXPR_T *n_assign_stmt = NULL, EXPR_T *n_if_exp = NULL,
                 EXPR_T *n_options = NULL)
        {
            verb = n_verb;

            modifiers = n_modifiers;
            varlist = n_varlist;
            assign_stmt = n_assign_stmt;
            if_exp = n_if_exp;
            options = n_options;

            has_range = n_has_range;
            range_lower = n_range_lower;
            range_upper = n_range_upper;

            weight = n_weight;
            using_filename = n_using_filename;
        };
};

typedef struct STATA_CMD_LIST
{
    StataCmd *current;
    StataCmd *next;
} STATA_CMD_LIST_T;

// the initial empty command list the update macro will work with,
// and the head pointer to the list
STATA_CMD_LIST_T cmdlist =
{
    .current = NULL,
    .next = NULL
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
                .current = &cmd;                    \
                .next = NULL                        \
            };                                      \
                                                    \
            cur->next = &next_cmdlist;              \
            cur = &next_cmdlist;                    \
        }                                           \
        cmdlist_ptr = head;                         \
}
#endif /* ADD_TO_CMD_LIST */

#endif /* __RSTATA_H__ */

