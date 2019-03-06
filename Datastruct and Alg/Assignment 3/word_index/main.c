// Tim Stolp 11848782
//
// Creates lookup table containing all line indexes of each word in a text.
// Asks for a word as input and returns its line indexes.

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <time.h>

#include "hash_table.h"
#include "hash_func.h"
#include "array.h"

#define LINE_LENGTH 256

// These parameters seem to give the best average result when looking at both text files.
#define TABLE_START_SIZE 1000
#define MAX_LOAD_FACTOR 0.8
#define HASH_FUNCTION djb2

#define START_TESTS 5
#define MAX_TESTS 5
#define HASH_TESTS 3

// Changes string to lowercase characters and turns non-alpha characters into spaces.
char *process_input(char *line) {
    unsigned int i = 0;
    while(line[i]) {
        if (!isalpha(line[i])) {
            line[i] = ' ';
        }
        else {
            line[i] = (char) tolower(line[i]);
        }
        i++;
    }
    return line;
}

/* Creates a hash table with word index for the specified file and parameters */
struct table *create_from_file(char *filename, unsigned long start_size,
                double max_load, unsigned long (*hash_func)(unsigned char *)) {
    FILE *fp = fopen(filename, "r");
    if (fp == NULL)
        exit(1);

    char *line = malloc((LINE_LENGTH + 1) * sizeof(char));
    
    struct table *hash_table; 
    hash_table = table_init(start_size, max_load, hash_func);

    int line_number = 1;
    // Reads line from input, tokenizes line, and inserts tokens with line index into hash table.
    while (fgets(line, LINE_LENGTH, fp)) {
        process_input(line);

        char *token = strtok(line, " ");
        while (token) {
            table_insert(hash_table, token, line_number);
            token = strtok(NULL, " ");
        }
        line_number++;
    }
    fclose(fp);
    free(line);

    return hash_table;
}

/* Reads words from stdin and prints line lookup results per word. */
void stdin_lookup(struct table *hash_table) {
    char *line = malloc((LINE_LENGTH + 1) * sizeof(char));

    // Reads line, takes first word of line and looks up and prints the line indexes where the word occurred in the text.
    while (fgets(line, LINE_LENGTH, stdin)) {
        process_input(line);
        char *token = strtok(line, " ");
        if (!token) {
            continue;
        }

        struct array *a = table_lookup(hash_table, token);

        fprintf(stdout, "%s\n", token);
        for (unsigned int i = 0; i < array_size(a); i++){
            fprintf(stdout, "* %d\n", array_get(a, i));
        }
        fprintf(stdout, "\n");
    }
    free(line);
}

void timed_construction(char *filename) {
    /* Here you can edit the hash table testing parameters: Starting size,
     * maximum load factor and hash function used, and see the the effect
     * on the time it takes to build the table.
     * You can edit the tested values in the 3 arrays below. If you change
     * the number of elements in the array, change the defined constants
     * at the top of the file too, to change the size of the arrays. */
    unsigned long start_sizes[START_TESTS] = {2, 100, 1000, 10000, 65536};
    double max_loads[MAX_TESTS] = {0.2, 0.4, 0.6, 0.8, 1.0};
    unsigned long (*hash_funcs[HASH_TESTS])(unsigned char *) = {hash_too_simple, djb2, sdbm};

    for (int i = 0; i < START_TESTS; i++) {
        for (int j = 0; j < MAX_TESTS; j++) {
            for (int k = 0 ; k < HASH_TESTS; k++) { 
                clock_t start = clock();
                struct table *hash_table = create_from_file(filename,
                        start_sizes[i], max_loads[j], hash_funcs[k]);
                clock_t end = clock();

                printf("Start: %ld\tMax: %.1f\tHash: %d\t -> Time: %ld microsecs\n",
                        start_sizes[i], max_loads[j], k, end - start);
                table_cleanup(hash_table);
            }
        }
    }
}


int main(int argc, char *argv[])
{
    if (argc < 2)
        return 1;
    
    if (argc == 3 && !strcmp(argv[2], "-t")) {
        timed_construction(argv[1]);
    } else {
        struct table *hash_table = create_from_file(argv[1], TABLE_START_SIZE,
                MAX_LOAD_FACTOR, HASH_FUNCTION);

        stdin_lookup(hash_table);
        table_cleanup(hash_table);
    }

    return 0;
}
