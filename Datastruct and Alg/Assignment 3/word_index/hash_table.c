// Tim Stolp 11848782
//
// Creates hash table structure for resizable integer arrays with standard functions.

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "hash_table.h"
#include "array.h"

struct table {
    // The (simple) array used to index the table
    struct node **array;
    // The function used for computing the hash values in this table
    unsigned long (*hash_func)(unsigned char *);

    // Maximum load factor after which the table array should be resized
    double max_load;
    // Capacity of the array used to index the table
    unsigned long capacity;
    // Current number of elements stored in the table
    unsigned long load;
};

struct node {
    // The string of characters that is the key for this node
    char *key;
    // A resizing array, containing the all the integer values for this key
    struct array *value;

    // Next pointer
    struct node *next;
};

// Initialize a node of a hash table.
struct node *node_init(char *key, struct array *value) {
    struct node *n = malloc(sizeof(struct node));
    if (!n) {
        return NULL;
    }
    n->key = malloc((strlen(key)+1)*sizeof(char));
    if (!n->key) {
        return NULL;
    }
    strcpy(n->key, key);
    n->value = value;
    n->next = NULL;
    return n;
}

// Initialize a hash table.
struct table *table_init(unsigned long capacity, double max_load,
                            unsigned long (*hash_func)(unsigned char *)) {
    if (!capacity || max_load > 1 || max_load <= 0) {
        return NULL;
    }
    struct table *t = malloc(sizeof(struct table));
    if (!t) {
        return NULL;
    }
    t->array = calloc(capacity, sizeof(struct node *));
    if (!t->array) {
        return NULL;
    }
    t->hash_func = (*hash_func);
    t->max_load = max_load;
    t->capacity = capacity;
    t->load = 0;
    return t;
}

// Doubles hash table size when max load is exceeded.
int table_resize(struct table *t) {
    if (!t) {
        return 1;
    }
    struct node **old_array = t->array;

    unsigned long old_capacity = t->capacity;
    t->capacity = t->capacity * 2;

    t->array = calloc(t->capacity, sizeof(struct node *));
    if (!t->array) {
        return 1;
    }

    t->load = 0;
    // Re-hash each word in old hash table and insert into new table.
    for (unsigned int i = 0; i < old_capacity; i++) {

        struct node *current = old_array[i];
        struct node *next;
        while (current) {
            char *hash_key = current->key;
            unsigned long new_index = t->hash_func((unsigned char *) hash_key) % t->capacity;
            struct node *current2 = t->array[new_index];

            struct node *next = current->next;
            current->next = NULL;
            // If index in new array already contains nodes, chain the new node to the other nodes.
            if (!current2) {
                t->array[new_index] = current;
                t->load++;
            }
            else {
                struct node *previous;
                while (current2) {
                    previous = current2;
                    current2 = current2->next;
                }
                previous->next = current;
            }
            current = next;
        }
    }
    free(old_array);
    return 0;
}

// Inserts value to the array of the given key.
int table_insert(struct table *t, char *key, int value) {
    if (!t || !key) {
        return 1;
    }
    // Increase hash table size if necessary.
    if ((double) t->load / (double) t->capacity > t->max_load) {
        if (table_resize(t)) {
            return 1;
        }
    }

    // Calculate index from key using hash function and places new node in hash table at index.
    char *hash_key = key;
    unsigned long hash_index = t->hash_func((unsigned char *) hash_key) % t->capacity;
    struct node *current = t->array[hash_index];
    if (!current) {
        struct array *a = array_init(10);
        struct node *n = node_init(key, a);
        array_append(n->value, value);
        t->array[hash_index] = n;
        t->load++;
        return 0;
    }
    // If there are already nodes on the index go through nodes.
    struct node *previous;
    while (current) {
        // If key already present add value to array of that key.
        if (!strcmp(current->key, key)) {
            array_append(current->value, value);
            return 0;
        }
        previous = current;
        current = current->next;
    }
    // If key not present add new node at the end of the chain.
    struct array *a = array_init(1);
    struct node *n = node_init(key, a);
    array_append(n->value, value);
    previous->next = n;
    return 0;
}

// Get value of key in hash table.
struct array *table_lookup(struct table *t, char *key) {
    if (!t || !key) {
        return NULL;
    }

    char *hash_key = key;
    unsigned long hash_index = t->hash_func((unsigned char *) hash_key) % t->capacity;
    struct node *current = t->array[hash_index];

    while (current) {
        if (!strcmp(current->key, key)) {
            return current->value;
        }
        current = current->next;
    }
    return NULL;
}

// Free memory of node.
void node_cleanup(struct node *n) {
    if (n) {
        array_cleanup(n->value);
        free(n->key);
        free(n);
    }
}

// Free memory of hash table.
void table_cleanup(struct table *t) {
    if (t) {
        for (unsigned int i = 0; i < t->capacity; i++) {
            struct node *current = t->array[i];
            struct node *next;
            while (current) {
                next = current->next;
                node_cleanup(current);
                current = next;
            }
        }
        free(t->array);
        free(t);
    }
}

// Remove key with its value from hash table.
int table_delete(struct table *t, char *key) {
    if (!t || !key) {
        return 1;
    }

    char *hash_key = key;
    unsigned long hash_index = t->hash_func((unsigned char *) hash_key) % t->capacity;
    struct node *current = t->array[hash_index];
    struct node *previous = NULL;

    while (current) {
        if (!strcmp(current->key, key)) {
            if (previous) {
                previous->next = current->next;
                node_cleanup(current);
                return 0;
            }
            t->array[hash_index] = current->next;
            node_cleanup(current);
            t->load--;
            return 0;
        }
        previous = current;
        current = current->next;
    }
    return 1;
}
