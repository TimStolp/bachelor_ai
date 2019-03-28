# board.py
#
# Creates board class which contains information about the type of board and a list of netlist objects.
#

import read_xlsx as rx
import netlist as nl


class Board(object):
    def __init__(self, filename):
        """ Initialize the variables of this class. """
        name, dimensions, gates_frame, netlist_frames = rx.read_xlsx(filename)
        self.name = name
        self.dimensions = dimensions
        self.gates_frame = gates_frame
        self.netlists = [nl.Netlist(dimensions, gates_frame, netlist_frame) for netlist_frame in netlist_frames]

    def solve_netlists(self, printresults=False):
        """
        Connect the gates on each netlist and write netlists' circuit boards to text file.
        If printresults is True, print out stats of each solved netlist.
        Returns total length and failed connections of each netlist.
        """
        results = []
        for i in range(len(self.netlists)):
            results.append(self.netlists[i].connect_gates())
            name = 'board' + str(self.name[-1]) + '_list' + str(i+1) + '.txt'
            file = open("solutions/" + name, "w+")
            file.write(str(self.netlists[i]))
        if printresults:
            for j in range(len(results)):
                print(f"Netlist{j+1}\nTotal length = {results[j][0]}\nConnections failed = {results[j][1]}\n")
        return results

    def print_netlists(self):
        """ Pretty print each netlist's circuit board. """
        for netlist in self.netlists:
            print(netlist)

    def __str__(self):
        """ Returns board's name and dimensions in string. """
        return f"Circuit board: {self.name}\nDimensions: {self.dimensions}\n"
