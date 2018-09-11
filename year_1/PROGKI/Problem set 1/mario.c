/*
 * mario.c
 *
 * Introduction Programming Artificial Intelligence
 * Tim Stolp
 *
 * Asks for height.
 * Prints pyramide.
 */

#include <stdio.h>
#include <cs50.h>

int main(void)
{
    // Asks for valid height number.
    int height;
    do
    {
        printf("Height: ");
        height = get_int();
    }
    while(height < 0 || height > 23);

    // Prints out pyramide.
    for(int i = 0; i < height; i++)
    {
        for(int k = 0; k < height - (i + 1); k++)
        {
            printf(" ");
        }

        for(int k = i + 1; k > 0; k--)
        {
            printf("#");
        }
        printf("  ");

        for(int k = i + 1; k > 0; k--)
        {
            printf("#");
        }
        printf("\n");
    }
}
