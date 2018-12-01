import strutils
import sequtils
import math


proc main() =
  let
    lines = readFile("input.txt").strip().splitlines()
    result = lines.map(parseInt).sum

  echo result

# ############################################################################

when isMainModule:
  main()
