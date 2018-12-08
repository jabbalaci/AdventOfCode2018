import math
import sequtils
import strutils

let
  # numbers = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2".splitWhitespace.map(parseInt)    # example
  numbers = readFile("input.txt").strip.splitWhitespace.map(parseInt)    # input

# thanks to @technicallyagd on IRC for his help
proc reader(lst: seq[int]): iterator(): int =
  result = iterator (): int =
    for n in lst:
      yield n

let read = reader(numbers)


proc read_node(): seq[int] =
  let
    n_children = read()
    n_metadata = read()
  #
  for i in 1 .. n_children:
    result &= read_node()
  #
  for i in 1 .. n_metadata:
    result &= read()


proc main() =
  let metadata = read_node()

  # echo metadata
  echo metadata.sum

# ############################################################################

when isMainModule:
  main()
