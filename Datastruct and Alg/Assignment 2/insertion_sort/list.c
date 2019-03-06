// Tim Stolp 11848782
//
// Creates doubly linked list API.

#include <stdio.h>
#include <stdlib.h>

#include "list.h"

/* 
 * TODO: A lot of code missing here. You will need to add implementations for
 * all the functions described in list.h here.
 * 
 * Start by adding the definitions for the list and node structs. You may
 * implement any of the Linked List versions discussed in the lecture, which
 * have some different trade-offs for the functions you will need to write. 
 * 
 * Note: The function prototypes in list.h assume the most basic Singly Linked
 * List. If you build some other version, you may not need all of the function
 * arguments for all of the described functions. This will produce a warning,
 * which you can suppress by adding a simple if-statement to check the value
 * of the unused parameter.
 *
 * Also, do not forget to add any required includes at the top of your file.
 */

// Create list structure.
struct list {
    struct node* head;
};

// Create doubly linked node structure.
struct node {
    struct node* next;
    struct node* prev;
    int val;
};

// Initialize list.
struct list* list_init(void) {
    struct list* l = malloc(sizeof(struct list));
    if (l == NULL) {
        return NULL;
    }
    l->head = NULL;
    return l;
}

// Initialize new node.
struct node* list_new_node(int num) {
    struct node* n = malloc(sizeof(struct node));
    if (n == NULL) {
        return NULL;
    }
    n->next = NULL;
    n->prev = NULL;
    n->val = num;
    return n;
}

// Get head of list.
struct node* list_head(struct list* l) {
    if (l == NULL) {
        return NULL;
    }
    return l->head;
}

// Get next node.
struct node* list_next(struct node* n) {
    if (n == NULL) {
        return NULL;
    }
    return n->next;
}

// Add node in front of list.
int list_add_front(struct list* l, struct node* n) {
    if (l == NULL || n == NULL) {
        return 1;
    }
    if (l->head == NULL) {
        l->head = n;
        return 0;
    }
    l->head->prev = n;
    n->next = l->head;
    l->head = n;
    return 0;
}

// Get last node of list.
struct node* list_tail(struct list* l) {
    if (l == NULL) {
        return NULL;
    }
    struct node* current = l->head;
    while (current->next != NULL) {
        current = current->next;
    }
    return current;
}

// Get previous node.
struct node* list_prev(struct list* l, struct node* n) {
    if (n == NULL) {
        return NULL;
    }
    if (l) {

    }
    return n->prev;
}

// Add node to back of list.
int list_add_back(struct list* l, struct node* n) {
    if (l == NULL || n == NULL) {
        return 1;
    }
    if (l->head == NULL) {
        l->head = n;
        return 0;
    }
    struct node* current = l->head;
    while (current->next != NULL) {
        current = current->next;
    }
    n->prev = current;
    current->next = n;
    return 0;
}

// Get node value.
int list_node_value(struct node* n) {
    if (n == NULL) {
        return 0;
    }
    return n->val;
}

// Unlink node from list.
int list_unlink_node(struct list* l, struct node* n) {
    if (l == NULL || n == NULL) {
        return 1;
    }
    if (!list_node_present(l, n)) {
        return 1;
    }
    if (n->next != NULL) {
        n->next->prev = n->prev;
    }
    if (n->prev == NULL) {
        l->head = n->next;
    }
    else {
        n->prev->next = n->next;
    }
    n->prev = NULL;
    n->next = NULL;
    return 0;
}

// Free node memory.
void list_free_node(struct node* n) {
    free(n);
}

// Free all memory of list.
int list_cleanup(struct list* l) {
    if (l == NULL) {
        return 1;
    }
    struct node* n = l->head;
    while (n != NULL) {
        list_unlink_node(l, n);
        list_free_node(n);
        n = l->head;
    }
    free(l);
    return 0;
}

// Check if node is present in list.
int list_node_present(struct list* l, struct node* n) {
    struct node* current = l->head;
    while (current != NULL) {
        if (current == n) {
            return 1;
        }
        current = current->next;
    }
    return 0;
}

// Insert node in list after another node.
int list_insert_after(struct list* l, struct node* n, struct node* m) {
    if (l == NULL || n == NULL || m == NULL) {
        return 1;
    }
    if (list_node_present(l, n) || !list_node_present(l, m)) {
        return 1;
    }
    n->prev = m;
    n->next = m->next;
    if (m->next != NULL) {
        m->next->prev = n;
    }
    m->next = n;
    return 0;
}

// Insert node in list before another node.
int list_insert_before(struct list* l, struct node* n, struct node* m) {
    if (l == NULL || n == NULL || m == NULL) {
        return 1;
    }
    if (list_node_present(l, n) || !list_node_present(l, m)) {
        return 1;
    }
    n->prev = m->prev;
    n->next = m;
    if (m->prev != NULL) {
        m->prev->next = n;
    }
    else {
        l->head = n;
    }
    m->prev = n;
    return 0;
}

// Get list length.
int list_length(struct list* l) {
    if (l == NULL) {
        return 0;
    }
    int len = 0;
    struct node* current = l->head;
    while (current != NULL) {
        len++;
        current = current->next;
    }
    return len;
}

// Get i'th node in list.
struct node* list_get_ith(struct list* l, int i) {
    if (l == NULL) {
        return NULL;
    }
    if (i < 0) {
        return NULL;
    }
    struct node* current = l->head;
    for (int l = 0; l < i; l++) {
        current = current->next;
        if (current == NULL) {
            break;
        }
    }
    return current;
}

// Cut list in 2 halves and return second half.
struct list* list_cut_after(struct list* l, struct node* n) {
    if (l == NULL || n == NULL) {
        return NULL;
    }
    if (!list_node_present(l, n)) {
        return NULL;
    }
    struct list* l2 = list_init();
    l2->head = n->next;
    if (n->next != NULL) {
        n->next->prev = NULL;
        n->next = NULL;
    }
    return l2;
}