/*
 * credit.c
 *
 * Introduction Programming Artificial Intelligence
 * Tim Stolp
 *
 * Asks for credit card number.
 * Prints credit card's company name if number is valid.
 *
 * Checks the validity of a credit card number.
 * Checks the company of a credit card number.
 */


#include <stdio.h>
#include <cs50.h>

int main(void)
{
    int sum = 0, every_second_digit, digits_times_2, second_digit, first_digit;

    // Asks credit card number.
    printf("Number: ");
    long long cc = get_long_long();

    // Calculates validity number.
    for(long long i = 100; i < cc * 10; i = i * 100)
    {
        every_second_digit = ((cc % i) - (cc % (i / 10))) / (i / 10);
        digits_times_2 = every_second_digit * 2;
        second_digit = digits_times_2 % 10;
        first_digit = (digits_times_2 - second_digit) / 10;
        sum += second_digit;
        sum += first_digit;
    }
    for(long long i = 10; i < cc * 10; i = i * 100)
    {
        int remainder_digits = ((cc % i) - (cc % (i / 10))) / (i / 10);
        sum += remainder_digits;
    }

    // Checks validity and company name.
    int ae_digits = (cc - (cc % 10000000000000)) / 10000000000000;
    int mc_digits = (cc - (cc % 100000000000000)) / 100000000000000;
    int v_digit_13 = (cc - (cc % 1000000000000)) / 10000000000000;
    int v_digit_16 = (cc - (cc % 1000000000000000)) / 1000000000000000;

    if((ae_digits == 34 || ae_digits == 37) && (sum % 10) == 0)
    {
        printf("AMEX\n");
    }
    else if((mc_digits == 51 || mc_digits == 52 || mc_digits == 53 || mc_digits == 54 || mc_digits == 55) && (sum % 10) == 0)
    {
        printf("MASTERCARD\n");
    }
    else if((v_digit_13 == 4 || v_digit_16 == 4) && (sum % 10) == 0)
    {
        printf("VISA\n");
    }
    else
    {
        printf("INVALID\n");
    }
}
