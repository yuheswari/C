%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h> // For isdigit()

int yylex();
int yyerror(char* s);
%}

%token INT FLOAT STRING ADD SUB MUL DIV EQ LPAREN RPAREN
%left ADD SUB
%left MUL DIV
%nonassoc EQ

%%
program: expr { printf("Type check passed!\n"); }
       ;

expr: INT               { $$ = INT; }
    | FLOAT             { $$ = FLOAT; }
    | STRING            { $$ = STRING; }
    | expr ADD expr     { if ($1 != $3) { yyerror("Type mismatch: cannot add different types"); exit(0); } else $$ = $1; }
    | expr SUB expr     { if ($1 != $3) { yyerror("Type mismatch: cannot subtract different types"); exit(0); } else $$ = $1; }
    | expr MUL expr     { if ($1 != $3) { yyerror("Type mismatch: cannot multiply different types"); exit(0); } else $$ = $1; }
    | expr DIV expr     { if ($1 != $3) { yyerror("Type mismatch: cannot divide different types"); exit(0); } else $$ = $1; }
    | expr EQ expr      { if ($1 != $3) { yyerror("Type mismatch: cannot compare different types"); exit(0); } else $$ = $1; }
    | LPAREN expr RPAREN { $$ = $2; }
    ;

%%
int main() {
    yyparse();
    return 0;
}

int yyerror(char* s) {
    printf("Error: %s\n", s);
    return 0;
}

/* Lexer integrated into the Yacc file */
int yylex() {
    static char input[100];
    char *current;
    int c;

    if (!*input) {
        if (!fgets(input, sizeof(input), stdin)) {
            return 0; // End of input
        }
        current = input;
    }

    while ((c = *current++)) {
        switch (c) {
            case '+': return ADD;
            case '-': return SUB;
            case '*': return MUL;
            case '/': return DIV;
            case '=': return EQ;
            case '(': return LPAREN;
            case ')': return RPAREN;
            case ' ': case '\t': case '\n': continue; // Ignore whitespace
            default:
                if (isdigit(c)) {
                    ungetc(c, stdin);
                    int value;
                    scanf("%d", &value);
                    return INT;
                } else if (c == '"') {
                    char str[100];
                    scanf("%[^\"]", str);
                    getchar(); // Consume closing quote
                    return STRING;
                } else {
                    printf("Unexpected character: %c\n", c);
                    exit(1);
                }
        }
    }

    return 0; // End of input
}
