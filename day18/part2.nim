import math
import sequtils
import strformat
import strutils


const
  ITERATION = 1_000_000_000    # 1 billion

type
  Matrix = seq[string]

  Repetition = tuple
    values: seq[int]
    start_idx: int

proc `$`(m: Matrix): string =
  for line in m:
    result &= line
    result &= "\n"
  #
  result &= "-".repeat(78)

func total_resource_value(m: Matrix): int =
  let
    wooded = m.mapIt(it.count('|')).sum
    lumberyards = m.mapIt(it.count('#')).sum

  wooded * lumberyards

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

  var previous = @[-1]    # thus indexing starts at 1
  var current = m
  var rep: Repetition

  for i in 1 .. ITERATION:
    current = current.mutate()
    let value = current.total_resource_value()
    # echo value
    # wait a bit until the forest stabilizes:
    if i > 428:    # found with manual inspection, using trial and error
      if value notin previous:
        previous &= value
      else:
        # echo &"The value {value} was already found once."
        let
          prev_idx = previous.find(value)
          diff = i - prev_idx
        # echo &"Previous minute: ", prev_idx
        # echo "Current minute: ", i
        # echo "Difference in minutes: ", diff
        rep.values = previous[prev_idx .. previous.high]
        rep.start_idx = prev_idx
        break
    else:
      previous &= -1    # just to fill the seq to have correct index values when using previous.find()
  # endfor

  # echo rep
  # echo rep.values.len

  let
    idx = (ITERATION - rep.start_idx) mod rep.values.len
    result = rep.values[idx]

  # echo idx
  echo result

# ############################################################################

when isMainModule:
  main()
