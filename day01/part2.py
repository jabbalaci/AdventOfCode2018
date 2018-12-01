#!/usr/bin/env python3


def read_lines(fname):
    with open(fname) as f:
        return f.read().strip().splitlines()


def main():
    lines = read_lines("input.txt")
    numbers = [int(e) for e in lines]
    frequency = 0
    seen = set([frequency])
    idx = 0

    while True:
        n = numbers[idx]
        frequency += n
        if frequency not in seen:
            seen.add(frequency)
        else:
            print(frequency)
            break
        #
        idx += 1
        if idx >= len(numbers):
            idx = 0

##############################################################################

if __name__ == "__main__":
    main()
