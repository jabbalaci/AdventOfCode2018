import math
import sequtils
import strutils


type
  Matrix = seq[string]

proc `$`(m: Matrix): string =
  for line in m:
    result &= line
    result &= "\n"
  #
  result &= "-".repeat(78)

func get_adjacent(m: Matrix, row, col: int): string =
  try:
    result &= m[row-1][col-1]
  except IndexError:
    discard
  try:
    result &= m[row-1][col]
  except IndexError:
    discard
  try:
    result &= m[row-1][col+1]
  except IndexError:
    discard
  try:
    result &= m[row][col-1]
  except IndexError:
    discard
  try:
    result &= m[row][col+1]
  except IndexError:
    discard
  try:
    result &= m[row+1][col-1]
  except IndexError:
    discard
  try:
    result &= m[row+1][col]
  except IndexError:
    discard
  try:
    result &= m[row+1][col+1]
  except IndexError:
    discard

proc mutate(m: Matrix): Matrix =
  var copy = m
  #
  for i, row in m:
    for j, col in row:
      let cells = get_adjacent(m, i, j)
      if m[i][j] == '.':    # open acre
        if cells.count('|') >= 3:
          copy[i][j] = '|'
        #
      elif m[i][j] == '|':    # trees
        if cells.count('#') >= 3:
          copy[i][j] = '#'
        #
      elif m[i][j] == '#':    # lumberyard
        copy[i][j] = block:
          if cells.count('#') >= 1 and cells.count('|') >= 1:
            '#'
          else:
            '.'
  #
  copy

proc main() =
  let
    # lines = readFile("example1.txt").strip.splitlines
    lines = readFile("input.txt").strip.splitlines
    m = lines

  # echo m

  var current = m
  for i in 1 .. 10:
    current = current.mutate()
    # echo current

  let
    wooded = current.mapIt(it.count('|')).sum
    lumberyards = current.mapIt(it.count('#')).sum
    result = wooded * lumberyards

  echo result

# ############################################################################

when isMainModule:
  main()
