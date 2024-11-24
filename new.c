#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

int isDelimiter(char ch) {
    return (ch == ')' || ch == '(' || ch == ' ' || ch == '[' || ch == ']' || ch == '{' || ch == '}');
}

int isKeyword(char *token) {
    char *keywords[] = {"int", "float", "double", "void", "char"};
    int n_keywords = sizeof(keywords) / sizeof(char *);

    for (int i = 0; i < n_keywords; i++) {  // Correct loop to check keywords
        if (token != NULL && strcmp(token, keywords[i]) == 0) {
            return 1;
        }
    }

    return 0;
}

int isDigit(char *t) {
    for (int i = 0; i < strlen(t); i++) {
        if (!isdigit(t[i])) {
            return 0;
        }
    }
    return 1;
}

int isFloat(char *t) {
    int hasDecimal = 0;
    for (int i = 0; i < strlen(t); i++) {
        if (t[i] == '.') {
            if (hasDecimal) {
                return 0;  // Multiple decimal points
            }
            hasDecimal = 1;
        } else if (!isdigit(t[i])) {
            return 0;  // Non-digit character
        }
    }
    return hasDecimal;
}

int isIdentifier(char *t) {
    if (!isalpha(t[0]) && t[0] != '_') {
        return 0;  // Identifier must start with an alphabet or '_'
    }
    for (int i = 0; i < strlen(t); i++) {
        if (!isalnum(t[i]) && t[i] != '_') {
            return 0;  // Identifier can only contain alphanumeric characters or '_'
        }
    }
    return 1;
}

void printTokenType(char *token) {
    if (isKeyword(token)) {
        printf("Keyword: %s\n", token);
    } else if (isDigit(token)) {
        printf("Integer: %s\n", token);
    } else if (isFloat(token)) {
        printf("Float: %s\n", token);
    } else if (isIdentifier(token)) {
        printf("Identifier: %s\n", token);
    } else {
        printf("Symbol: %s\n", token);
    }
}

void tokenizeInput(char *input) {
    char temp[100];
    int i = 0, j = 0;

    while (input[i] != '\0') {
        if (isDelimiter(input[i])) {
            if (j > 0) {
                temp[j] = '\0';
                printTokenType(temp);
                j = 0;
            }
            if (!isspace(input[i])) {  // If it's a delimiter, print it as a symbol
                temp[0] = input[i];
                temp[1] = '\0';
                printTokenType(temp);
            }
        } else {
            temp[j++] = input[i];
        }
        i++;
    }

    if (j > 0) {  // Print the last token if any
        temp[j] = '\0';
        printTokenType(temp);
    }
}

int main() {
    char input[100];
    printf("Enter code: ");
    fgets(input, sizeof(input), stdin);
    input[strcspn(input, "\n")] = 0;  // Remove newline character from input

    tokenizeInput(input);

    return 0;
}
