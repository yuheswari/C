%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define tokens
#define YYSTYPE char*
#define NUM 256
#define ID 257
#define IF 258
#define THEN 259
#define ELSE 260
#define LE 261
#define GE 262
#define EQ 263
#define NE 264
#define OR 265
#define AND 266

int yylex();
int yyerror(const char* s);
%}

%token ID NUM IF THEN ELSE LE GE EQ NE OR AND
%right '='
%left AND OR
%left '<' '>' LE GE EQ NE
%left '+' '-'
%left '*' '/'
%right UMINUS
%left '!'

%%
S: ST { printf("Input accepted.\n"); exit(0); }
 ;

ST: IF '(' E2 ')' THEN ST1 ';' ELSE ST1 ';'
  | IF '(' E2 ')' THEN ST1 ';'
 ;

ST1: ST
   | E
 ;

E: ID '=' E
 | E '+' E
 | E '-' E
 | E '*' E
 | E '/' E
 | E '<' E
 | E '>' E
 | E LE E
 | E GE E
 | E EQ E
 | E NE E
 | E OR E
 | E AND E
 | ID
 | NUM
 ;

E2: E '<' E
  | E '>' E
  | E LE E
  | E GE E
  | E EQ E
  | E NE E
  | E OR E
  | E AND E
  | ID
  | NUM
 ;
%%
int main() {
    printf("Enter the expression: ");
    yyparse();
    return 0;
}

int yyerror(const char* s) {
    printf("Error: %s\n", s);
    return 0;
}

// Lexer integrated into Yacc
int yylex() {
    static char buffer[100];
    int c;

    while ((c = getchar())) {
        if (isspace(c)) continue;

        if (isalpha(c)) {
            ungetc(c, stdin);
            scanf("%s", buffer);

            if (strcmp(buffer, "if") == 0) return IF;
            if (strcmp(buffer, "then") == 0) return THEN;
            if (strcmp(buffer, "else") == 0) return ELSE;

            yylval = strdup(buffer); // Identifier
            return ID;
        }

        if (isdigit(c)) {
            ungetc(c, stdin);
            scanf("%s", buffer);
            yylval = strdup(buffer); // Number
            return NUM;
        }

        switch (c) {
            case '<':
                if ((c = getchar()) == '=') return LE;
                ungetc(c, stdin);
                return '<';
            case '>':
                if ((c = getchar()) == '=') return GE;
                ungetc(c, stdin);
                return '>';
            case '=':
                if ((c = getchar()) == '=') return EQ;
                ungetc(c, stdin);
                return '=';
            case '!':
                if ((c = getchar()) == '=') return NE;
                ungetc(c, stdin);
                return '!';
            case '|':
                if ((c = getchar()) == '|') return OR;
                ungetc(c, stdin);
                return '|';
            case '&':
                if ((c = getchar()) == '&') return AND;
                ungetc(c, stdin);
                return '&';
            default:
                return c;
        }
    }
    return 0;
}
