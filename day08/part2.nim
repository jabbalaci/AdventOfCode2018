import math
import sequtils
import strutils

let
  numbers = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2".splitWhitespace.map(parseInt)    # example
  # numbers = readFile("input.txt").strip.splitWhitespace.map(parseInt)    # input

proc reader(lst: seq[int]): iterator(): int =
  result = iterator (): int =
    for n in lst:
      yield n

let read = reader(numbers)

type
  Node = tuple
    n_children: int
    n_metadata: int
    metadata: seq[int]
    value: int

proc read_node(): Node =
  let
    n_children = read()
    n_metadata = read()

    children = block:
      var lst = newSeq[Node]()
      for i in 1 .. n_children:
        let child_node = read_node()
        lst &= child_node
      #
      lst

    metadata = block:
      var meta = newSeq[int]()
      for i in 1 .. n_metadata:
        meta &= read()
      #
      meta

    value = block:
      if n_children == 0:
        metadata.sum
      else:
        var total = 0
        for meta_idx in metadata:
          let idx = meta_idx - 1
          if idx >= 0 and idx < n_children:
            total += children[idx].value
          #
        #
        total
  # endlet
  
  (n_children: n_children,
   n_metadata: n_metadata,
   metadata: metadata,
   value: value)

proc main() =
  let root = read_node()

  echo root
  echo()
  echo "Part 2: ", root.value

# ############################################################################

when isMainModule:
  main()
