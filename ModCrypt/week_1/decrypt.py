import numpy as np

LETFREQ = {'A': 0.082, 'B': 0.015, 'C': 0.028, 'D': 0.043, 'E': 0.127, 'F': 0.022, 'G': 0.020,
           'H': 0.061, 'I': 0.070, 'J': 0.002, 'K': 0.008, 'L': 0.040, 'M': 0.024, 'N': 0.067,
           'O': 0.015, 'P': 0.019, 'Q': 0.001, 'R': 0.060, 'S': 0.063, 'T': 0.091, 'U': 0.028,
           'V': 0.010, 'W': 0.024, 'X': 0.002, 'Y': 0.020, 'Z': 0.001}


def main():
    # Read cipher text, encode from hex to decimal for easier processing.
    ctext = str(np.loadtxt('ctext.txt', dtype='str'))
    ctext_dec = [int(ctext[i:i+2], 16) for i in range(0, len(ctext), 2)]

    sums = []
    # Take n = 1 to length of cipher
    for n in range(1, len(ctext_dec)+1):
        # create strings of ciphertext taking the n-th letter repeatedly
        nth_str = ctext_dec[0::n]
        # Calculate the frequency of every ASCII character in this new string
        freqs = [nth_str.count(i)/256 for i in range(256)]
        # Find the sum of squares of this frequency
        sums.append((n, sum(np.square(freqs))))

    # The n with the maximum sum of squares is the key length.
    print(sums, max(sums, key=lambda x: x[1]))
    key_length = max(sums, key=lambda x: x[1])[0]

    print(key_length)


if __name__ == "__main__":
    main()
