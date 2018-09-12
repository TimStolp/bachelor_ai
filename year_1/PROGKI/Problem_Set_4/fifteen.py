#
# fifteen.py
#
# Artificial Intelligence
# Tim Stolp
#
# create a game of fifteen
#
#####################################

import sys

# ask 2 arguments, 2nd arg ument must be int between 3 and 9
if len(sys.argv) != 2 or int(sys.argv[1]) < 3 or int(sys.argv[1]) > 9:
    print("usage: python fifteen.py size")
    exit(1)

# dimension is 2nd argument
d = int(sys.argv[1])
# fill max size board with "xx"
board = [["xx" for x in range(10)] for y in range(10)]


def main():
    # initialize board
    init()
    # do untill won
    while True:
        # draw board
        draw()
        # if board in win position print won and exit
        if won():
            print("You have won!")
            exit(0)
        # if not won
        while True:
            # ask tile to move
            tile = int(input("Tile to move: "))
            # if input is negative, exit
            if tile < 0:
                exit(1)
            # if tile has a valid move, move it and break
            if move(tile):
                break
        print()

# initialize board
# if dimension is even swap the 1 and 2
def init():
    number = d*d
    for i in range(d):
        for j in range(d):
            board[i][j] = number - 1
            number = number - 1
    if d % 2 == 0:
        temp = board[d - 1][d - 2]
        board[d - 1][d - 2] = board[d - 1][d - 3]
        board[d - 1][d - 3] = temp

# draw board with 2 characters on each place
# draw the 0 as "__"
def draw():
    for i in range(d):
        for j in range(d):
            if board[i][j] == 0:
                print("__", end=" ")
            else:
                print("{:0=2d}".format(board[i][j]), end=" ")
        print()

# get coordinates of tile and 0
# if distance from tile to 0 is 1 swap them and return true
def move(tile):
    ytile, xtile = check(tile)
    yzero, xzero = check(0)
    if (ytile + xtile) - (yzero + xzero) == 1 or (ytile + xtile) - (yzero + xzero) == -1:
        temp = board[ytile][xtile]
        board[ytile][xtile] = board[yzero][xzero]
        board[yzero][xzero] = temp
        return True
    return False

# get coordinates of tile
def check(tile):
    for i in range(d):
        for j in range(d):
            if board[i][j] == int(tile):
                return i, j

# check if board is in winning configuration
def won():
    number = 1
    for i in range(d):
        for j in range(d):
            if board[i][j] != number and board[i][j] != 0:
                return False
            number = number + 1
    return True

if __name__ == "__main__":
    main()
