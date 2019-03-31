# netlist.py
#
# Creates netlist class which stores a circuit board as numpy array,
# a pandas data frame of gate coordinates, and a pandas data frame of gate connections.
# Contains functions to connect the gates using the a* algorithm.
#

import numpy as np
import node
from random import sample


class Netlist(object):
    def __init__(self, dimensions, gates_frame, netlist_frame):
        """ Initialize the variables of this class. """
        self.netlist_frame = netlist_frame
        self.gates = gates_frame
        self.dimensions = (7,) + (dimensions[1],) + (dimensions[0],)
        self.paths = []
        self.connections = self.get_queue()

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

    def get_neighbours(self, current, visited, goal):
        """
        Get neighbours of coordinates.
        Returns list of nodes of valid neighbours.
        """
        (z, y, x) = current.coords()
        neighbours_coords = [(z + 1, y, x), (z, y, x + 1), (z, y, x - 1), (z, y + 1, x), (z, y - 1, x), (z - 1, y, x)]
        neighbours = []

        for neighbour in neighbours_coords:
            # If neighbour is the goal, return a list of only this neighbour.
            if self.cmp(neighbour, goal.coords()):
                return [node.Node(current, neighbour)]

            if any(ax < 0 for ax in neighbour):
                continue

            if neighbour[0] >= self.dimensions[0] or \
                    neighbour[1] >= self.dimensions[1] or \
                    neighbour[2] >= self.dimensions[2]:
                continue

            if self.in_visited(neighbour, visited):
                continue

            if not self.cmp(neighbour, goal.coords()):
                if self.get_cell(neighbour) == "GA":
                    continue

            neighbours.append(node.Node(current, neighbour))
        return neighbours

    def draw_path(self, end_node, i):
        """ Draws path on circuit board. """
        while end_node:
            (z, y, x) = end_node.coords()
            if self.get_cell((z, y, x)) == "__":
                self.circuit[z][y][x] = f"{i:02d}"
            end_node = end_node.parent()

    def undraw_path(self, end_node):
        """ Undraws path on circuit board."""
        while end_node:
            (z, y, x) = end_node.coords()
            if self.get_cell((z, y, x)) != "GA":
                self.circuit[z][y][x] = "__"
            end_node = end_node.parent()

    def euc_dist(self, a, b):
        """ Calculates Euclidean distance between 2 tuples with 3 values. """
        return (a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2 + (a[2] - b[2]) ** 2

    def cmp(self, a, b):
        """ Returns true if 2 tuples with 3 values are the same. """
        return a[0] == b[0] and a[1] == b[1] and a[2] == b[2]

    def get_cell(self, coords):
        """ Returns value on coordinates of 3d array. """
        return self.circuit[coords[0]][coords[1]][coords[2]]

    def in_visited(self, coords, visited):
        """ Returns true if coordinates are in visited list. """
        for v in visited:
            if self.cmp(coords, v):
                return True

    def find_best_node(self, neighbours):
        """ Find optimal next node. """
        new_node = neighbours[0]
        for n in neighbours:
            if n.f() < new_node.f():
                new_node = n
        return new_node

    def next_to_gate(self, n, current, goal):
        """ Returns True if node has a gate next to it that is not the start or goal gate. """
        (z, y, x) = n.coords()

        neighbours_coords = [(z + 1, y, x), (z, y, x + 1), (z, y, x - 1), (z, y + 1, x), (z, y - 1, x), (z - 1, y, x)]

        for neighbour in neighbours_coords:
            if any(ax < 0 for ax in neighbour):
                continue

            if neighbour[0] >= self.dimensions[0] or \
                    neighbour[1] >= self.dimensions[1] or \
                    neighbour[2] >= self.dimensions[2]:
                continue

            if self.cmp(neighbour, current.coords()):
                continue

            if self.cmp(neighbour, goal.coords()):
                return False

            if self.get_cell(neighbour) == "GA":
                return True

        return False

    def astar(self, current, goal, avoid_gates, visited):
        """ Connects start and goal node recursively using the a* algorithm. """
        if self.cmp(current.coords(), goal.coords()):
            return current, True

        if not self.in_visited(current.coords(), visited):
            visited.append(current.coords())

        neighbours = self.get_neighbours(current, visited, goal)
        # Return if stuck
        if not neighbours:
            return current, False

        filtered = []
        for n in neighbours:
            if self.get_cell(n.coords()) != "__":
                if not self.cmp(n.coords(), goal.coords()):
                    continue
            filtered.append(n)
        for x in filtered:
            x.update_g(current.g() + 1)
            x.update_h(self.euc_dist(x.coords(), goal.coords()))
            if self.next_to_gate(x, current, goal) and avoid_gates:
                x.update_h(x.h() + 2)
            x.update_f(x.g() + x.h())
        if not filtered:
            return current, False

        new_node = self.find_best_node(filtered)
        # Recursively call astar() with new next node.
        return self.astar(new_node, goal, avoid_gates, visited)

    def get_total_length(self):
        """ Get total length of paths. """
        i = 0
        for layer in self.circuit:
            for row in layer:
                for cell in row:
                    if cell != "__" and cell != "GA":
                        i += 1
        return i

    def cleanup_layers(self):
        """ Removes unused layers. """
        i = 0
        for index, layer in enumerate(self.circuit):
            if self.check_empty(layer):
                i += 1
        self.circuit = self.circuit[:7 - i]

    def check_empty(self, layer):
        """ Checks if layer is empty. """
        for row in layer:
            for cell in row:
                if cell != "__":
                    return False
        return True

    def get_queue(self):
        """ Creates queue of gate connections. """
        queue = []
        i = 1
        for index, row in self.netlist_frame.iterrows():
            start, goal = self.get_gates_tuples(row)
            dist = self.euc_dist(start, goal)
            queue.append((start, goal, i, dist))
            i += 1
        return queue

    def find_collision(self, n, goal):
        """
        Finds optimal next neighbour of node.
        Return the wire number that is on that next neighbour.
        """
        if n.parent():
            visited = [n.parent().coords()]
        else:
            visited = []
        neighbours = self.get_neighbours(n, visited, goal)
        for neighbour in neighbours:
            neighbour.update_g(neighbour.parent().g() + 1)
            neighbour.update_h(self.euc_dist(neighbour.coords(), goal.coords()))
            neighbour.update_f(neighbour.g() + neighbour.h())

        new_node = self.find_best_node(neighbours)
        collision_wire = self.get_cell(new_node.coords())
        while collision_wire == "__":
            neighbours.remove(new_node)
            if neighbours:
                new_node = self.find_best_node(neighbours)
                collision_wire = self.get_cell(new_node.coords())
            else:
                return 0
        return int(collision_wire)

    def get_random_paths(self, paths):
        """ Returns random path index. """
        indexes = [i for i in range(len(paths)) if paths[i] != 0]
        return sample(indexes, 1)[0]

    def draw_final_paths(self):
        """ Draws paths on clean circuit board. """
        self.circuit = np.chararray(self.dimensions, unicode=True, itemsize=2)
        for layer in self.circuit:
            layer[:] = "__"
        self.draw_gates()
        for index, path in enumerate(self.paths, 1):
            if path != 0:
                self.draw_path(path, index)
        self.cleanup_layers()

    def handle_collision(self, collision, paths, connection, queue):
        """ Undraws collision wire and updates queue and paths. """
        self.undraw_path(paths[collision])
        paths[collision] = 0
        queue = [connection] + queue
        queue.append(self.connections[collision])
        return queue, paths

    def update_best_solution(self, paths, paths_failed):
        """ Keeps track of best set of paths found. """
        new = len([p + 1 for p in range(len(paths)) if paths[p] == 0])
        if new < paths_failed:
            paths_failed = new
            self.paths = paths
        return paths_failed

    def handle_not_found(self, paths, end_node, goal_node, count_list, counter, current, queue, avoid_gates):
        """
        Redraws wires in different order when collision is found.
        Undraws random wire when stuck in collision loop.
        Allows for 1 more unfinished path per 10000 iterations of trying different orders.
        """
        if not len([p + 1 for p in range(len(paths)) if paths[p] == 0]) <= int(counter / 10000):
            collision = self.find_collision(end_node, goal_node)
            count_list[collision - 1] += 1
            if count_list[collision - 1] > 100:
                avoid_gates = True
            if collision and count_list[collision - 1] < 1000:
                queue, paths = self.handle_collision(collision - 1, paths, current, queue)
            else:
                count_list = [0] * len(self.connections)
                collision = self.get_random_paths(paths)
                queue, paths = self.handle_collision(collision, paths, current, queue)
        return queue, paths, count_list, avoid_gates

    def connect_gates(self):
        """
        Connect the gates using the a* algorithm.
        Returns total path length and amount of paths failed to connect.
        """
        queue = sorted(self.connections, key=lambda x: x[3])
        paths = [0] * len(self.connections)
        count_list = [0] * len(self.connections)
        paths_failed = 999
        counter = 0
        avoid_gates = False
        while queue:
            counter += 1
            paths_failed = self.update_best_solution(paths, paths_failed)
            start, goal, i, dist = queue.pop(0)
            goal_node = node.Node(None, goal)
            end_node, found = self.astar(node.Node(None, start), goal_node, avoid_gates, [])
            if found:
                avoid_gates = False
                paths[i - 1] = end_node
                self.draw_path(end_node, i)
            else:
                queue, paths, count_list, avoid_gates = \
                    self.handle_not_found(paths, end_node, goal_node, count_list, counter,
                                          (start, goal, i, dist), queue, avoid_gates)

        self.draw_final_paths()
        return self.get_total_length(), len([p + 1 for p in range(len(self.paths)) if self.paths[p] == 0])

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
