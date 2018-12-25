import strscans
import strutils
import types


proc read_intervals*(lines: seq[string]): seq[Interval] =
  var a, b, c: int
  for line in lines:
    if line.scanf("x=$i, y=$i..$i", a, b, c):
      result &= (col1: a, col2: a, row1: b, row2: c)
    elif line.scanf("y=$i, x=$i..$i", a, b, c):
      result &= (col1: b, col2: c, row1: a, row2: a)
    else:
      echo "Error in line ", line
      quit(1)

proc find_corners*(intervals: seq[Interval]): tuple[top_left, bottom_right: Point] =
  var
    row_min = 0
    row_max = -1
    col_min = int.high
    col_max = -1

  for t in intervals:
    if t.col1 < col_min:
      col_min = t.col1
    if t.col2 > col_max:
      col_max = t.col2
    if t.row2 > row_max:
      row_max = t.row2
  #
  ((col_min-1, row_min), (col_max+1, row_max))    # +1 column on both sides for the margins

proc find_top_and_bottom_rows*(intervals: seq[Interval]): tuple[top_row, bottom_row: int] =
  var
    row_min = int.high
    row_max = -1

  for t in intervals:
    if t.row1 < row_min:
      row_min = t.row1
    if t.row2 > row_max:
      row_max = t.row2
  #
  (row_min, row_max)

proc create_matrix*(intervals: seq[Interval], bottom_right: Point): Matrix =
  for row in 0 .. bottom_right.row + 1:
    result &= ".".repeat(bottom_right.col+1)
  #
  result[fountain.row][fountain.col] = '+'    # fountain
  #
  for t in intervals:
    for row in t.row1 .. t.row2:
      for col in t.col1 .. t.col2:
        result[row][col] = '#'
