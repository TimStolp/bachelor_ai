#
# trump.py
#
# Artificial Intelligence
# Tim Stolp
#
# calculate the average amount of throws necessary to land on every purchasable place on a monopoly board
#
#####################################

import monopoly
import random

board = monopoly.Board()
piece = monopoly.Piece()

# throw 2 dices
def throw():
    return random.randint(1, 6) + random.randint(1, 6)

# go trough monopoly board and if place has a value that is not 0 place it in dictionary
def possession(board):
    purchasable = {}
    for i in range(len(board.names)):
        if board.values[i] != 0:
            purchasable[board.names[i]] = False
    return purchasable

# do 10000 times and print the average amount of throws to buy all purchasable places
def main():
    average = 0
    for i in range(10000):
        total_throws = 0
        current_board = possession(board)
        # while not all values in dictionary are True
        while not all(map(lambda x: x[1], current_board.items())):
            # throw 2 dices and move
            piece.move(throw())
            # if place can be bought turn value in dictionary to true
            if board.names[piece.location] in current_board:
                current_board[board.names[piece.location]] = True
            total_throws += 1
        average += total_throws
    print('It took {} throws to buy the entire board!'.format(average / 10000))


if __name__ == '__main__':
    main()
