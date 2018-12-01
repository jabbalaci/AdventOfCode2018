import intsets
import math
import sequtils
import sets
import strformat
import strutils
import times

# see lib/ for a local copy
from itertools import cycle    # nimble install itertools


proc main() =
  let
    lines = readFile("input.txt").strip().splitlines()
    # text = readFile("example.txt").strip().splitlines()
    numbers = lines.map(parseInt)

  # echo numbers

  var
    frequency = 0
    # thanks to narimiran for figuring out how to speed up the sets
    # seen = initSet[int](2 ^ 17)    # 131_072
    seen = initIntSet()

  seen.incl(frequency)

  for n in numbers.cycle():
    frequency += n
    if frequency notin seen:
      seen.incl(frequency)
    else:
      echo frequency
      break

# ############################################################################

when isMainModule:
  let t0 = epochTime()
  main()
  let t1 = epochTime()
  echo &"# elapsed time: {t1 - t0} sec."
