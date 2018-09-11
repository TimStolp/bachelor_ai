/*
 * water.c
 *
 * Introduction Programming Artificial Intelligence
 * Tim Stolp
 *
 * Asks minutes spent showering.
 * Prints amount of bottles of which the amount of water is equivalent to the amount of water used during shower.
 */

#include <stdio.h>
#include <cs50.h>

int main(void)
{
    // Asks minutes.
    int minutes = get_int("Minutes:");

    // Prints amount of bottles.
    printf("Bottles:%i\n", minutes * 12);

    // The 2 lines can also be replaced with the 1 line below.
    // printf("Bottles:%i\n", get_int("Minutes:") * 12);
}