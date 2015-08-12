%{
#include <stdio.h>
#include <string.h>
 
void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
 
int yywrap()
{
        return 1;
} 
  
int main(int argc, const char **argv)
{
        yyparse();
} 

%}

%token NUMBER IDENT STRING_LITERAL
%token INSHEET TABLE SUM DI
%token USING BY IN IF PWEIGHT AWEIGHT
%token GT_OP LE_OP EQ_OP NE_OP OR_OP AND_OP

%define parse.error verbose
%start commands

%%

primary_expression:
      NUMBER
    | IDENT
    | STRING_LITERAL
    | '(' expression ')'
    ;

postfix_expression:
      primary_expression
    | postfix_expression '(' ')'
    | postfix_expression '(' argument_expression_list ')'
    ;

argument_expression_list:
      primary_expression
    | argument_expression_list ',' assignment_expression
    ;

unary_expression:
      postfix_expression
    | unary_operator postfix_expression
    ;

unary_operator:
      '-'
    | '+'
    | '!'
    ;

mult_expression:
      unary_expression
    | mult_expression '*' unary_expression
    | mult_expression '/' unary_expression
    | mult_expression '%' unary_expression
    ;

additive_expression:
    mult_expression
    | additive_expression '+' mult_expression
    | additive_expression '-' mult_expression
    ;

relational_expression:
    additive_expression
    | relational_expression '<' additive_expression
    | relational_expression '>' additive_expression
    | relational_expression LE_OP additive_expression
    | relational_expression GT_OP additive_expression
    ;

equality_expression:
      relational_expression
    | equality_expression EQ_OP relational_expression
    | equality_expression NE_OP relational_expression
    ;

and_expression:
      equality_expression
    | and_expression AND_OP equality_expression
    ;

or_expression:
      and_expression
    | or_expression OR_OP and_expression
    ;

assignment_expression:
    IDENT '=' or_expression
    ;

expression:
      assignment_expression
    | or_expression
    ;

varlist:
    | varlist IDENT
    ;

command:
    insheet_cmd
    | table_cmd
    | sum_cmd
    | di_cmd
    ;

commands:
    | commands command
    ;

insheet_cmd:
    INSHEET USING STRING_LITERAL
    {
        printf("displaying insheet\n");
    }
    ;

table_cmd:
      TABLE IDENT
    | TABLE IDENT IDENT
    {
        printf("displaying table\n");
    }
    ;

sum_cmd:
   SUM varlist 
    {
        printf("displaying sum\n");
    }
    ;

di_cmd:
    DI expression
    {
        printf("displaying expression\n");
    }
    ;
%%

