#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <check.h>

#include "list.h"

// For older versions of the check library
#ifndef ck_assert_ptr_nonnull
#define ck_assert_ptr_nonnull(X) _ck_assert_ptr(X, !=,NULL)
#endif
#ifndef ck_assert_ptr_null
#define ck_assert_ptr_null(X) _ck_assert_ptr(X, ==,NULL);
#endif

#define LEN 10

/* test init & cleanup */
START_TEST (test_list_init)
{
    struct list* l = list_init();
    ck_assert_ptr_nonnull(l);
    list_cleanup(l);
}
END_TEST

/* test add & head */
START_TEST (test_add_front)
{
    struct list* l = list_init();
    
    struct node* n = list_new_node(5);
    ck_assert_ptr_nonnull(n);  
    ck_assert_int_eq(list_add_front(l, n), 0);
    
    struct node* m = list_head(l); 
    ck_assert_ptr_eq(m, n);
    
    list_cleanup(l);
}
END_TEST

/* test add multiple & next */
START_TEST (test_next_multiple)
{
    struct list* l = list_init();    
    struct node* n;
    
    for (int i = 0; i < LEN; i++) {
        n = list_new_node(i);
        ck_assert_int_eq(list_add_front(l, n), 0);
    }
    
    struct node* m = list_head(l);
    ck_assert_ptr_eq(m, n);

    for (int i = 0; i < LEN-1; i++) {
        n = list_next(m);
        ck_assert_ptr_nonnull(n);
        ck_assert_ptr_ne(m, n); 
        
        m = n;
    }
    
    ck_assert_ptr_null(list_next(m));
    list_cleanup(l);
}
END_TEST

/* test append & tail */
START_TEST (test_add_back)
{
    struct list* l = list_init();
    
    struct node* n = list_new_node(5);
    ck_assert_ptr_nonnull(n);  
    ck_assert_int_eq(list_add_back(l, n), 0);
    
    struct node* m = list_tail(l); 
    ck_assert_ptr_eq(m, n);
    
    list_cleanup(l);
}
END_TEST

/* test append multiple & prev */
START_TEST (test_prev_multiple)
{
    struct list* l = list_init();    
    struct node* n;
    
    for (int i = 0; i < LEN; i++) {
        n = list_new_node(i);
        ck_assert_int_eq(list_add_back(l, n), 0);
    }
    
    struct node* m = list_tail(l);
    ck_assert_ptr_eq(m, n);

    for (int i = 0; i < LEN-1; i++) {
        n = list_prev(l, m);
        ck_assert_ptr_nonnull(n);
        ck_assert_ptr_ne(m, n); 
        
        m = n;
    }
    
    ck_assert_ptr_null(list_prev(l, m));
    list_cleanup(l);
}
END_TEST

/* test node value */
START_TEST (test_node_value)
{
    struct list* l = list_init();
    struct node* n = list_new_node(123);
    
    ck_assert_int_eq(list_node_value(n), 123);
    list_add_front(l, n);
    ck_assert_int_eq(list_node_value(list_head(l)), 123);
    
    list_cleanup(l);
}
END_TEST

/* test value multiple */
START_TEST (test_value_multiple)
{
    struct list* l = list_init();
    struct node* n;
    
    for (int i = LEN-1; i >= 0; i--) { 
        n = list_new_node(i);
        list_add_front(l, n);

        n = list_new_node(i);
        list_add_front(l, n);
    }

    n = list_head(l);
    for (int i = 0; i < LEN; i++) { 
        ck_assert_int_eq(list_node_value(n), i);
        n = list_next(n);
        
        ck_assert_int_eq(list_node_value(n), i);
        n = list_next(n);
    }
    
    n = list_tail(l);
    for (int i = LEN-1; i >= 0; i--) { 
        ck_assert_int_eq(list_node_value(n), i);
        n = list_prev(l, n);
        
        ck_assert_int_eq(list_node_value(n), i);
        n = list_prev(l, n);
    }

    list_cleanup(l);
}
END_TEST

/* test unlink head */
START_TEST (test_unlink_head)
{
    struct list* l = list_init();
    struct node* n;
    
    for (int i = 0; i < LEN; i++) { 
        n = list_new_node(i);
        list_add_front(l, n);
    }
    
    for (int i = 0; i < LEN; i++) { 
        n = list_head(l);
        ck_assert_int_eq(list_unlink_node(l, n), 0);
        list_free_node(n);
    }

    ck_assert_ptr_null(list_head(l));
    list_cleanup(l);
}
END_TEST

/* test unlink any */
START_TEST (test_unlink_multiple)
{
    struct list* l = list_init();
    struct node* n;
    struct node* m;
    
    for (int i = 0; i < LEN; i++) { 
        n = list_new_node(i);
        list_add_back(l, n);
    }
    
    n = list_next(list_head(l));
    for (int i = 1; i < LEN; i+=2) { 
        m = list_next(list_next(n));
        ck_assert_int_eq(list_unlink_node(l, n), 0);
        ck_assert_int_eq(list_node_value(n), i);
        
        list_free_node(n);
        n = m;
    }
    
    n = list_head(l);
    for (int i = 0; i < LEN; i+=2) {
        m = list_next(n);
        ck_assert_int_eq(list_unlink_node(l, n), 0);
        ck_assert_int_eq(list_node_value(n), i);
        
        list_free_node(n);
        n = m;
    }

    ck_assert_ptr_null(list_head(l));
    list_cleanup(l);
}
END_TEST

/* test list cleanup */
START_TEST (test_list_cleanup)
{
    struct list* l = list_init();
    struct node* n;
    
    for (int i = 0; i < LEN; i++) { 
        n = list_new_node(i);
        list_add_front(l, n);
    }
    
    ck_assert_int_eq(list_cleanup(l),0);
}
END_TEST

// ###################### ADDED TESTS #########################
/* test node present */
START_TEST (test_node_present)
{
    struct list* l = list_init();
    struct node* n;
    struct node* m;
    struct node* t;
    struct node* r = list_new_node(20);

    for (int i = 0; i< LEN; i++) {
        n = list_new_node(i);
        list_add_front(l, n);
    }

    m = list_next(list_next(list_next(list_head(l))));
    t = list_next(list_next(list_next(list_next(list_next(list_next(list_head(l)))))));

    ck_assert_int_eq(list_node_present(l, m), 1);
    ck_assert_int_eq(list_node_present(l, t), 1);
    ck_assert_int_eq(list_node_present(l, r), 0);
    list_free_node(r);
    list_cleanup(l);
}
END_TEST

/* test multiple insert after */
START_TEST (test_insert_after)
{
    struct list* l = list_init();
    struct node* n;
    struct node* r;
    struct node* t;
    struct node* m = list_new_node(18);
    struct node* p = list_new_node(14);
    struct node* q = list_new_node(14);
    struct node* new_tail = list_new_node(16);

    for (int i = 0; i< LEN; i++) {
        n = list_new_node(i);
        list_add_back(l, n);
    }

    // initialize node to be inserted after in list; has value 6
    r = list_next(list_next(list_next(list_next(list_next(list_next(list_head(l)))))));
    t = list_next(list_next(list_next(list_head(l))));

    ck_assert_int_eq(list_insert_after(l, p, m), 1);
    ck_assert_int_eq(list_insert_after(l, p, r), 0);
    ck_assert_int_eq(list_insert_after(l, q, t), 0);
    ck_assert_int_eq(list_insert_after(l, p, list_tail(l)), 1);
    ck_assert_int_eq(list_insert_after(l, new_tail, list_tail(l)), 0);

    ck_assert_int_eq(list_node_value(p), 14);
    ck_assert_int_eq(list_node_value(p), list_node_value(q));
    ck_assert_int_eq(list_node_value(list_tail(l)), 16);

    ck_assert_int_eq(list_node_value(list_prev(l, p)), 6);
    ck_assert_int_eq(list_node_value(list_next(p)), 7);

    ck_assert_int_eq(list_node_value(list_prev(l, q)), 3);
    ck_assert_int_eq(list_node_value(list_next(q)), 4);

    list_free_node(m);
    list_cleanup(l);
}
END_TEST

/* test multiple insert before */
START_TEST (test_insert_before)
{
    struct list* l = list_init();
    struct node* n;
    struct node* r;
    struct node* t;
    struct node* m = list_new_node(18);
    struct node* p = list_new_node(14);
    struct node* q = list_new_node(14);
    struct node* new_head = list_new_node(16);

    for (int i = 0; i< LEN; i++) {
        n = list_new_node(i);
        list_add_back(l, n);
    }

    // initialize node to be inserted before in list; has value 6
    r = list_next(list_next(list_next(list_next(list_next(list_next(list_head(l)))))));
    t = list_next(list_next(list_next(list_head(l))));

    ck_assert_int_eq(list_insert_before(l, p, m), 1);
    ck_assert_int_eq(list_insert_before(l, p, r), 0);
    ck_assert_int_eq(list_insert_before(l, q, t), 0);
    ck_assert_int_eq(list_insert_before(l, p, list_head(l)), 1);
    ck_assert_int_eq(list_insert_before(l, new_head, list_head(l)), 0);

    ck_assert_int_eq(list_node_value(p), 14);
    ck_assert_int_eq(list_node_value(p), list_node_value(q));
    ck_assert_int_eq(list_node_value(list_head(l)), 16);

    ck_assert_int_eq(list_node_value(list_prev(l, p)), 5);
    ck_assert_int_eq(list_node_value(list_next(p)), 6);

    ck_assert_int_eq(list_node_value(list_prev(l, q)), 2);
    ck_assert_int_eq(list_node_value(list_next(q)), 3);

    list_free_node(m);
    list_cleanup(l);

}
END_TEST

/* test length after operations */
START_TEST (test_list_length)
{
    struct list* l = list_init();
    struct node* n;
    struct node* r;
    struct node* m;
    struct node* p = list_new_node(14);
    struct node* q = list_new_node(16);

    for (int i = 0; i< LEN; i++) {
        n = list_new_node(i);
        list_add_back(l, n);
    }

    ck_assert_int_eq(list_length(l), 10);

    // node to be inserted before/after
    r = list_next(list_next(list_next(list_next(list_next(list_next(list_head(l)))))));

    list_insert_before(l, q, r);
    list_insert_after(l, p, r);

    ck_assert_int_eq(list_length(l), 12);

    m = list_head(l);
    for (int i = 0; i < 8; i++) {
        r = list_next(m);
        list_unlink_node(l, m);
        list_free_node(m);
        m = r;
    }

    ck_assert_int_eq(list_length(l), 4);

    list_cleanup(l);
}
END_TEST

START_TEST (test_get_ith_node)
{
    struct list* l = list_init();
    struct node* n;
    struct node* r;
    struct node* m;

    for (int i = 0; i< LEN; i++) {
        n = list_new_node(i);
        list_add_back(l, n);
    }

    r = list_next(list_head(l));
    m = list_next(list_next(list_next(list_next(list_next(list_next(list_head(l)))))));

    ck_assert_ptr_eq(list_get_ith(l, 0), list_head(l));
    ck_assert_ptr_eq(list_get_ith(l, 1), r);
    ck_assert_ptr_eq(list_get_ith(l, 6), m);
    ck_assert_ptr_eq(list_get_ith(l, 9), list_tail(l));
    ck_assert_ptr_eq(list_get_ith(l, 10), NULL);
    ck_assert_ptr_eq(list_get_ith(l, -1), NULL);

    list_cleanup(l);
}
END_TEST

START_TEST (test_list_cut_after)
{
    struct list* l = list_init();
    struct node* n;

    for (int i = 0; i< LEN; i++) {
        n = list_new_node(i);
        list_add_back(l, n);
    }

    struct node* tail_old = list_tail(l);
    struct node* m = list_get_ith(l, 2);
    struct node* new_head = list_next(m);

    struct list* l2 = list_cut_after(l, m);

    ck_assert_ptr_eq(list_head(l2), new_head);
    ck_assert_ptr_eq(list_tail(l), m);
    ck_assert_ptr_eq(list_tail(l2), tail_old);

    ck_assert_int_eq(list_length(l), 3);
    ck_assert_int_eq(list_length(l2), 7);

    n = list_head(l);
    for (int i = 0; i < 3; i++) {
        ck_assert_int_eq(list_node_value(n), i);
        n = list_next(n);
    }

    n = list_head(l2);
    for (int i = 3; i < 10; i++) {
        ck_assert_int_eq(list_node_value(n), i);
        n = list_next(n);
    }

    list_cleanup(l);
    list_cleanup(l2);
}
END_TEST

Suite * list_suite(void) {
    Suite *s;
    TCase *tc_core;

    s = suite_create("List");
    tc_core = tcase_create("Core");
    
    tcase_add_test(tc_core, test_list_init);
    tcase_add_test(tc_core, test_add_front);
    tcase_add_test(tc_core, test_next_multiple);
    tcase_add_test(tc_core, test_add_back);
    tcase_add_test(tc_core, test_prev_multiple);
    tcase_add_test(tc_core, test_node_value);
    tcase_add_test(tc_core, test_value_multiple);
    tcase_add_test(tc_core, test_unlink_head);
    tcase_add_test(tc_core, test_unlink_multiple);
    tcase_add_test(tc_core, test_list_cleanup);

    // ####### ADDED TESTS ######
    tcase_add_test(tc_core, test_node_present);
    tcase_add_test(tc_core, test_insert_after);
    tcase_add_test(tc_core, test_insert_before);
    tcase_add_test(tc_core, test_list_length);
    tcase_add_test(tc_core, test_get_ith_node);
    tcase_add_test(tc_core, test_list_cut_after);

    suite_add_tcase(s, tc_core);
    return s;
}

int main(void) {
    int number_failed;
    Suite *s = list_suite();
    SRunner *sr = srunner_create(s);

    srunner_run_all(sr, CK_VERBOSE); 
    number_failed = srunner_ntests_failed(sr);
    
    srunner_free(sr);
    return number_failed ? EXIT_FAILURE : EXIT_SUCCESS;
}
