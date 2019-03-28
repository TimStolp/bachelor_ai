# A* algorithm to connect gates on a circuit board.

To run the program you run __main__.py.
In the __main__.py file you can adjust some settings to print the results of each solved netlist or print the netlist's circuit board.

## Results
This program does not work perfectly yet. Problems arise when gates are enclosed by previous wires and various attempts to counteract this failed.
One possible solution was to increase the cost of places next to gates, this gave a small improvement but did not fix it completely.
Next to that the algorithm has a tendency to zigzag sometimes when it could have gone straight.
Also it sometimes ends up climbing all the way to the top layer and then going back down again and continuing from there.
One way to improve the solutions, but also increase runtime, would be to backtrack and try other possible directions, or even go a step further and try to connect gates in different orders to further optimize the result.


## Content

### board.py
Creates board class which contains information about the type of board and a list of netlist objects.

### netlist.py
Creates netlist class which stores a circuit board as numpy array, a pandas data frame of gate coordinates, and a pandas data frame of gate connections.
Contains function to solve the gate connections using the a* algorithm.
The circuit boards have a Z dimension of 5 as this resulted in the best overal score. If more layers are added they will end up being used but give worse outcomes.

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