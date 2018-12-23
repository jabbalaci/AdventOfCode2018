import algorithm
import sequtils
import strscans
import strutils
import sugar


type
  Point3d = tuple
    x, y, z: int

  Bot = tuple
    pos: Point3d
    r: int

proc read_bots(lines: seq[string]): seq[Bot] =
  var x, y, z, r: int
  for line in lines:
    if line.scanf("pos=<$i,$i,$i>, r=$i", x, y, z, r):
      result &= (pos: (x, y, z), r: r)
    else:
      echo "Problem with line ", line
      quit(1)

func distance_between(p1, p2: Point3d): int =
  abs(p1.x - p2.x) + abs(p1.y - p2.y) + abs(p1.z - p2.z)

proc main() =
  let
    # lines = readFile("example2.txt").strip.splitlines
    lines = readFile("input.txt").strip.splitlines

    bots = read_bots(lines)
    bots_sorted_x = sorted(bots, (b1, b2) => b1.pos.x - b2.pos.x)
    (x_min, x_max) = (bots_sorted_x[0].pos.x, bots_sorted_x[^1].pos.x)
    x_diff = x_max - x_min + 1
    bots_sorted_y = sorted(bots, (b1, b2) => b1.pos.y - b2.pos.y)
    (y_min, y_max) = (bots_sorted_y[0].pos.y, bots_sorted_y[^1].pos.y)
    y_diff = y_max - y_min + 1
    bots_sorted_z = sorted(bots, (b1, b2) => b1.pos.z - b2.pos.z)
    (z_min, z_max) = (bots_sorted_z[0].pos.z, bots_sorted_z[^1].pos.z)
    z_diff = z_max - z_min + 1
    x_uniq = bots.mapIt(it.pos.x).deduplicate
    y_uniq = bots.mapIt(it.pos.y).deduplicate
    z_uniq = bots.mapIt(it.pos.z).deduplicate

  for bot in bots:
    echo bot
  echo()
  echo (x_min, x_max)
  echo (y_min, y_max)
  echo (z_min, z_max)

  # echo x_diff * y_diff * z_diff

  # var cnt = 0
  # for x in x_min .. x_max:
    # for y in y_min .. y_max:
      # for z in z_min .. z_max:
        # inc cnt
      #
    #
  #
  # echo cnt

  echo (x_uniq, y_uniq, z_uniq)
  echo (x_uniq.len * y_uniq.len * z_uniq.len)

  var
    maxi = -1
    closest_elem: Point3d

  for idx, x in x_uniq:
    echo "# ", idx
    for y in y_uniq:
      for z in z_uniq:
        var cnt = 0
        let p: Point3d = (x, y, z)
        for bot in bots:
          if distance_between(p, bot.pos) <= bot.r:
            cnt += 1
          #
        #
        if cnt > maxi:
          maxi = cnt
          closest_elem = p
          echo (cnt, closest_elem)
        elif cnt == maxi:
          if distance_between((0, 0, 0), p) < distance_between((0, 0, 0), closest_elem):
            closest_elem = p
          echo (cnt, closest_elem)
      #
    #
  #

  # It found a point in 6479 seconds: (Field0: 899, Field1: (x: 16910438, y: 59478255, z: 27569571))
  # this point is in range of 899 nanobots
  # However, it's not the correct solution, its x+y+z value is too high.

# ############################################################################

when isMainModule:
  main()
