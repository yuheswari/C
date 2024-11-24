%{
    int t = 'A' - 1; // Temporary variable for three-address code
    #include <stdio.h>
    #include <ctype.h>
    int yylex();
    void yyerror(const char *s);
%}

%token TA TD
%left '+' '-'
%left '*'
%nonassoc '='

%%
list: list expr '\n' { /* Allow multiple expressions */ }
    | /* Empty list */
    ;

expr: TA { $$ = $1; } // Variable
    | TD { $$ = $1; } // Number
    | expr '+' expr { 
        t++; 
        printf("\n%c = %c + %c", t, $1, $3); 
        $$ = t; 
      }
    | expr '-' expr { 
        t++; 
        printf("\n%c = %c - %c", t, $1, $3); 
        $$ = t; 
      }
    | expr '*' expr { 
        t++; 
        printf("\n%c = %c * %c", t, $1, $3); 
        $$ = t; 
      }
    | '(' expr ')' { $$ = $2; } // Parentheses
    | expr '=' expr { 
        t++; 
        printf("\n%c = %c = %c", t, $1, $3); 
        $$ = t; 
      }
    ;

%%

int main() {
    printf("Enter expressions, one per line (Ctrl+D to exit):\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int yylex() {
    int c;
    while ((c = getchar()) == ' ' || c == '\t') // Skip whitespace
        ;

    if (isalpha(c)) { // Variables
        yylval = c;
        return TA;
    }

    if (isdigit(c)) { // Numbers
        yylval = c - '0';
        return TD;
    }

    return c; // Operators and parentheses
}

int yywrap() {
    return 1; // End of input
}
