/*
 * crack.c
 *
 * Introduction Programming Artificial Intelligence
 * Tim Stolp
 *
 * Ask for hash.
 * Ask for max search depth.
 * if match found: print word that matches hash and end program. If not: print "Could not find match.".
 *
 * decrypts hashes with salt "50".
 *
 */

#include <stdio.h>
#include <cs50.h>
#include <crypt.h>
#include <string.h>

void increase_depth();
bool check();

int main(int argc, string argv[])
{
    // check if second argument null or number of arguments is more than 2
    if(argv[1] == NULL || argc > 2)
    {
        // print error message
        printf("Usage: ./crack *hash*\n");
        //return error code 1
        return 1;
    }
    // get max depth
    int max_depth = get_int("Max search depth: ");
    // call function with hash and
    increase_depth(argv[1], max_depth);
    return 0;
}

void increase_depth(string hash, int max_depth)
{
    // increase search depth with 1 till max depth
    for(int current_depth = 1; current_depth <= max_depth; current_depth++)
    {
        // make character array
        char letters[current_depth + 1];
        // make last character of array null
        letters[current_depth] = '\0';
        // call function check with hash, current depth, begin length of letters, and character array
        if(check(hash, current_depth, 0, letters))
        {
            // if function check turns true end function
            return;
        }
    }
    // if check stays false print message
    printf("Could not find match.\n");
}

bool check(string hash, int current_depth, int length, char letters[])
{
    // go trough all letter combinations of current search depth
    for(int i = 65; i < 123; i++)
    {
        // if i == 92 do +6 to 97 (== a)
        if(i == 91)
        {
            i = i + 6;
        }

        // change last character of letter combination to i
        letters[length] = i;

        // if length is current search depth -1 check letter combination
        if(length == current_depth - 1)
        {
            // if hash of letter combination is same as hash print letter combination
            if((strcmp(crypt(letters, "50"), hash)) == 0)
            {
                // print letter combination
                printf("%s\n", letters);
                // return to previous recursion step
                return true;
            }
        }
        // if length is same as current search depth start recursion
        else
        {
            // call check with hash, current search depth, length + 1, and character array
            if(check(hash, current_depth, length + 1, letters))
            {
                // if check with length + 1 turns true return true
                return true;
            }
        }
    }
    // if no match with hash is found return false
    return false;
}