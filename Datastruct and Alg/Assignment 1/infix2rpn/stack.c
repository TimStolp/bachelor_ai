// Tim Stolp 11848782
// This program creates a stack structure with functions handle the stack.

#include <stdlib.h>
#include <stdio.h>

#include "stack.h"

// Create stack structure.
struct stack {
    int stack[STACK_SIZE];
    int size;
    int num_push;
    int num_pop;
    int max_size;
};

// Initialize stack with starting values and return pointer to stack or NULL memory allocation failed.
struct stack *stack_init() {
    struct stack *s = malloc(sizeof(struct stack));
    if (s == NULL) {
        return NULL;
    }
    s->size = 0;
    s->num_pop = 0;
    s->num_push = 0;
    s->max_size = 0;
    return s;
}

// Print stats stderr and free memory.
void stack_cleanup(struct stack *s) {
    fprintf(stderr, "stats %d %d %d\n", s->num_push, s->num_pop, s->max_size);
    free(s);
}

// Push int on top of stack if stack is not full
int stack_push(struct stack *s, int c) {
    if (s == NULL || s->size == STACK_SIZE) {
        return 1;
    }
    if (s->size < STACK_SIZE) {
        s->stack[s->size++] = c;
        if (s->size > s->max_size) {
            s->max_size = s->size;
        }
        s->num_push++;
        return 0;
    }
    return 1;
}

// Remove top int from stack and return that int.
int stack_pop(struct stack *s) {
    if (s == NULL || s->size == 0) {
        return -1;
    }
    s->size--;
    s->num_pop++;
    return s->stack[s->size];
}

// Return top int of stack without removing from stack.
int stack_peek(struct stack *s) {
    if (s == NULL || s->size == 0) {
        return -1;
    }
    return s->stack[s->size-1];
}

// Return 0 if stack is empty, return 1 if stack contains elements, return -1 if failed.
int stack_empty(struct stack *s) {
    if (s == NULL) {
        return -1;
    }
    if (s->size == 0) {
        return 1;
    }
    if (s->size > 0) {
        return 0;
    }
    return -1;
}
