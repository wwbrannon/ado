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

%token LBRACKET RBRACKET LPAREN RPAREN LBRACE RBRACE DQUOTE SQUOTE EQUALS COMMA COLON
%token NUMBER TIMES PLUS DIVIDE MINUS
%token INSHEET TABLE SUM DI
%token USING BY IN IF PWEIGHT AWEIGHT
%token IDENT 

%%

command:
    insheet_cmd
    | table_cmd
    | sum_cmd
    | di_cmd
    ;

primary_expression:
    NUMBER
    | LPAREN expression RPAREN
    ;

mult_expression:
    primary_expression
    | mult_expression TIMES mult_expression
    | mult_expression DIVIDE mult_expression
    ;

additive_expression:
    mult_expression
    | additive_expression PLUS mult_expression
    | additive_expression MINUS mult_expression
    ;

num_expression:
    additive_expression
    ;
    
expression:
    num_expression;

varlist:
    | varlist IDENT
    ;

insheet_cmd:
    INSHEET USING IDENT
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

