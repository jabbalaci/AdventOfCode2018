import sequtils
import sets
import strformat
import strscans
import strutils


type
  Star = tuple
    posCol, posRow: int
    velCol, velRow: int

  Sky = tuple
    stars: seq[Star]
    top_left, bottom_right: Star
    area: int

proc extract_stars_info(lines: seq[string]): seq[Star] =
  for line in lines:
    var a, b, c, d: int
    if line.scanf("position=<$s$i,$s$i> velocity=<$s$i,$s$i>", a, b, c, d):
      result &= (a, b, c, d)

func find_corners(stars: seq[Star]): tuple[top_left: Star, bottom_right: Star] =
  let
    cols = stars.mapIt(it.posCol)
    rows = stars.mapIt(it.posRow)
    top_left = (posCol: cols.min, posRow: rows.min, velCol: 0, velRow: 0)
    bottom_right = (posCol: cols.max, posRow: rows.max, velCol: 0, velRow: 0)

  (top_left, bottom_right)
  
func calculate_area(top_left, bottom_right: Star): int =
  let
    width = bottom_right.posCol - top_left.posCol
    height = bottom_right.posRow - top_left.posRow

  width * height

proc init_sky(stars: seq[Star]): Sky =
  let
    (top_left, bottom_right) = find_corners(stars)
    area = calculate_area(top_left, bottom_right)

  (stars: stars, top_left: top_left, bottom_right: bottom_right, area: area)

proc move_the_sky(sky: Sky): Sky =
  let
    stars = sky.stars.mapIt((it.posCol + it.velCol, it.posRow + it.velRow, it.velCol, it.velRow))
    (top_left, bottom_right) = find_corners(stars)
    area = calculate_area(top_left, bottom_right)

  (stars: stars, top_left: top_left, bottom_right: bottom_right, area: area)

proc write_to_csv(sky: Sky) =
  var f = open("visualization/stars.csv", fmWrite)

  f.writeLine("x, y")
  for star in sky.stars:
    f.writeLine(&"{star.posCol}, {star.posRow}")

  f.close()
  
proc show_result(sky: Sky) =
  let points = block:
    var bag = initSet[tuple[col, row: int]]()
    for star in sky.stars:
      bag.incl((star.posCol, star.posRow))
    bag

  for row in sky.top_left.posRow .. sky.bottom_right.posRow:
    for col in sky.top_left.posCol .. sky.bottom_right.posCol:
      if (col, row) in points:
        stdout.write('#')
      else:
        stdout.write('.')
    #
    echo()
  #
  # echo sky.top_left
  # echo sky.bottom_right

proc main() =
  let
    # lines = readFile("example1.txt").strip.splitlines
    lines = readFile("input.txt").strip.splitlines
    #
    stars = extract_stars_info(lines)

  var
    sky = init_sky(stars)
    prev = sky
    minimum_area = sky.area

  # echo lines
  # for star in stars:
    # echo star

  # echo sky.area

  var cnt = 0
  while true:
    sky = move_the_sky(sky)
    # echo sky.area

    if sky.area < minimum_area:
      minimum_area = sky.area
      prev = sky
    else:
      # echo sky
      break

    cnt += 1
  # endwhile

  let result = prev

  # write_to_csv(result)
  show_result(result)
  echo()
  # echo "minimum area: ", minimum_area
  echo &"found after {cnt} seconds"

# ############################################################################

when isMainModule:
  main()
