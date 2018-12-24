import math
import sequtils
import strformat
import strutils

discard """

  I had no clue what Part 2 was doing so I needed some help here.
  I found a working Python solution and rewrote it in Nim.

  Python code:

    lines = open("input.txt").readlines()
    a, b = int(lines[22].split()[2]), int(lines[24].split()[2])
    n1 = 836 + 22 * a + b
    n2 = n1 + 10550400

    for n in (n1, n2):
        sqn = int(n ** .5)
        print(sum(d + n // d for d in range(1, sqn + 1) if n % d == 0) - sqn * (sqn ** 2 == n))

  From here: https://old.reddit.com/r/adventofcode/comments/a7j9zc/2018_day_19_solutions/ec45g4d/

"""

proc main() =
  let
    lines = readFile("input.txt").strip.splitLines
    (a, b) = (lines[22].split()[2].parseInt, lines[24].split()[2].parseInt)
    n1 = 836 + 22 * a + b
    n2 = n1 + 10550400

  for idx, n in [n1, n2]:
    let
      sqn = int(sqrt(n.float))

    echo &"Part {idx+1}: ", (1 .. sqn).toSeq().filterIt(n mod it == 0).mapIt(it + n div it).sum - sqn * (sqn^2 == n).int

# ############################################################################

when isMainModule:
  main()
