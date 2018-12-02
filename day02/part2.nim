import strutils
import sequtils


iterator combine(words: seq[string]): tuple[a: string, b: string] =
  for i in 0 .. (words.high - 1):
    for j in (i + 1) .. words.high:
      yield (words[i], words[j])

func hammingDistance(s1, s2: string): int =
  s1.zip(s2).filterIt(it.a != it.b).len

func getResult(s1, s2: string): string =
  s1.zip(s2).filterIt(it.a == it.b).mapIt(it.a).join

proc main() =
  let
    # lines = readFile("example2.txt").strip().splitlines()
    lines = readFile("input.txt").strip().splitlines()

  # echo lines

  for t in combine(lines):
    let
      (w1, w2) = t
      dist = hammingDistance(w1, w2)

    if dist == 1:
      # echo w1
      # echo w2
      # echo()
      echo getResult(w1, w2)
      break    # according to the exercise, there is only one pair
               # with distance 1, so we can stop when we found it

# ############################################################################

when isMainModule:
  main()
