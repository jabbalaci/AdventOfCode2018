#!/usr/bin/env python3

"""
I used it to have an idea about the number
of carts on the input map.
"""

# FNAME = "example1.txt"
FNAME = "input.txt"

def main():
    f = open(FNAME)
    text = f.read()
    f.close()

    result = text.count('<') + text.count('>') + text.count('^') + text.count('v')

    print(f"Number of carts: {result}")

##############################################################################

if __name__ == "__main__":
    main()
