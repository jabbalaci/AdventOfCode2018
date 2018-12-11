import strutils
import sequtils
import math


const
  seed = 9424
  SIZE = 300    # the matrix is 300 x 300, indexing starts at 1
                # thus I create a matrix of size 301 x 301
                # to use indexes 1 .. 300

type
  Point = tuple
    col, row: int

  Matrix = seq[seq[int]]

func hash(p: Point): int =
  let
    rack_id = p.col + 10

  result = ($(($(((rack_id * p.row) + seed) * rack_id))[^3])).parseInt - 5

func create_matrix(size: int): Matrix =
  for i in 0 .. size:
    result &= newSeq[int](size + 1)

func compute_hash_values(m: Matrix): Matrix =
  var m = m
  for row in 1 .. SIZE:
    for col in 1 .. SIZE:
      m[row][col] = hash((col: col, row: row))
    #
  #
  m

func get_total_power_of_square(m: Matrix, top_left, bottom_right: Point): int =
  for row in top_left.row .. bottom_right.row:
    for col in top_left.col .. bottom_right.col:
      result += m[row][col]

func find_square_with_largest_total_power(m: Matrix, top_left: Point): tuple[value, size: int] =
  var
    max_power = -1
    max_size = -1
    
  for row in top_left.row .. SIZE:
    let
      diff = row - top_left.row
      bottom_right: Point = (col: top_left.col + diff, row: top_left.row + diff)

    if (bottom_right.col > SIZE) or (bottom_right.row > SIZE):
      continue
    # else
    let total_power = get_total_power_of_square(m, top_left, bottom_right)

    if total_power > max_power:
      max_power = total_power
      max_size = bottom_right.row - top_left.row + 1
    #
  #
  (max_power, max_size)

proc find_maximal_square(m: Matrix): tuple[p: Point, size: int] =
  var
    max_value = -1
    max_square: Point = (0, 0)
    max_size = 0

  for row in 1 .. SIZE:
    echo "# row: ", row
    for col in 1 .. SIZE:
      
      let
        (total_power, size) = find_square_with_largest_total_power(m, (col: col, row: row))

      if total_power > max_value:
        max_value = total_power
        max_square = (col: col, row: row)
        max_size = size
      #
    #
  #
  (max_square, max_size)

proc main() =
  var
    m = create_matrix(SIZE)

  m = compute_hash_values(m)

  let
    (square, size) = find_maximal_square(m)

  echo square
  echo size
  echo()
  echo "Part 2: $1,$2,$3".format(square.col, square.row, size)

# ############################################################################

when isMainModule:
  main()
