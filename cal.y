%{
#include <stdio.h>
#include <ctype.h> // For isalpha and isdigit
int yylex();
int yyerror(const char *s);
%}

%token TA TD
%left '+' '-'
%left '*' '/'

%%
list: expr '\n' { printf("Accepted: %d\n", $1); }
    | id '=' expr '\n' { printf("Accepted: %d\n", $3); }
    |
    ;

expr: '(' expr ')' { $$ = $2; }
    | expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { 
        if ($3 == 0) {
            yyerror("Division by zero");
        } else {
            $$ = $1 / $3;
        }
      }
    | num
    | id
    ;

num: TD { $$ = $1; }
   | num TD { $$ = 10 * $1 + $2; }
   ;

id: TA s { $$ = $1; }
   ;

s: s TA { /* Do nothing for now */ }
 | s TD { /* Do nothing for now */ }
 | /* Empty */
 ;

%%

int main() {
    printf("Enter arithmetic expressions (Ctrl+D to exit):\n");
    yyparse();
    return 0;
}

int yylex() {
    int c;
    extern int yylval;

    while ((c = getchar()) == ' ' || c == '\t') // Skip whitespace
        ;

    if (isalpha(c)) { // For variable names
        yylval = c - 'a';
        return TA;
    } else if (isdigit(c)) { // For numeric values
        yylval = c - '0';
        return TD;
    } else {
        return c; // Return operators or other symbols
    }
}

int yyerror(const char *s) {
    printf("Error: %s\n", s);
    return 0;
}

int yywrap() {
    return 1; // End of input
}
