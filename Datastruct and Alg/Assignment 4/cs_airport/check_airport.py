import unittest
import shlex, subprocess

from airport import Airport

class TestAirportMethods(unittest.TestCase):

    def test_commandline(self):
        # python3 on ubuntu systems, might have to be changed to python3
        # If using Windows/Mac
        print("Running test_commandline")
        PROG = "python airport.py "
        tests = {
        "5000/BLA 30000/STA 25000/TAA 10000/OOP 15000/TRO 17000/STO 13000/CRO -t 5000" : "5000/BLA 10000/OOP 15000/TRO 20000/STO 25000/TAA 30000/STA 35000/CRO",
        "5000/BLA 5000/STA 5000/TAA 5000/OOP 5000/TRO -t 5000" : "5000/BLA 10000/STA 15000/TAA 20000/OOP 25000/TRO",
        "5000/BLA 5000/STA 5000/TAA 5000/OOP 5000/TRO -s -t 5000" : "5000/BLA",
        "5000/BLA 30000/STA 25000/TAA 10000/OOP 15000/TRO 17000/STO 13000/CRO -s -t 5000" : "5000/BLA 10000/OOP 15000/TRO 25000/TAA 30000/STA",
        "5000/BLA 30000/STA 25000/TAA 10000/OOP 15000/TRO 17000/STO 13000/CRO -s -t 1000" : "5000/BLA 10000/OOP 13000/CRO 15000/TRO 17000/STO 25000/TAA 30000/STA",
        "5000/BLA 30000/STA 25000/TAA 10000/OOP 15000/TRO 17000/STO 13000/CRO -t 1000 -s" : "5000/BLA 10000/OOP 13000/CRO 15000/TRO 17000/STO 25000/TAA 30000/STA",
        ### You can add your own lines here if you want.

        }

        # Do not touch this function past this point
        passed = 0
        for test in tests:
            args = shlex.split(PROG + test)
            try:
                result = subprocess.run(args, stdout=subprocess.PIPE)
                # Ignore \n
                output = result.stdout.decode('utf-8').replace('\n', '')
                self.assertEqual(output.rstrip(), tests[test])
                passed += 1
            except AssertionError as e:
                print("=" * 70)
                print("FAIL: test_commandline (__main__.TestAirportMethods)")
                print("-" * 70)

                print("Running: " + test)
                print("AssertionError\n", e.args[0])
        print("test_commandline PASSED {0:d}/{1:d}.".format(passed, len(tests)))

    def test_airport_bounded_insert(self):
        print("Running test_airport_bounded_insert")
        airport = Airport(100)
        airport.bounded_insert(1080, "TOP")
        airport.bounded_insert(700, "TIP")
        airport.bounded_insert(1300, "RIC")
        airport.bounded_insert(500, "KRO")
        airport.bounded_insert(900, "LLE")
        airport.bounded_insert(1180, "DDD")
        self.assertEqual(str(airport), "500/KRO 700/TIP 900/LLE 1080/TOP 1180/DDD 1300/RIC")
        airport.bounded_insert(990, "THU")
        self.assertEqual(str(airport), "500/KRO 700/TIP 900/LLE 1080/TOP 1180/DDD 1300/RIC 1400/THU")

    def test_breadth_first_traversal(self):
        print("Running test_breadth_first_traversal")
        airport = Airport(100)
        a1 = airport.bounded_insert(2000, "TOP")
        a2 = airport.bounded_insert(1000, "TIP")
        a3 = airport.bounded_insert(2500, "RIC")
        a4 = airport.bounded_insert(500, "KRO")
        a5 = airport.bounded_insert(1800, "LLE")
        b = airport.breadth_first_traversal()
        ground_truth = [a1, a2, a3, a4, a5, None, None, None, None, None, None]
        for layer in b:
            for element in layer:
                # Check if there are still elements that could be processed
                self.assertTrue(len(ground_truth) > 0)
                gt = ground_truth.pop(0)
                self.assertEqual(element, gt)
        # All elements should have been processed.
        self.assertTrue(len(ground_truth) == 0)

    def test_in_order_traversal(self):
        print("Running test_in_order_traversal")
        airport = Airport(100)
        a1 = airport.bounded_insert(2000, "TOP")
        a2 = airport.bounded_insert(1000, "TIP")
        a3 = airport.bounded_insert(2500, "RIC")
        a4 = airport.bounded_insert(500, "KRO")
        a5 = airport.bounded_insert(1800, "LLE")
        order = airport.in_order_traversal()
        ground_truth = [a4, a2, a5, a1, a3]
        for element in order:
                # Check if there are still elements that could be processed
                self.assertTrue(len(ground_truth) > 0)
                gt = ground_truth.pop(0)
                self.assertEqual(element, gt)
        # All elements should have been processed.
        self.assertTrue(len(ground_truth) == 0)

if __name__ == "__main__":
    unittest.main()

# Meerdere Deletes
# Insert-Delete-Insert
# __find_second_to_last_tail
# __find_first_free_parent
# Grade Heap class maken die deze overschrijft
# Split into different files, return 0 if successful and 1 otherwise.
