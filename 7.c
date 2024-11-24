#include <stdio.h>
#include <string.h>

struct st {
    char op3, op1[10], op2[10], op;  // Increase op1 and op2 array size
};

int main() {
    int n, i, k, d;
    struct st t[10];

    printf("Enter number of instructions: ");
    scanf("%d", &n);

    for (i = 0; i < n; i++)
        scanf(" %c %s %s %c", &t[i].op3, t[i].op1, t[i].op2, &t[i].op);

    for (i = 0; i < n; i++) {
        if (t[i].op1[0] == '#' && t[i].op2[0] == '#') {
            d = (t[i].op == '+') ? (t[i].op1[1] - '0') + (t[i].op2[1] - '0') :
                (t[i].op == '-') ? (t[i].op1[1] - '0') - (t[i].op2[1] - '0') : 0;

            // Ensure that the buffer can hold the formatted result
            for (k = i + 1; k < n; k++) {
                if (t[k].op1[0] == t[i].op3) snprintf(t[k].op1, sizeof(t[k].op1), "#%d", d);  // Use snprintf
                if (t[k].op2[0] == t[i].op3) snprintf(t[k].op2, sizeof(t[k].op2), "#%d", d);  // Use snprintf
            }

            for (k = i; k < n - 1; k++) t[k] = t[k + 1];
            n--; i--;
        }
    }

    printf("\nOptimized Instructions:\n");
    for (i = 0; i < n; i++)
        printf("%c = %s %c %s\n", t[i].op3, t[i].op1, t[i].op, t[i].op2);

    return 0;
}
