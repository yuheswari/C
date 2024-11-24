#include <stdio.h>
#include <string.h>

struct st {
    char op3[3], op1[3], op2[3], op;
};

int main() {
    int n, i, reg = 0;
    struct st t[10];

    printf("Enter number of codes: ");
    scanf("%d", &n);

    for (i = 0; i < n; i++)
        scanf(" %s %s %s %c", t[i].op3, t[i].op1, t[i].op2, &t[i].op);

    printf("\nGenerated Assembly-like Instructions:\n");
    for (i = 0; i < n; i++) {
        if (t[i].op1[0] != 'r') {
            printf("MOV r%d, %s\n", reg, t[i].op1);
            sprintf(t[i].op1, "r%d", reg++);
        }
        if (t[i].op2[0] != 'r') {
            printf("MOV r%d, %s\n", reg, t[i].op2);
            sprintf(t[i].op2, "r%d", reg++);
        }
        if (t[i].op == '=') {
            printf("MOV %s, %s\n", t[i].op3, t[i].op1);
        } else {
            printf("%s r%d, %s, %s\n", 
                t[i].op == '+' ? "ADD" : t[i].op == '-' ? "SUB" : "MUL", 
                reg, t[i].op1, t[i].op2);
            sprintf(t[i].op3, "r%d", reg++);  // Properly format register name
        }
    }

    return 0;
}
