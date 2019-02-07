#include <stdlib.h>

#include "stack.h"

struct stack {
    // ... SOME CODE MISSING HERE ...
};

struct stack *stack_init() {
    struct stack *s = malloc(sizeof(struct stack));

    // ... SOME CODE MISSING HERE ...

    return s;
}

void stack_cleanup(struct stack *s) {

    // ... SOME CODE MISSING HERE ...

    free(s);
}

int stack_push(struct stack *s, int c) {

    // ... SOME CODE MISSING HERE ...

    return 0;
}

int stack_pop(struct stack *s) {

    // ... SOME CODE MISSING HERE ...

    return 0;
}

int stack_peek(struct stack *s) {

    // ... SOME CODE MISSING HERE ...

    return 0;
}

int stack_empty(struct stack *s) {

    // ... SOME CODE MISSING HERE ...

    return 0;
}
