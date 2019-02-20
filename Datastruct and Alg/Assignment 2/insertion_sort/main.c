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


struct list* insertion_sort(struct list* l, struct config cfg) {
    if (list_length(l) < 2) {
        return l;
    }
    struct node* current_s = list_next(list_head(l));
    struct node* current_n, *current_r;
    int int_one, int_two, int_three;
    // Go through all nodes (each node called current_s).
    while (current_s != NULL) {
        current_n = list_prev(l, current_s);
        // Go backwards through all nodes left of current node (each node called current_n).
        while (current_n != NULL) {
            // Swap places of values of s and n in comparisons to sort list in descending order.
            if (cfg.descending_order) {
                int_one = list_node_value(current_n);
                int_two = list_node_value(current_s);
            }
            else {
                int_one = list_node_value(current_s);
                int_two = list_node_value(current_n);
            }
            // Check if values n and s are the same and remove s if so and if -u argument was passed.
            if (cfg.unique_values && int_one == int_two) {
                current_r = current_s;
                current_s = list_next(current_s);
                list_unlink_node(l, current_r);
                list_free_node(current_r);
                break;
            }
            // If end of list is reached check if s node has to be placed in front of list.
            if (list_prev(l, current_n) == NULL && int_one < int_two) {
                current_r = current_s;
                current_s = list_next(current_s);
                list_unlink_node(l, current_r);
                list_add_front(l, current_r);
                break;
            }
            // Insert s in correct place.
            if (int_one >= int_two) {
                current_r = current_s;
                current_s = list_next(current_s);
                list_unlink_node(l, current_r);
                list_insert_after(l, current_r, current_n);
                break;
            }
            current_n = list_prev(l, current_n);
        }
    }
    return l;
}

// Add intermediate numbers between each 2 numbers in list.
struct list* intermediate(struct list* l) {
    struct node* current;
    float num;
    current = list_head(l);
    while (list_next(current) != NULL) {
        num = (float)(list_node_value(current) + list_node_value(list_next(current)))/2;
        list_insert_after(l, list_new_node((int)round(num)), current);
        current = list_next(list_next(current));
    }
    return l;
}

// Split list in 2 and zip back together alternating between the 2 halves.
struct list* zip(struct list* l) {
    int len = list_length(l);
    struct list* l2;
    // Split l in 2 lists
    l2 = list_cut_after(l, list_get_ith(l, (int) round((float) len/2)));
    struct node* current_r1, *current_r2;
    struct node* current_1 = list_head(l);
    struct node* current_2 = list_head(l2);
    struct list* zip_list = list_init();
    while (current_2 != NULL) {
        // Add nodes of the 2 lists to a new list, alternating between the 2 lists.
        current_r1 = current_1;
        current_r2 = current_2;
        current_1 = list_next(current_1);
        current_2 = list_next(current_2);
        list_unlink_node(l, current_r1);
        list_add_back(zip_list, current_r1);
        list_unlink_node(l2, current_r2);
        list_add_back(zip_list, current_r2);
    }
    // Add last node of first half of list if halves are unequal length.
    if (len % 2 != 0) {
        list_unlink_node(l, current_1);
        list_add_back(zip_list, current_1);
    }
    list_cleanup(l2);
    list_cleanup(l);
    return zip_list;
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
    l = insertion_sort(l, cfg);

    // Add intermediate numbers if argument is set.
    if (cfg.insert_intermediate) {
        l = intermediate(l);
    }

    // Split list in 2 and zip them together.
    if (cfg.zip_alternating) {
        l = zip(l);
    }

    // Print the sorted list.
    print_list(l);

    // Free memory.
    list_cleanup(l);
    return 0;
}
