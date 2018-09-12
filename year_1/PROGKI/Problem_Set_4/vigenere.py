#
# vigenere.py
#
# Artificial Intelligence
# Tim Stolp
#
# encrypt a message using vigenere's encryption
#
# encrypt text using a word as encryption key
#
#####################################

import sys

# if amount of arguments is not 2 print usage message and exit
if len(sys.argv) != 2:
    print("usage: python vigenere.py keyword")
    exit(1)

# ask text to encrypt
plaintext = input("plaintext: ")

# print this
print("ciphertext: ", end="")

# go through plaintext
# if character is in alphabet change it using vigenere's encryption
# print encrypted text
key_number = 0
for i in plaintext:
    if i.isalpha():
        letter = ord(i)
        for j in range(ord((sys.argv[1][key_number % len(sys.argv[1])]).lower()) - 97):
            if letter == ord("z") or letter == ord("Z"):
                letter = letter - 25
            else:
                letter = letter + 1
        key_number = key_number + 1
        print(chr(letter), end="")
    else:
        print(i, end="")

# Next line
print()
