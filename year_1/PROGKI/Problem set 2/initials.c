/*
 * initials.c
 *
 * Introduction Programming Artificial Intelligence
 * Tim Stolp
 *
 * asks for a name.
 * Gives Initials of name in capitals.
 *
 * checks character in string, if it is not a space and the character before is a space, print the character in uppercase.
 *
 */

#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>

int main(void)
{
    // get string from user
    string s = get_string();
    // get length of string
    int l = strlen(s);

    // check i'th letter of string
    for(int i = 0; i < l; i++)
    {
        // if first letter is not a space or if i'th letter is not a space and i-1'th letter is a space: print letter
        if((i == 0 && s[0] != ' ') || (s[i] != ' ' && s[i-1] == ' '))
        {
            // print i'th letter in capital
            printf("%c", toupper(s[i]));
        }
    }
    // go to next line
    printf("\n");
}
