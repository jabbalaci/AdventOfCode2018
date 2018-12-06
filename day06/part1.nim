import strutils
import sequtils
import tables


type
  Point = tuple
    x, y: int

  Matrix = seq[seq[int]]


func get_coordinates(lines: seq[string]): seq[Point] =
  for line in lines:
    let parts = line.split(", ")
    result &= (x: parts[0].parseInt, y: parts[1].parseInt)


func find_corners(points: seq[Point]): tuple[top_left, bottom_right: Point] =
  let
    xs = points.mapIt(it.x)
    ys = points.mapIt(it.y)
    top_left = (xs.min, ys.min)
    bottom_right = (xs.max, ys.max)

  (top_left, bottom_right)


func build_matrix(bottom_right: Point): Matrix =
  for row in 0 .. bottom_right.y:
    result &= newSeq[int](bottom_right.x + 2)
  #
  for i in 0 .. result.high:
    var row = result[i]
    for j in 0 .. row.high:
      result[i][j] = -1


func distance_between(p1, p2: Point): int =
  abs(p1.x - p2.x) + abs(p1.y - p2.y)


func calculate_distances(curr: Point, points: seq[Point]): seq[int] =
  for p in points:
    result &= distance_between(curr, p)


func fill_matrix_using_distance_info(matrix: Matrix, points: seq[Point]): Matrix =
  var m = matrix
  
  for i in 0 .. m.high:
    var row = m[i]
    for j in 0 .. row.high:
      let (x_mod, y_mod) = (j, i)    # x_mod, y_mod follows the coordinates of the points
                                     # i.e., (0, 0) is in the top left corner
      let
        distances = calculate_distances((x_mod, y_mod), points)
        dist_to_set = block:
          let mini = distances.min
          if distances.count(mini) > 1:    # closest to two locations
            -1
          else:
            distances.find(mini)    # index of the smallest element
      # echo (i, j), distances, dist_to_set
      m[i][j] = dist_to_set
  #
  m


func get_largest_area(m: Matrix, top_left, bottom_right: Point): int =
  var d = initTable[int, int]()
  
  let
    (first_col, first_row) = top_left
    (last_col, last_row) = bottom_right

  for i in first_row .. last_row:
    for j in first_col .. last_col:
      let value = m[i][j]
      if value notin d:
        d[value] = 0
      d[value] += 1
    #
  #
  toSeq(d.values()).max


proc main() =
  let
    # lines = readFile("example1.txt").strip.splitlines
    lines = readFile("input.txt").strip.splitlines
    coordinates = get_coordinates(lines)
    (top_left, bottom_right) = find_corners(coordinates)

  var
    matrix = build_matrix(bottom_right)

  # for p in coordinates:
    # let (y_mod, x_mod) = p
    # matrix[x_mod][y_mod] = -9

  matrix = fill_matrix_using_distance_info(matrix, coordinates)

  let
    result = get_largest_area(matrix, top_left, bottom_right)

  # echo coordinates
  # echo top_left, bottom_right

  # for row in matrix:
    # echo row

  echo result

# ############################################################################

when isMainModule:
  main()
