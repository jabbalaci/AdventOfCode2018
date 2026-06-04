#!/usr/bin/env nimbang
#off:nimbang-args c -d:release
#nimbang-settings hideDebugInfo

import std/strutils    # strip, split, join
import std/sequtils    # toSeq(iter), map, filter
import std/math        # sum
import std/sets

proc process(numbers: seq[int]): int =
  var
    i = 0
    seen: HashSet[int]
    total = 0

  while true:
    total += numbers[i]
    inc i
    if i > numbers.high:
      i = 0
    if total in seen:
      return total
    #
    seen.incl(total)


proc main() =
  # let fname = "example.txt"
  let fname = "input.txt"

  let numbers: seq[int] = readFile(fname).strip.splitLines.map(parseInt)

  echo process(numbers)

# ############################################################################

when isMainModule:
  main()
