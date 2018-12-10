#!/usr/bin/env python3

import matplotlib.pyplot as plt

# INPUT = "example1.csv"
INPUT = "input.csv"

def read_lines(fname):
    with open(fname) as f:
        return f.read().splitlines()[1:]    # skip header

def get_coordinates(lines):
    li = []
    for line in lines:
        parts = line.split(", ")
        li.append((int(parts[0]), int(parts[1])))
    #
    return li

def main():
    lines = read_lines(INPUT)
    coordinates = get_coordinates(lines)

    xs = [t[0] for t in coordinates]
    ys = [-t[1] for t in coordinates]

    # print(lines)
    # print(coordinates)
    # print(xs)
    # print(ys)

    plt.scatter(xs, ys, s=100, marker="s")
    plt.title('AoC 2018, Day 10')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.show()

##############################################################################

if __name__ == "__main__":
    main()
