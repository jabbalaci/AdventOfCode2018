import strutils

from common import reduce_polymer


proc main() =
  let
    # input = "dabAcCaCBAcCcaDA"
    input = readFile("input.txt").strip
    result = reduce_polymer(input)

  # echo result
  echo "Part 1: ", result.len

# ############################################################################

when isMainModule:
  main()
