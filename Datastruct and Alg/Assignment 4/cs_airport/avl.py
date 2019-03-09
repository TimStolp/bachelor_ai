from bst import BST

class AVL(BST):
    def __init__(self, key_list=[]):
        """Create a new AVL Tree, set its attributes, and insert all the keys in
           the key_list into the AVL."""
        BST.__init__(self, key_list)

    def insert(self, key, value=None):
        """Create a new node for this key and value, and insert it into the AVL
           using the BST insert operation. In addition, it ensures that the AVL
           tree is still balanced after this operation is performed.

           Return the new inserted node, or None if the key and value could not
           be inserted."""
        node = super().insert(key, value=None)
        if node:
            self.fix_balance(node)
        return node

    def delete(self, key):
        """Remove the Node object containing the key if the key exists in
           the AVL using the BST delete operation. In addition, it ensures that
           the AVL tree is still balanced after this operation is performed.

           Return the node that actually got removed from the AVL, which might
           be successor of the removed key."""
        node = super().delete(key)
        if node:
            self.fix_balance(node)
        return node


    
    @staticmethod
    def left_rotate(y):
        """Performs a left rotation of the specified node."""
        z = y.get_right_child()

        z.update_parent(y.get_parent())
        if y.get_parent():
            if z < z.get_parent():
                y.get_parent().update_left_child(z)
            else:
                y.get_parent().update_right_child(z)
        y.update_parent(z)
        y.update_right_child(z.get_left_child())
        if z.get_left_child():
            y.get_right_child().update_parent(y)
        z.update_left_child(y)

        while y:
            y.update_height()
            y = y.get_parent()



    @staticmethod
    def right_rotate(z):
        """Performs a right rotation of the specified node."""
        y = z.get_left_child()

        y.update_parent(z.get_parent())
        if z.get_parent():
            if y < y.get_parent():
                z.get_parent().update_left_child(y)
            else:
                z.get_parent().update_right_child(y)
        z.update_parent(y)
        z.update_left_child(y.get_right_child())
        if y.get_right_child():
            z.get_left_child().update_parent(z)
        y.update_right_child(z)

        while z:
            # print(node)
            z.update_height()
            z = z.get_parent()



    def balance(self, node):
        if node.get_right_child():
            right = node.get_right_child().get_height()
        else:
            right = -1
        if node.get_left_child():
            left = node.get_left_child().get_height()
        else:
            left = -1
        return right - left

    
    def fix_balance(self, node):
        """Performs a sequence of rotations to fix the balance of a node and
           all its parent nodes if needed to maintain the AVL property."""
        parent = node.get_parent()
        while node and node.get_parent():
            node_balance = self.balance(node)
            parent_balance = self.balance(parent)

            if parent_balance < -1 and node_balance < 0:
                # left left
                # if self.root == parent:
                #     self.root = node
                AVL.right_rotate(parent)
                # print(self)

            elif parent_balance > 1 and node_balance > 0:
                # right right
                # if self.root == parent:
                #     self.root = node
                AVL.left_rotate(parent)
                # print(self)

            elif parent_balance < -1 and node_balance > 0:
                # left right
                # if self.root == parent:
                #     self.root = node.get_right_child()
                AVL.left_rotate(node)
                AVL.right_rotate(parent)
                # print(self)

            elif parent_balance > 1 and node_balance < 0:
                # right left
                # if self.root == parent:
                #     self.root = node.get_left_child()
                AVL.right_rotate(node)
                AVL.left_rotate(parent)
                # print(self)

            node = node.get_parent()
            if node:
                parent = node.get_parent()

