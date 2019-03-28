# netlist.py
#
# Creates netlist class which stores a circuit board as numpy array,
# a pandas data frame of gate coordinates, and a pandas data frame of gate connections.
# Contains function to solve the gate connections using the a* algorithm.
#

import numpy as np
import node


class Netlist(object):
    def __init__(self, dimensions, gates_frame, netlist_frame):
        """ Initialize the variables of this class. """
        self.netlist_frame = netlist_frame
        self.gates = gates_frame
        self.dimensions = (5,) + (dimensions[1],) + (dimensions[0],)

        self.circuit = np.chararray(self.dimensions, unicode=True, itemsize=2)
        for layer in self.circuit:
            layer[:] = "__"
        self.draw_gates()

    def get_circuit(self):
        """ Returns circuit board as numpy array """
        return self.circuit

    def get_netlist(self):
        """ Returns pandas data frame containing start and end gate of each connection. """
        return self.netlist_frame

    def draw_gates(self):
        """ Draws all gates on the circuit board. """
        unique_gates = self.netlist_frame["First gate number"].tolist() + \
                       self.netlist_frame["Second gate number"].tolist()
        for i in range(len(unique_gates)):
            x = int(self.gates[self.gates["Gate number"] == unique_gates[i]]["X coordinate"])
            y = int(self.gates[self.gates["Gate number"] == unique_gates[i]]["Y coordinate"])
            self.circuit[0][y][x] = "GA"

    def get_gates_tuples(self, row):
        """ Get coordinate tuples of start and goal gates of a row in pandas data frame. """
        start = row["First gate number"]
        goal = row["Second gate number"]
        x_start = int(self.gates[self.gates["Gate number"] == start]["X coordinate"])
        y_start = int(self.gates[self.gates["Gate number"] == start]["Y coordinate"])
        x_goal = int(self.gates[self.gates["Gate number"] == goal]["X coordinate"])
        y_goal = int(self.gates[self.gates["Gate number"] == goal]["Y coordinate"])
        return (0, y_start, x_start), (0, y_goal, x_goal)

    def get_neighbours(self, coord, visited, goal):
        """
        Get neighbours of coordinates.
        Returns list of nodes of valid neighbours.
        """
        (z, y, x) = coord

        neighbours_coords = [(z + 1, y, x), (z, y, x + 1), (z, y, x - 1), (z, y + 1, x), (z, y - 1, x), (z - 1, y, x)]
        neighbours = []

        for neighbour in neighbours_coords:

            # If neighbour is the goal, return a list of only this neighbour.
            if self.cmp(neighbour, goal):
                return [node.Node(None, neighbour)]

            if any(ax < 0 for ax in neighbour):
                continue

            if neighbour[0] >= self.dimensions[0] or \
               neighbour[1] >= self.dimensions[1] or \
               neighbour[2] >= self.dimensions[2]:
                continue

            if self.in_visited(neighbour, visited):
                continue

            neighbours.append(node.Node(None, neighbour))

        return neighbours

    def draw_path(self, end_node, i):
        """ Draws path on circuit board. """
        while end_node:
            (z, y, x) = end_node.coords()
            if self.get_cell((z, y, x)) == "__":
                self.circuit[z][y][x] = f"{i:02d}"
            end_node = end_node.parent()

    def manh_dist(self, a, b):
        """ Calculates Manhattan distance between 2 tuples with 3 values. """
        return abs(a[0] - b[0]) + abs(a[1] - b[1]) + abs(a[2] - b[2])

    def cmp(self, a, b):
        """ Returns true if 2 tuples with 3 values are the same. """
        return a[0] == b[0] and a[1] == b[1] and a[2] == b[2]

    def get_cell(self, coords):
        """ Returns value of coordinates of 3d array. """
        return self.circuit[coords[0]][coords[1]][coords[2]]

    def in_visited(self, coords, visited):
        """ Returns true if coordinates are in visited list. """
        for v in visited:
            if self.cmp(coords, v):
                return True

    def update_score(self, n, goal):
        """ Checks how many gates are around a node making this node more expensive for each gate. """
        neighbours = self.get_neighbours(n.coords(), [], goal)
        if self.cmp(neighbours[0].coords(), goal):
            return 0
        i = 0
        for neighbour in neighbours:
            if self.get_cell(neighbour.coords()) == "GA":
                i += 2
        return i

    def find_best_node(self, neighbours):
        """ Find optimal next node. """
        new_node = neighbours[0]
        for n in neighbours:
            if n.f() < new_node.f():
                new_node = n
        return new_node

    def astar(self, current, goal, visited):
        """ Connects start and goal node recursively using the a* algorithm. """
        if self.cmp(current.coords(), goal.coords()):
            return current

        if not self.in_visited(current.coords(), visited):
            visited.append(current.coords())

        neighbours = self.get_neighbours(current.coords(), visited, goal.coords())

        # Return 1 if stuck
        if not neighbours:
            return 1

        for n in neighbours:
            # Delete invalid neighbours
            if not self.cmp(n.coords(), goal.coords()):
                if not self.get_cell(n.coords()) == "__":
                    neighbours.remove(n)
            # Return 1 if stuck
            if not neighbours:
                return 1
            n.update_g(current.len() + 1)
            n.update_h(self.manh_dist(n.coords(), goal.coords()) + self.update_score(n, goal.coords()))
            n.update_f(n.g() + n.h())

        new_node = self.find_best_node(neighbours)
        new_node.update_parent(current)

        # Recursively call astar() with new next node.
        return self.astar(new_node, goal, visited)

    def get_total_length(self):
        """ Get total length of paths. """
        i = 0
        for layer in self.circuit:
            for row in layer:
                for cell in row:
                    if cell != "__" and cell != "GA":
                        i += 1
        return (self.dimensions[0] * self.dimensions[1] * self.dimensions[2]) - i

    def connect_gates(self):
        """
        Connect the gates using the a* algorithm.
        Returns total path length and amount of paths failed to connect.
        """
        paths = []
        i = 1
        times_failed = 0
        for index, row in self.netlist_frame.iterrows():
            start, goal = self.get_gates_tuples(row)
            end_node = self.astar(node.Node(None, start), node.Node(None, goal), [])
            if end_node != 1:
                paths.append((end_node, end_node.g()-1, i))
                self.draw_path(end_node, i)
            else:
                times_failed += 1
            i += 1

        return self.get_total_length(), times_failed

    def __str__(self):
        """ Pretty print the circuit board. """
        circuit = ""
        for i in range(len(self.circuit)):
            circuit = circuit + f"### Layer {i+1} ###\n"
            for row in self.circuit[i]:
                for cell in row:
                    circuit = circuit + cell + " "
                circuit = circuit + "\n"
            circuit = circuit + "\n"
        return circuit
