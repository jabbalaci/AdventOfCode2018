import strutils
import tables


func charCounter(s: string): Table[char, int] =
  result = initTable[char, int]()
  for c in s:
    if c notin result:
      result[c] = 0
    result[c] += 1

func hasValue(d: Table[char, int], value: int): bool =
  for v in d.values():
    if v == value:
      return true
    #
  #
  false

proc main() =
  let
    # lines = readFile("example1.txt").strip().splitlines()
    lines = readFile("input.txt").strip().splitlines()

  var
    doubles = 0
    triples = 0

  for line in lines:
    let d = charCounter(line)
    if d.hasValue(2):
      inc doubles
    if d.hasValue(3):
      inc triples

  echo doubles * triples

# ############################################################################

when isMainModule:
  main()
