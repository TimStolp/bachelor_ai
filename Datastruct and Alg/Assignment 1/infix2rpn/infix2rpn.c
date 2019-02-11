// Tim Stolp 11848782
// This program converts infix notation to reverse polish notation.
// Takes an infix notation string and prints the reverse polish notation.

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "stack.h"

// This function gets the correct precedence of operators.
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
         // '(' returns highest number to correctly allow following operators to be put on the stack.
        case '(':
            return 5;
    }
    return -1;
}

int main(int argc, char *argv[]) {
    // Print error message if wrong amount of arguments given.
    if (argc != 2) {
        printf("usage: %s \"infix_expr\"\n", argv[0]);
        return 1;
    }

    char *input = argv[1];
    struct stack *s = stack_init();
    // Tracks if previous character was a digit.
    bool prev = false;
    // Tracks number of unclosed parentheses.
    int brackets = 0;

    // Loop through input string.
    for (unsigned int i = 0; i < strlen(input); i++) {
        // Continue if character is a space.
        if (input[i] == ' ') {
            continue;
        }
        // Push character onto stack if character is an opening parentheses.
        if (input[i] == '(') {
            brackets++;
            stack_push(s, input[i]);
            continue;
        }
        // Check if character is a closing parentheses.
        if (input[i] == ')') {
            // Return error if there are no unclosed parentheses.
            if (!brackets) {
                stack_cleanup(s);
                return 1;
            }
            // Print stack until opening parenthesis.
            while (true) {
                int current = stack_pop(s);
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
        // Return error if input contains letters.
        if (isalpha(input[i])) {
            stack_cleanup(s);
            return 1;
        }
        // Print character if character is a digit.
        if (isdigit(input[i])) {
            prev = true;
            fprintf(stdout, "%c", input[i]);
        }
        else {
            // Return error if character is not a valid operator.
            if (prec(input[i]) < 0) {
                stack_cleanup(s);
                return 1;
            }
            // Print space if previous character was a digit for accurate spacing.
            if (prev) {
                fprintf(stdout, " ");
                prev = false;
            }
            // Print the stack's top character if stack is not empty
            // and the stack's top operator's precedence does not allow
            // the current character to be pushed on top.
            while (!stack_empty(s) && ((prec(input[i]) > prec((char) stack_peek(s))) ||
                   (prec(input[i]) >= prec((char) stack_peek(s)) && prec(input[i]) > 2))) {
                fprintf(stdout, "%c ", stack_pop(s));
            }
            // Push character on top of stack.
            stack_push(s, input[i]);
        }
    }
    // Check if there are any unclosed parentheses.
    if (brackets > 0) {
        stack_cleanup(s);
        return 1;
    }
    // Print out remaining stack.
    while (!stack_empty(s)) {
        fprintf(stdout, " %c", stack_pop(s));
    }
    fprintf(stdout, "\n");
    // Free memory.
    stack_cleanup(s);
    return 0;
}
