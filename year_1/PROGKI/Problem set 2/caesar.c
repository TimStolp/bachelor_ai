/*
 * caesar.c
 *
 * Introduction Programming Artificial Intelligence
 * Tim Stolp
 *
 * asks for encryption number.
 * Asks for message.
 * Prints encrypted message.
 *
 * changes every character in the message by the number of places given by the encryption number.
 *
 */

#include <stdio.h>
#include <string.h>
#include <cs50.h>

int main(int argc, string argv[])
{
    // if argument 1 is null or number of arguments bigger than 2
    if(argv[1] == NULL || argc > 2)
    {
        // print error message
        printf("Usage: ./caesar *number*\n");
        // return error number 1
        return 1;
    }

    // turn argument 1 into integer
    int key = atoi(argv[1]);
    // get string from user
    string s = get_string("plaintext: ");
    // get stringlength
    int l = strlen(s);

    // print encrypted text
    printf("ciphertext: ");
    for(int i = 0; i < l; i++)
    {
        // if character is space, print space
        if(s[i] == ' ')
        {
            printf(" ");
        }
        else
        {
            int k, letter;
            // do "key % 26" amount of times
            for(k = 0, letter = s[i]; k < key % 26; k++)
            {
                // if character is Z or z do character - 25
                if(letter == 90 || letter == 122)
                {
                    letter = letter - 25;
                }
                // do character + 1
                else
                {
                    letter = letter + 1;
                }
            }
            // print integer as character
            printf("%c", letter);
        }
    }
    // next line
    printf("\n");
}
