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

func get_values_in_square33(m: Matrix, p: Point): tuple[value, size: int] =
  var
    total = 0
    cnt = 0
    
  for row in 0 .. 2:
    for col in 0 .. 2:
      total += m[p.row + row][p.col + col]
      inc cnt
    #
  #
  (total, cnt)

func find_maximal_square33(m: Matrix): Point =
  var
    max_value = -1
    max_square33: Point = (0, 0)

  let
    until = SIZE - 3 + 1    # 298, incl.

  for row in 1 .. until:
    for col in 1 .. until:
      let
        (summed_value, _) = get_values_in_square33(m, (col: col, row: row))

      if summed_value > max_value:
        max_value = summed_value
        max_square33 = (col: col, row: row)
      #
    #
  #
  max_square33

proc main() =
  var
    m = create_matrix(SIZE)

  m = compute_hash_values(m)

  let square33 = find_maximal_square33(m)

  # echo square33
  # echo()
  echo "Part 1: $1,$2".format(square33.col, square33.row)

# ############################################################################

when isMainModule:
  main()
