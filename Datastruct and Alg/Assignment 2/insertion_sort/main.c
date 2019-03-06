// Tim Stolp 11848782
//
// Performs insertion sort on linked list.
// Prints sorted list and returns 0 if succeeded, returns 1 if failed.
// Add -d for descending sort.
// Add -u to remove unique values.
// Add -i to add intermediate numbers.
// Add -z to split lists in 2 and add them back together alternating between each half.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <math.h>
#include <ctype.h>

#include "list.h"
#define BUF_SIZE 1024

static char buf[BUF_SIZE];

struct config {
    // You can ignore these options until you implement the
    // extra command-line arguments.

    // Set to 1 if -u is specified, 0 otherwise.
    int unique_values;

    // Set to 1 if -d is specified, 0 otherwise.
    int descending_order;

    // Set to 1 if -i is specified, 0 otherwise.
    int insert_intermediate;

    // Set to 1 if -z is specified, 0 otherwise.
    int zip_alternating;
};

int parse_options(struct config *cfg, int argc, char *argv[]) {
    memset(cfg, 0, sizeof(struct config));
    int c;
    while ((c = getopt (argc, argv, "udiz")) != -1) {
        switch (c) {
            case 'u': cfg->unique_values = 1; break;
            case 'd': cfg->descending_order = 1; break;
            case 'i': cfg->insert_intermediate = 1; break;
            case 'z': cfg->zip_alternating = 1; break;
            default:
                      fprintf(stderr, "invalid option: -%c\n", optopt);
                      return 1;
        }
    }
    return 0;
}

// Read input and put input in a linked list.
struct list* input_to_list(struct list* l) {
    unsigned long int buf_end;
    while (fgets(buf, BUF_SIZE, stdin)) {
        // Remove trailing whitespaces.
        buf_end = strlen(buf) - 1;
        while (isspace(buf[buf_end])) {
            buf[buf_end] = '\0';
        }
        // Check for invalid input.
        for (unsigned int i = 0; i < strlen(buf); i++) {
            if (!isdigit(buf[i]) && !isspace(buf[i]) && !(buf[i] == '-' && isdigit(buf[i+1]))) {
                list_cleanup(l);
                fprintf(stderr, "invalid input");
                return NULL;
            }
        }
        // Put input in linked list.
        char * token = strtok(buf, " ");
        while (token != NULL) {
            list_add_back(l, list_new_node(atoi(token)));
            token = strtok(NULL, " ");
        }
    }
    return l;
}

// Print the linked list.
int print_list(struct list* l) {
    if (l == NULL) {
        return 1;
    }
    // Go through each node and print its value.
    struct node* current = list_head(l);
    while (current != NULL) {
        fprintf(stdout, "%d\n", list_node_value(current));
        current = list_next(current);
    }
    return 0;
}

// Helper function for insertion sort.
// Compares two ints, switching operator around if sorting descending.
int compare(int one, int two, int equals, struct config cfg) {
    if (equals) {
        if (cfg.descending_order) {
            return one <= two;
        }
        return one >= two;
    }
    if (cfg.descending_order) {
        return one > two;
    }
    return one < two;
}

// Sort list using insertion sort.
// Possible to remove duplicate values.
// Possible to sort descending.
int insertion_sort(struct list* l, struct config cfg) {
    if (list_length(l) < 2) {
        return 1;
    }
    struct node* current_s = list_next(list_head(l));
    struct node* current_n, *current_r;
    // Go through all nodes (each node called current_s).
    while (current_s != NULL) {
        current_n = list_prev(l, current_s);
        // Go backwards through all nodes left of current node (each node called current_n).
        while (current_n != NULL) {
            // Check if values n and s are the same and remove s if so and if -u argument was passed.
            if (cfg.unique_values && list_node_value(current_s) == list_node_value(current_n)) {
                current_r = current_s;
                current_s = list_next(current_s);
                list_unlink_node(l, current_r);
                list_free_node(current_r);
                break;
            }
            // if s has to be moved insert s in correct place.
            if (compare(list_node_value(current_n), list_node_value(current_s), 1, cfg) &&
                (list_prev(l, current_n) == NULL ||
                compare(list_node_value(list_prev(l, current_n)), list_node_value(current_s), 0, cfg))) {
                current_r = current_s;
                current_s = list_next(current_s);
                list_unlink_node(l, current_r);
                list_insert_before(l, current_r, current_n);
                break;
            }
            // Update s if no moving needs to be done.
            if (list_prev(l, current_n) == NULL) {
                current_s = list_next(current_s);
            }
            current_n = list_prev(l, current_n);
        }
    }
    return 0;
}

// Add intermediate numbers between each 2 numbers in list.
int intermediate(struct list* l) {
    if (l == NULL) {
        return 1;
    }
    struct node* current;
    float num;
    current = list_head(l);
    while (list_next(current) != NULL) {
        num = (float)(list_node_value(current) + list_node_value(list_next(current)))/2;
        list_insert_after(l, list_new_node((int)round(num)), current);
        current = list_next(list_next(current));
    }
    return 0;
}

// Split list in 2 and zips back together.
int zip(struct list* l) {
    if (l == NULL) {
        return 1;
    }
    int len = list_length(l);
    struct list *l2;
    // Split l in 2 lists
    l2 = list_cut_after(l, list_get_ith(l, (int) round((float) (len - 2) / 2)));
    struct node* node, *current = list_head(l);
    while (current != NULL) {
        node = list_head(l2);
        list_unlink_node(l2, node);
        list_insert_after(l, node, current);
        current = list_next(list_next(current));
    }
    list_cleanup(l2);
    return 0;
}


int main(int argc, char *argv[]) {
    struct config cfg;
    if (parse_options(&cfg, argc, argv) != 0) {
        return 1;
    }
    // Initialize list.
    struct list* l = list_init();

    // Get input and put it in a linked list.
    l = input_to_list(l);
    // Return error code if invalid input.
    if (l == NULL) {
        return 1;
    }

    // Sort the list using insertion sort.
    insertion_sort(l, cfg);

    // Add intermediate numbers if argument is set.
    if (cfg.insert_intermediate) {
        intermediate(l);
    }

    // Split list in 2 and zip them together.
    if (cfg.zip_alternating) {
        zip(l);
    }

    // Print the sorted list.
    print_list(l);

    // Free memory.
    list_cleanup(l);
    return 0;
}
