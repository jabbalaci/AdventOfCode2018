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
    dist: int

proc read_bots(lines: seq[string]): seq[Bot] =
  var x, y, z, r: int
  for line in lines:
    if line.scanf("pos=<$i,$i,$i>, r=$i", x, y, z, r):
      result &= (pos: (x, y, z), r: r, dist: -1)
    else:
      echo "Problem with line ", line
      quit(1)

func distance_between(b1, b2: Bot): int =
  abs(b1.pos.x - b2.pos.x) + abs(b1.pos.y - b2.pos.y) + abs(b1.pos.z - b2.pos.z)

func get_bots_with_diffs(strongest: Bot, bots: seq[Bot]): seq[Bot] =
  for bot in bots:
    result &= (pos: bot.pos, r: bot.r, dist: distance_between(bot, strongest))

proc main() =
  let
    # lines = readFile("example1.txt").strip.splitlines
    lines = readFile("input.txt").strip.splitlines

    bots = read_bots(lines)
    strongest_bot = sorted(bots, (b1, b2) => b1.r - b2.r, order=Descending)[0]
    bots_with_diff = get_bots_with_diffs(strongest_bot, bots)
    part1_result = bots_with_diff.filterIt(it.dist <= strongest_bot.r).len

  # for bot in bots_with_diff:
    # echo bot
  # echo()
  # echo strongest_bot

  echo part1_result

# ############################################################################

when isMainModule:
  main()
