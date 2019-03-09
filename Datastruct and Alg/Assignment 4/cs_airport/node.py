class Node(object):
    def __init__(self, key, value=None):
        """Store the key and value in the node and set the other attributes."""
        self.parent = None
        self.leftChild = None
        self.rightChild = None
        self.key = key
        self.value = value
        self.height = 0
    
    def get_key(self):
        """Return the key of this node."""
        return self.key
    
    def get_value(self):
        """Return the value of this node."""
        return self.value
    
    def get_parent(self):
        """Return the parent node of this node."""
        return self.parent
    
    def get_left_child(self):
        """Return the left child node of this node."""
        return self.leftChild
    
    def get_right_child(self):
        """Return the right child node of this node."""
        return self.rightChild
    
    def get_height(self):
        """Return the height of this node."""
        return self.height
    
    def update_height(self):
        """Update the height based on the height of the left and right nodes."""
        if self.leftChild and self.rightChild:
            if self.leftChild.height > self.rightChild.height:
                self.height = self.leftChild.height + 1
            else:
                self.height = self.rightChild.height + 1
        elif self.leftChild:
            self.height = self.leftChild.height + 1
        elif self.rightChild:
            self.height = self.rightChild.height + 1
        else:
            self.height = 0

    def update_left_child(self, new_node):
        """update the left child of this node"""
        self.leftChild = new_node

    def update_right_child(self, new_node):
        """update the right child of this node"""
        self.rightChild = new_node

    def update_parent(self, parent):
        """update the parent of this node"""
        self.parent = parent

    def update_value(self, value):
        """update the value of this node"""
        self.value = value

    def update_key(self, key):
        """update the key of this node"""
        self.key = key

    #
    # You can add any additional node functions you might need here
    #
    
    def __eq__(self, other):
        """Returns True if the node key is equal to other, which can be
           another node or a number."""
        return self.key == other
    
    def __neq__(self, other):
        """Returns True if the node key is not equal to other, which can be
           another node or a number."""
        return self.key != other
    
    def __lt__(self, other):
        """Returns True if the node key is less than other, which can be
           another node or a number."""
        return self.key < other

    def __le__(self, other):
        """Returns True if the node key is less than or equal to other, which
           can be another node or a number."""
        return self.key <= other

    def __gt__(self, other):
        """Returns True if the node key is greater than other, which can be
           another node or a number."""
        return self.key > other

    def __ge__(self, other):
        """Returns True if the node key is greater than or equal to other,
           which can be another node or a number."""
        return self.key >= other
    
    def __str__(self):
        """Returns the string representation of the node in format: 'key/value'.
           If no value is stored, the representation is just: 'key'."""
        return f"{self.key}/{self.value}" if self.value else f"{self.key}"

