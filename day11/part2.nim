import strutils
import sequtils


const
  seed = 9424   # my input
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
  result = m

func find_square_with_largest_total_power(m: Matrix, top_left: Point): tuple[value, size: int] =
  var
    curr_power = m[top_left.row][top_left.col]    # this is what we'll increase instead of
                                                  # re-calculating the whole total power of a square
    max_power = curr_power
    max_size = 1

  for row in (top_left.row + 1) .. SIZE:
    let
      diff = row - top_left.row
      bottom_right: Point = (col: top_left.col + diff, row: top_left.row + diff)

    if (bottom_right.col > SIZE) or (bottom_right.row > SIZE):
      continue
    # else
    block:
      let
        row = top_left.row + diff
        col = top_left.col + diff

      for i in 0 ..< diff:
        curr_power += m[row][top_left.col + i]
        curr_power += m[top_left.row + i][col]
      #
      # don't forget the bottom right corner's cell:
      curr_power += m[bottom_right.row][bottom_right.col]
    # endblock

    if curr_power > max_power:
      max_power = curr_power
      max_size = bottom_right.row - top_left.row + 1
    #
  #
  (max_power, max_size)

func find_maximal_square(m: Matrix): tuple[p: Point, size: int] =
  var
    max_value = -1
    max_square: Point = (0, 0)
    max_size = 0

  for row in 1 .. SIZE:
    # echo "# row: ", row
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
  let
    m = create_matrix(SIZE).compute_hash_values()
    (square, size) = find_maximal_square(m)

  # echo square
  # echo size
  # echo()
  echo "Part 2: $1,$2,$3".format(square.col, square.row, size)

# ############################################################################

when isMainModule:
  main()
