#! /usr/bin/env bash


## The tests suggested in the assignment text are reproduced below

# Conversion output
./infix2rpn "3+2"
echo ''

# Exit status in case of success
./infix2rpn "(3+2)/3"; echo $?
echo ''

# Output goes to stdout
./infix2rpn "(3+2)/3" 2> /dev/null
echo ''

# Stats go to stderr
./infix2rpn "(3+2)/3" > /dev/null
echo ''

# Exit status in case of error
./infix2rpn "blabla" > /dev/null 2>&1; echo $?
echo ''


## Add your own tests here
echo "### Own tests ###"

echo "Input: (7+4)^5; Accurately counts number of pushes, pops and max. size."
./infix2rpn "(7+4)^5"; echo $?
echo ''

echo "Input: ~    2 *  (2 ^~  3 ) ^   4    ; Properly ignores spaces."
./infix2rpn "~    2 *  (2 ^~  3 ) ^   4    "; echo $?
echo ''

echo "Input: (2*(2^3))^4; Handles parentheses correctly."
./infix2rpn "(2*(2^3))^4"; echo $?
echo ''

echo "Input: 5+(5*(6-3); Detects improperly matched parentheses."
./infix2rpn "5+(5*(6-3)" > /dev/null 2>&1; echo $?
echo ''

echo "Input: 5+(5*6)-3); Detects improperly matched parentheses."
./infix2rpn "5+(5*6)-3)" > /dev/null 2>&1; echo $?
echo ''

echo "Input: 2*2^3^4; Handles right-associative exponentiation at a higher precedence level
than multiplication correctly."
./infix2rpn "2*2^3^4"; echo $?
echo ''

echo "Input: ~3+5^6^~(2-5); Supports unary negation."
./infix2rpn "~3+5^6^~(2-5)"; echo $?
echo ''