#
# money.py
#
# Artificial Intelligence
# Tim Stolp
#
# calculate the average amount of throws necessary to buy all the purchasable places on a monopoly board with differnt money starting amounts
#
#####################################

import monopoly
import random
import matplotlib.pyplot as plt
import trump

board = monopoly.Board()
piece = monopoly.Piece()

# test for multiple starting moneys and print average amount of throws to buy all purchasable places
def main():
    test = [0, 500, 1000, 1500, 2000, 2500]
    result_list = []
    for t in test:
        average = 0
        for i in range(1000):
            money = t
            total_throws = 0
            current_board = trump.possession(board)
            # while not all values in dictionary are True
            while not all(map(lambda x: x[1], current_board.items())):
                old_location = piece.location
                # throw 2 dices and move
                piece.move(trump.throw())
                # if player went past start add 200 money
                if piece.location < old_location:
                    money = money + 200
                # if place can be bought, turn value in dictionary to true and substract the corresponding amount from money
                if board.names[piece.location] in current_board and money > board.values[piece.location] and not current_board[board.names[piece.location]]:
                    current_board[board.names[piece.location]] = True
                    money = money - board.values[piece.location]
                total_throws += 1
            average += total_throws
        result = int(average / 1000)
        print('{} euro, {} worpen'.format(t, result))
        result_list = result_list + [result]
    # show graph of starting moneys and average throws to buy full board
    draw(test, result_list)

# plot and show graph
def draw(test, result_list):
    plt.xlabel('euros')
    plt.ylabel('worpen')
    plt.title('Gemiddeld aantal worpen om alles te kopen')
    plt.plot(test, result_list)
    plt.show()

if __name__ == '__main__':
    main()
