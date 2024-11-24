%{
#include <stdio.h>
#include <ctype.h>

void yyerror(char *s);   // Declare yyerror here
int yylex(void);          // Declare yylex here
%}

%token TA TD
%left '+' '-'
%left '*' '/'

%%

list: expr '\n' { printf("Accepted\n"); }
    | id '=' expr '\n' { printf("Accepted\n"); }
    | 
    ;

expr: '(' expr ')'
    | expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | num
    | id
    ;

num: TD
    ;

id: TA
   ;

%%

int main() {
    return yyparse();
}

int yylex() {
    char c;
    c = getchar();
    if (isalpha(c)) return TA;
    if (isdigit(c)) return TD;
    return c;
}

void yyerror(char *s) {
    printf("%s\n", s);
}
