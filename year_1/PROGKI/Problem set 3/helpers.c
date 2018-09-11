/**
 * helpers.c (more)
 *
 * Helper functions for Problem Set 3.
 */

#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include "helpers.h"

bool binary_search(int value, int values[], int begin, int end);

/**
 * Returns true if value is in array of n values, else false.
 */
bool search(int value, int values[], int n)
{
    // if n is negative return false
    if(n <= 0)
    {
        return false;
    }
    // call binary_search with value, array, begin and end of array
    if(binary_search(value, values, 0, n))
    {
        return true;
    }
    return false;
}

/**
 * Sorts array of n values.
 */
void sort(int values[], int n)
{
    // make counting array
    int counting_array[65536];
    // set all integers of counting array to 0
    for(int i = 0; i < 65536; i++)
    {
        counting_array[i] = 0;
    }
    // go trough unsorted array
    for(int i = 0; i < n; i++)
    {
        // store integer of unsorted array
        int number = values[i];
        // do integer of counting array + 1 on the number'th place
        counting_array[number] = counting_array[number] + 1;
    }
    int j = 0;
    // go through counting array
    for(int i = 0; i < 65536; i++)
    {
        // for integer of counting array is not 0, put number of place in original array and do integer - 1
        for(int k = counting_array[i]; k != 0; k--)
        {
            // put number of place in original array
            values[j] = i;
            // every time an integer gets put in values[] go to next place in values[]
            j = j + 1;
        }
    }
    return;
}
// binary search
bool binary_search(int value, int values[], int begin, int end)
{
    // get middle of array
    int mid = (begin + end)/2;
    // return false if begin is bigger than end
    if(begin > end)
    {
        return false;
    }
    // return true if middle is value
    if(values[mid] == value)
    {
        return true;
    }
    // if middle is smaller than value do binary_search with right side of array
    if(values[mid] < value)
    {
        if(binary_search(value, values, mid + 1, end))
        {
            return true;
        }
    }
    // if middle is bigger than value do binary_search with left side of array
    if(values[mid] > value)
    {
        if(binary_search(value, values, begin, mid - 1))
        {
            return true;
        }
    }
    return false;
}