
/* Do not edit this function, as it used in testing too
 * Add you own hash functions with different headers instead. */
unsigned long hash_too_simple(unsigned char *str) {
    return (unsigned long) *str;
}

// Source: www.cse.yorku.ca/~oz/hash.html
unsigned long djb2(unsigned char *key) {
    unsigned long hash = 5381;
    unsigned long c;
    while ((c = *key++)) {
        hash = ((hash << 5) + hash) + c;
    }
    return hash;
}

// Source: www.cse.yorku.ca/~oz/hash.html
unsigned long sdbm(unsigned char *key) {
    unsigned long hash = 5381;
    unsigned long c;
    while ((c = *key++)) {
        hash = c + (hash << 6) + (hash << 16) - hash;
    }
    return hash;
}
