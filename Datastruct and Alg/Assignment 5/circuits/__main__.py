import board

# Initialize boards.
board1 = board.Board("circuit_board_1.xlsx")
board2 = board.Board("circuit_board_2.xlsx")

# Solve netlists.
board1.solve_netlists(printresults=True)
board2.solve_netlists(printresults=True)

# Print the circuit board of the netlists.
board1.print_netlists()
# board2.print_netlists()
