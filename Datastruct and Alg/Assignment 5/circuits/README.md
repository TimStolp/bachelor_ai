# A* algorithm to connect gates on a circuit board.

To run the program you run __main__.py.
In the __main__.py file you can adjust some settings to print the results of each solved netlist or print the netlist's circuit board.

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