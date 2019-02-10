#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "stack.h"

int prec(char x) {
    switch (x) {
        case '~':
            return 1;
        case '^':
            return 2;
        case '*':
        case '/':
            return 3;
        case '+':
        case '-':
            return 4;
        case '(':
            return 5;
    }
    return -1;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("usage: %s \"infix_expr\"\n", argv[0]);
        return 1;
    }

    char *input = argv[1];
    struct stack *s = stack_init();

    bool prev = false;
    int brackets = 0;
    for (unsigned int i = 0; i < strlen(input); i++) {
        if (input[i] == ' ') {
            continue;
        }
        if (input[i] == '(') {
            brackets++;
            stack_push(s, input[i]);
            continue;
        }
        if (input[i] == ')') {
            if (!brackets) {
                stack_cleanup(s);
                return 1;
            }
            while (true) {
                int current =stack_pop(s);
                if (current == '(') {
                    brackets--;
                    break;
                }
                else {
                    fprintf(stdout, " %c", current);
                }
            }
            continue;
        }
        if (isalpha(input[i])) {
            stack_cleanup(s);
            return 1;
        }
        if (isdigit(input[i])) {
            prev = true;
            fprintf(stdout, "%c", input[i]);
        }
        else {
            if (prev) {
                fprintf(stdout, " ");
                prev = false;
            }
            if (prec(input[i]) < 0) {
                stack_cleanup(s);
                return 1;
            }
            if (prec(input[i]) > 2) {
                while (!stack_empty(s) && (prec(input[i]) >= prec((char) stack_peek(s)))) {
                    fprintf(stdout, "%c ", stack_pop(s));
                }
            }
            else {
                while (!stack_empty(s) && (prec(input[i]) > prec((char) stack_peek(s)))) {
                    fprintf(stdout, "%c ", stack_pop(s));
                }
            }
            stack_push(s, input[i]);
        }
    }
    while (!stack_empty(s)) {
        int stack_current = stack_pop(s);
        if (stack_current == '(') {
            stack_cleanup(s);
            return 1;
        }
        fprintf(stdout, " %c", stack_current);
    }
    fprintf(stdout, "\n");
    stack_cleanup(s);
    return 0;
}
