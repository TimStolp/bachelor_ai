#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <math.h>

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

struct list {
    struct node* head;
};

struct node {
    struct node* next;
    struct node* prev;
    int val;
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

int main(int argc, char *argv[]) {
    struct config cfg;
    if (parse_options(&cfg, argc, argv) != 0) {
        return 1;
    }

    // SOME CODE MISSING HERE

    while (fgets(buf, BUF_SIZE, stdin)) {
        // Put input in linked list.
        char * token = strtok(buf, " ");
        struct list *l = list_init();
        while (token != NULL) {
            list_add_back(l, list_new_node(atoi(token)));
            token = strtok(NULL, " ");
        }

        // Sort the list.
        struct node* current_s = l->head->next;
        struct node* current_n, *current_r;
        while (current_s != NULL) {
            current_n = current_s->prev;
            while (current_n != NULL) {
                if (current_n->prev == NULL && current_s->val < current_n->val) {
                    current_r = current_s;
                    current_s = current_s->next;
                    list_add_front(l, list_new_node(current_r->val));
                    list_unlink_node(l, current_r);
                    list_free_node(current_r);
                    break;
                }
                if (current_s->val >= current_n->val) {
                    current_r = current_s;
                    current_s = current_s->next;
                    list_insert_after(l, list_new_node(current_r->val), current_n);
                    list_unlink_node(l, current_r);
                    list_free_node(current_r);
                    break;
                }
                current_n = current_n->prev;
            }
        }

        // Print the sorted list.
        struct node* current_p = l->head;
        while (current_p != NULL) {
            fprintf(stdout, "%d\n", current_p->val);
            current_p = current_p->next;
        }
    }

    // SOME CODE MISSING HERE
    
    return 0;
}
