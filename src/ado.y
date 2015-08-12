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

%token LBRACKET RBRACKET LPAREN RPAREN LBRACE RBRACE DQUOTE SQUOTE EQUALS COMMA COLON NUMBER TIMES PLUS DIVIDE SUBTRACT INSHEET TABLE REG LOGIT SUM DESCRIBE DI USING BY IN IF PWEIGHT AWEIGHT IDENT 

command:
    insheet_cmd
    | table_cmd
    | reg_cmd
    | logit_cmd
    | sum_cmd
    | describe_cmd
    | di_cmd
    ;



