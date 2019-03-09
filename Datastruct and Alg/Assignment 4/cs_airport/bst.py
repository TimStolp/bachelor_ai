from node import Node

class BST(object):
    def __init__(self, key_list=[]):
        """Create a new BST, set its attributes, and insert all the keys in
           the key_list into the BST."""
        self.root = None
        self.current = None
        self.nodeList = []
        for key in key_list:
            self.insert(key)
    
    def get_root(self):
        """Return the root of the BST."""
        return self.root
    
    def is_empty(self):
        """Return True if the BST is empty."""
        if not self.root:
            return True
        return False
    
    def find_max(self):
        """Return the node with the maximum key in the BST."""
        current = self.root
        while current.get_right_child():
            current = current.get_right_child()
        return current
    
    def find_min(self):
        """Return the node with the minimum key in the BST."""
        current = self.root
        while current.get_left_child():
            current = current.get_left_child()
        return current
    
    def search(self, key):
        """Return the Node object containing the key if the key exists in
           the BST, else return None."""
        current = self.root

        while current:
            if current == key:
                return current
            if current > key:
                current = current.get_left_child()
            else:
                current = current.get_right_child()
        return None
    
    def contains(self, key):
        """ Return True if the key exists in the BST, else return False."""
        if self.search(key):
            return True
        return False
    
    def insert(self, key, value=None):
        """Create a new node for this key and value, and insert it into the BST.
           
           Return the new inserted node, or None if the key and value could not
           be inserted."""
        if self.contains(key):
            return None

        node = Node(key, value)
        current = self.root
        parent = None

        while current:
            parent = current
            if key < current:
                current = current.get_left_child()
            else:
                current = current.get_right_child()

        if not parent:
            self.root = node
            self.current = self.root

        else:
            if key < parent:
                parent.update_left_child(node)
            else:
                parent.update_right_child(node)

            node.update_parent(parent)
            self.update_heights(node)

        return node

    def update_heights(self, node):
        parent = node.get_parent()
        while parent:
            parent.update_height()
            parent = parent.get_parent()

    def remove_child(self, child, node):
        parent = node.get_parent()

        if not parent:
            self.root = child
        elif node < parent:
            parent.update_left_child(child)
        else:
            parent.update_right_child(child)
        if child:
            child.update_parent(parent)
            self.update_heights(child)
        else:
            self.update_heights(node)

    def delete(self, key):
        """Remove the Node object containing the key if the key exists in
           the BST and return the removed node, else return None.
           
           The returned node is the actual Node object that got removed
           from the BST, and so might be successor of the removed key."""
        node = self.search(key)
        if not node:
            return None

        if node.get_left_child() and node.get_right_child():
            minimum = node.get_right_child()
            while minimum.get_left_child():
                minimum = minimum.get_left_child()
            node.update_key(minimum.get_key())
            node.update_value(minimum.get_value())

            if minimum.get_right_child():
                self.remove_child(minimum.get_right_child(), minimum)
            else:
                self.remove_child(None, minimum)

        elif node.get_left_child():
            child = node.get_left_child()
            self.remove_child(child, node)

        elif node.get_right_child():
            child = node.get_right_child()
            self.remove_child(child, node)

        else:
            self.remove_child(None, node)

        return node

    def in_order_traversal(self):
        """Return a list of the Nodes in the tree in sorted order."""
        current = self.current
        print(current)

        if current:
            self.current = current.get_left_child()
            self.in_order_traversal()

            self.nodeList.append(current)

            self.current = current.get_right_child()
            self.in_order_traversal()

        if current == self.root:
            self.current = self.root
            return_list = self.nodeList
            self.nodeList = []
            print(return_list)
            return return_list
    
    def breadth_first_traversal(self, level=0):
        """Return a list of lists, where each inner lists contains the elements
           of one layer in the tree. Layers are filled in breadth-first-order,
           and contain contain all elements linked in the BST, including the
           None elements.
           >> BST([5, 8]).breadth_first_traversal()
           [[Node(5)], [None, Node(8)], [None, None]]"""
        node_list = [[self.root]]
        temp_list = []
        for i in range(self.root.get_height() + 1):
            for node in node_list[i]:
                if not node:
                    continue
                temp_list.extend((node.get_left_child(), node.get_right_child()))
            node_list.append(temp_list)
            temp_list = []
        return node_list
    
    def __str__(self):
        """Return a string containing the elements of the tree in breadth-first
           order, with each on a new line, and None elements as `_`, and
           finally a single line containing all the nodes in sorted order.
           >> print(BST([5, 8, 3]))
           5
           3 8
           _ _ _ _
           3 5 8
           """
        key_string = ""
        bfs = self.breadth_first_traversal()
        for layer in bfs:
            for node in layer:
                if node:
                    key_string += str(node) + " "
                else:
                    key_string += "_ "
            key_string += "\n"

        iot = self.in_order_traversal()
        # if iot:
        for node in iot:
            key_string += str(node) + " "
        # else:
        #     print(key_string)
        return key_string


