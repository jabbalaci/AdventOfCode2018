import strutils
import sequtils
import math


proc main() =
  let
    text = readFile("input.txt").strip().splitlines()
    result = text.mapIt(it.parseInt).sum

  echo result

# ############################################################################

when isMainModule:
  main()
