import strutils
import strformat
import sequtils
import sets
import math


proc main() =
  let
    text = readFile("input.txt").strip().splitlines()
    # text = readFile("example.txt").strip().splitlines()
    numbers = text.mapIt(it.parseInt)

  # echo numbers

  var
    frequency = 0
    # thanks to narimiran for figuring out how to speed up the sets
    seen = initSet[int](2 ^ 17)    # 131_072
    idx = 0
    iterations = 1

  seen.incl(frequency)

  while true:
    let n = numbers[idx]
    frequency += n
    if frequency notin seen:
      seen.incl(frequency)
    else:
      echo frequency
      break
    #
    idx += 1
    if idx >= len(numbers):
      idx = 0
      iterations += 1
      # echo &"Number of iterations: {iterations}; set size: {seen.len}"
    #
  #

# ############################################################################

when isMainModule:
  main()
