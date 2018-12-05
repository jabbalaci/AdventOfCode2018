import sequtils
import strutils

from common import diff, reduce_polymer


func find_shortest_polymer(text: string): string =
  var shortest_polymer = text
  let alphabet = ('a' .. 'z').toSeq
  
  for c in alphabet:
    let
      C = chr(ord(c) - diff)    # uppercase the current character
      current_polymer = text.replace($c, "").replace($C, "")
      reduced_polymer = reduce_polymer(current_polymer)

    if reduced_polymer.len < shortest_polymer.len:
      shortest_polymer = reduced_polymer
  #
  shortest_polymer


proc main() =
  let
    # input = "dabAcCaCBAcCcaDA"
    input = readFile("input.txt").strip
    result = find_shortest_polymer(input)
  
  # echo result
  echo "Part 2: ", result.len

# ############################################################################

when isMainModule:
  main()
