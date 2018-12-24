import math
import sequtils
import strformat
import strutils


const
  RegionValues = ['.', '=', '|']

type
  Region = enum
    rgRocky,
    rgWet,
    rgNarrow,

  Point = tuple
    col, row: int

  Data = tuple
    depth: int
    target: Point

  Matrix = seq[seq[int]]

func create_matrix(data: Data): Matrix =
  let
    rows = data.target.row
    cols = data.target.col

  for i in 0 .. rows:
    var row = newSeq[int](cols + 1)
    result &= row

func calculate_geological_index(m: Matrix, data: Data, row, col: int): int =
  if (row == 0) and (col == 0):
    return 0
  if (row == data.target.row) and (col == data.target.col):
    return 0
  if row == 0:
    return col * 16_807
  if col == 0:
    return row * 48_271
  # else
  m[row][col-1] * m[row-1][col]

proc compute_erosion_levels(m: Matrix, data: Data): Matrix =
  var m = m    # copy
  #
  for row_idx, row in m:
    for col_idx, col in row:
      let
        gi = calculate_geological_index(m, data, row_idx, col_idx)

      m[row_idx][col_idx] = (gi + data.depth) mod 20_183
    #
  #
  result = m

func calculate_risk_level(m: Matrix): int =
  for row in m:
    result += row.mapIt(it mod 3).sum

proc display(m: Matrix) =
  for row in m:
    let line = row.mapIt(RegionValues[it mod 3]).join
    echo line
  #
  echo "-".repeat(40)

proc main() =
  let
    # data: Data = (depth: 510, target: (10, 10))    # example1
    data: Data = (depth: 11_109, target: (9, 731))    # my input

  let
    m0 = create_matrix(data)
    m = compute_erosion_levels(m0, data)
    part1_result = calculate_risk_level(m)

  # m.display()
  echo "Part 1: ", part1_result

# ############################################################################

when isMainModule:
  main()
