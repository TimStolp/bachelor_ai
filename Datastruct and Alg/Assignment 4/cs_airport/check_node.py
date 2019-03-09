import unittest
from node import Node

class TestNodeMethods(unittest.TestCase):
    def test_node_keys(self):
        print("Running test_node_keys")
        n_1 = Node(3)
        n_2 = Node(5)
        n_3 = Node(5)
        n_4 = Node(7)
        self.assertEqual(n_1.get_key(), 3)
        self.assertEqual(n_2.get_key(), 5)
        self.assertEqual(n_3.get_key(), 5)
        self.assertEqual(n_4.get_key(), 7) 
        self.assertEqual(str(n_1), "3")
        self.assertEqual(str(n_2), "5")
        self.assertEqual(str(n_3), "5")
        self.assertEqual(str(n_4), "7")
    
    def test_node_value(self):
        print("Running test_node_key")
        n_1 = Node(3, "ABC")
        n_2 = Node(5, "R47")
        n_3 = Node(5, "!.?")
        n_4 = Node(7, "XEZ")
        self.assertEqual(n_1.get_value(), "ABC")
        self.assertEqual(n_2.get_value(), "R47")
        self.assertEqual(n_3.get_value(), "!.?")
        self.assertEqual(n_4.get_value(), "XEZ")
        self.assertEqual(str(n_1), "3/ABC")
        self.assertEqual(str(n_2), "5/R47")
        self.assertEqual(str(n_3), "5/!.?")
        self.assertEqual(str(n_4), "7/XEZ")

    def test_node_comperators_nodes(self):
        print("Running test_node_comperators_nodes")
        n_1 = Node(3)
        n_2 = Node(5)
        n_3 = Node(5)
        n_4 = Node(7)
        self.assertTrue(n_2 is n_2)
        self.assertFalse(n_2 is n_3)
        self.assertFalse(n_1 == n_2)
        self.assertTrue(n_1 != n_2)
        self.assertTrue(n_1 < n_2)
        self.assertTrue(n_4 > n_3)
        self.assertTrue(n_3 == n_2)
        self.assertTrue(n_4 >= n_3)
        self.assertTrue(n_1 <= n_3)

    def test_node_comperators_integers(self):
        print("Running test_node_comperators_integers")
        n_1 = Node(3)
        self.assertFalse(n_1 == 2)
        self.assertTrue(n_1 == 3)
        self.assertTrue(n_1 != 6)
        self.assertTrue(n_1 < 5)
        self.assertTrue(n_1 > 2)
        self.assertTrue(n_1 >= 1)
        self.assertTrue(n_1 >= 3)
        self.assertTrue(n_1 <= 5)
        self.assertTrue(n_1 <= 3)


if __name__ == "__main__":
    unittest.main()
    exit(0)
