import strutils
import strformat
import sequtils
import sets


proc main() =
  let
    text = readFile("input.txt").strip().splitlines()
    # text = readFile("example.txt").strip().splitlines()
    numbers = text.mapIt(it.parseInt)

  # echo numbers

  var
    frequency = 0
    seen = toSet([frequency])
    idx = 0
    iterations = 1

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
