#!/usr/bin/env python3


def read_lines(fname):
    with open(fname) as f:
        return f.read().strip().splitlines()


def main():
    lines = read_lines("input.txt")
    numbers = [int(e) for e in lines]
    result = sum(numbers)

    print(result)

##############################################################################

if __name__ == "__main__":
    main()
