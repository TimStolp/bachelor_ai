#
# caesar.py
#
# Artificial Intelligence
# Tim Stolp
#
# encrypt a message using caesar's encryption
#
# encrypt text using a number as encryption key
#
#####################################

import sys

# if amount of arguments is not 2 print usage message and exit
if len(sys.argv) != 2:
    print("usage: python caesar.py key")
    exit(1)

# ask text to encrypt
plaintext = input("plaintext: ")

# print this
print("cyphertext: ", end="")

# go through plaintext
# with each letter move it a certain amount of places through the alphabet
# print encrypted text
for i in plaintext:
    letter = ord(i)
    for j in range(int(sys.argv[1])):
        if letter == ord("z") or letter == ord("Z"):
            letter = letter - 25
        else:
            letter = letter + 1
    print(chr(letter), end="")

# next line
print()
