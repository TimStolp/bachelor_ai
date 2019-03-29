# node.py
#
# Creates node class which contains information about each node in a path from gate to gate.
#


class Node(object):
    def __init__(self, parent, coords):
        """ Initialize the variables of this class. """
        self.parent_ = parent
        self.coords_ = coords

        self.g_ = 0
        self.h_ = 0
        self.f_ = 0

    def f(self):
        """ Returns f value. """
        return self.f_

    def h(self):
        """ Returns h value. """
        return self.h_

    def g(self):
        """ Returns g value. """
        return self.g_

    def coords(self):
        """ Returns node's coordinates. """
        return self.coords_

    def parent(self):
        """ Returns node's parent. """
        return self.parent_

    def update_f(self, new_f):
        """ Update f value. """
        self.f_ = new_f

    def update_g(self, new_g):
        """ Update g value. """
        self.g_ = new_g

    def update_h(self, new_h):
        """ Update g value. """
        self.h_ = new_h

    def update_parent(self, new_parent):
        """ Update parent and length to this node. """
        self.parent_ = new_parent
