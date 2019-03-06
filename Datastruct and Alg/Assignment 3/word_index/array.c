// Tim Stolp 11848782
//
// Create resizable integer array structure with standard functions.

#include <stdlib.h>

#include "array.h"

struct array {
    unsigned long max_size;
    unsigned long size;
    int *stack;
};

// Initialize resizable array.
struct array* array_init(unsigned long initial_capacity) {
    struct array *a = malloc(sizeof(struct array));
    if (!a || !initial_capacity) {
        return NULL;
    }
    a->max_size = initial_capacity;
    a->size = 0;
    a->stack = malloc(initial_capacity * sizeof(int));
    if (!a->stack) {
        return NULL;
    }
    return a;
}

// Free memory of resizable array.
void array_cleanup(struct array* a) {
    if (a) {
        free(a->stack);
        free(a);
    }
}

// Get integer of specific index in array.
int array_get(struct array *a, unsigned long index) {
    if (!a || index > a->size) {
        return -1;
    }
    return a->stack[index];
}

// Add element to the end of the array.
int array_append(struct array *a, int elem) {
    if (!a) {
        return 1;
    }
    if (a->size == a->max_size) {
        a->stack = realloc(a->stack, a->max_size * 2 * sizeof(int));
        a->max_size = a->max_size*2;
    }
    a->stack[a->size++] = elem;
    return 0;
}

// Get array size.
unsigned long array_size(struct array *a) {
    if (!a) {
        return 0;
    }
    return a->size;
}
