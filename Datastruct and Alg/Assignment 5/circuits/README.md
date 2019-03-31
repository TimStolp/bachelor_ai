# A* algorithm to connect gates on a circuit board.

To run the program you run \_\_main\_\_.py.
In the \_\_main\_\_.py file you can adjust some settings to print the results of each solved netlist or print the netlist's circuit board.

## Overview
This program does not work perfectly yet. Problems arise when gates are enclosed by previous wires.
One possible solution was to increase the cost of places next to gates, this either was not implemented correctly or did not work.
Gates were connected from smallest to largest distance between the gates which gave a little better results. Going through every possible permutation might give an even better result.
When collisions were found the wire with which the current connection collisioned got undrawed and the current connection was tried again.
A limiter was implemented to prevent wires from infinitely collisioning into eachother. When this limit is reached it undraws a random other wire and tries again.
Meanwhile the amount of times a* is ran is kept track of, the final solution allows for 'number of a* cycles divided by 10000' unsolved paths to prevent infinitely redrawing random wires.
This number can be changed to allow the program to try redrawing wires for longer to search for better solutions.
10000 was chosen as this gave a decent value per time result.

## Results
Priority was given to connecting as many gates over getting the shortest length.
### Board 1

Netlist1
Total length = 376
Connections failed = 1

Netlist2
Total length = 600
Connections failed = 1

Netlist3
Total length = 492
Connections failed = 12

### Board 2

Netlist1
Total length = 747
Connections failed = 11

Netlist2
Total length = 713
Connections failed = 14

Netlist3
Total length = 685
Connections failed = 26


## Content

### board.py
Creates board class which contains information about the type of board and a list of netlist objects.

### netlist.py
Creates netlist class which stores a circuit board as numpy array, a pandas data frame of gate coordinates, and a pandas data frame of gate connections.
Contains function to solve the gate connections using the a* algorithm.

### node.py
Creates node class which contains information about each node in a path from gate to gate.

### read_xlsx.py
Reads the .xlsx files and turns them into useable pandas dataframes.

### betchy_format.py
Checks if the answers in the .txt files in solutions/ are in the right format.

### solutions/
Contains .txt files containing a pretty print of each solved netlist.

### circuit_board_1/2.xlsx
.xlsx files containing the raw board, gate, and gate connection data.

## Requirements
To run this program, you need the following:

* [Python](https://www.python.org/downloads/) (3.6)
* [numpy](http://www.numpy.org/)
* [Pandas](https://pandas.pydata.org/)
