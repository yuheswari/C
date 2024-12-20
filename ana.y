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

expr: '(' expr ')' {$$=$2;}
    | expr '+' expr {$$=$1+$3;}
    | expr '-' expr {$$=$1=$3;}
    | expr '*' expr {$$=$1*$3;}
    | expr '/' expr {$$=$1/$3;}
    | num
    | id
    ;

num: TD {$$=$$;}
id: TA  {$$=10*$1+$2;}
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
