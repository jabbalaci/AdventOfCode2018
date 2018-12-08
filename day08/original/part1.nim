import math
import sequtils
import strutils


var metadata = newSeq[int]()

proc read_node(numbers: seq[int], idx: int): int =
  var idx = idx
  let n_children = numbers[idx]
  inc idx
  let n_metadata = numbers[idx]
  inc idx
  #
  for i in 1 .. n_children:
    idx = read_node(numbers, idx)
  #
  for i in 1 .. n_metadata:
    metadata &= numbers[idx]
    inc idx
  #
  idx

proc main() =
  let
    numbers = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2".splitWhitespace.map(parseInt)    # example
    # numbers = readFile("input.txt").strip.splitWhitespace.map(parseInt)    # input

  discard read_node(numbers, 0)

  # echo metadata
  echo metadata.sum

# ############################################################################

when isMainModule:
  main()
