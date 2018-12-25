type
  Point* = tuple
    col, row: int

  Interval* = tuple
    col1, col2, row1, row2: int

  Matrix* = seq[string]

const
  fountain*: Point = (col: 500, row: 0)
