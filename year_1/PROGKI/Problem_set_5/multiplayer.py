#
# multiplayer.py
#
# Artificial Intelligence
# Tim Stolp
#
# calculate how many more places player 0 can buy over player 1 with same starting money
#
# runs program 1000 times to get a good average
# print every step each player makes, print when a player buys a place
# print the amount of places each player managed to buy after all places are bought
#
# with the information that it prints I could not find out why the result is incorrect.
#
#####################################

import monopoly
import random
import matplotlib.pyplot as plt
import trump

board = monopoly.Board()
piece = monopoly.Piece()

def main():
    average = [0, 0]
    for i in range(1000):
        current_player = 0
        money = [1500, 1500]
        amount_bought = [0, 0]
        player_location = [0, 0]
        current_board = trump.possession(board)
        # while not all values in dictionary are True
        while not all(map(lambda x: x[1], current_board.items())):
            # change piece location to location of current player
            piece.location = player_location[current_player]
            # throw 2 dices and move
            piece.move(trump.throw())
            # if player went past start add 200 money.
            if piece.location < player_location[current_player]:
                money[current_player] = money[current_player] + 200
            print('Player {} moved from {} to {}'.format(current_player, player_location[current_player], piece.location))
            # remember current player's location
            player_location[current_player] = piece.location
            # if place can be bought, turn value in dictionary to true and substract the corresponding amount from money
            if board.names[piece.location] in current_board and money[current_player] >= board.values[piece.location] and not current_board[board.names[piece.location]]:
                current_board[board.names[piece.location]] = True
                money[current_player] = money[current_player] - board.values[piece.location]
                # add 1 to amount of places bought by current player
                amount_bought[current_player] += 1
                print('player {} bought {}'.format(current_player, board.names[piece.location]))
            current_player = (current_player + 1) % 2
        print()
        print('player 0 bought {} places, player 1 bought {} places.\n'.format(amount_bought[0], amount_bought[1]))
        average[0] += amount_bought[0]
        average[1] += amount_bought[1]
    print('Als beide spelers beginnen met 1500 euro heeft speler 1 gemiddeld {} meer vakjes'.format((average[0] / 10000) / (average[1] / 10000)))

if __name__ == '__main__':
    main()
