import math
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

func distance_between(p1, p2: Point): int =
  abs(p1.x - p2.x) + abs(p1.y - p2.y)

func calculate_dist_from_all_points(curr: Point, points: seq[Point]): int =
  points.mapIt(distance_between(curr, it)).sum

func fill_matrix_using_distance_info(matrix: Matrix,
                                     points: seq[Point],
                                     limit: int): Matrix =
  var m = matrix
  
  for i in 0 .. m.high:
    var row = m[i]
    for j in 0 .. row.high:
      let (x_mod, y_mod) = (j, i)    # x_mod, y_mod follows the coordinates of the points
                                     # i.e., (0, 0) is in the top left corner
      let
        dist_from_all_points = calculate_dist_from_all_points((x_mod, y_mod), points)
        value_to_set = if dist_from_all_points < limit: 1 else: 0
          
      m[i][j] = value_to_set
  #
  m

func get_area(m: Matrix): int =
  m.mapIt(it.sum).sum

proc main() =
  let
    # (lines, limit) = (readFile("example1.txt").strip.splitlines, 32)
    (lines, limit) = (readFile("input.txt").strip.splitlines, 10_000)
    coordinates = get_coordinates(lines)
    (_, bottom_right) = find_corners(coordinates)

  var
    matrix = build_matrix(bottom_right)

  matrix = fill_matrix_using_distance_info(matrix, coordinates, limit)

  let
    result = get_area(matrix)

  # for row in matrix:
    # echo row

  echo result

# ############################################################################

when isMainModule:
  main()
