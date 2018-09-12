#
# find.py
#
# Artificial Intelligence
# Tim Stolp
#
# find a number in a list of numbers
#
# find a number using binary search
#
#####################################

import sys

# ask for minimum 3 arguments
if len(sys.argv) < 3:
    print("usage: python find.py needle haystack.")
    exit(1)

# make stack of arguments above 2nd argument
stack = sorted((sys.argv[2:]))
# get begin and end of stack
begin = 0
end = len(stack) - 1
# get needle
needle = int(sys.argv[1])

# if needle is in haystack print found, else print not found
def main():
    if search(begin, end):
        print("Found the needle in the haystack")
    else:
        print("Did not find the needle in the haystack")

# search needle in haystack using binary search
def search(begin, end):
    mid = int((begin + end) / 2)
    if begin > end:
        return False
    if int(stack[mid]) == needle:
        return True
    if int(stack[mid]) < needle:
        if search(mid + 1, end):
            return True
    if int(stack[mid]) > needle:
        if search(begin, mid - 1):
            return True

# call main
if __name__ == "__main__":
    main()
