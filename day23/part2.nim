import sequtils
import sets
import strscans
import strutils

discard """

  solution for my input:

  (x: 13839482, y: 57977321, z: 25999544)
  this point is in range of 978 nanobots

  Runtime: 513.98 sec

"""

type
  Point3d = tuple
    x, y, z: int

  Bot = tuple
    pos: Point3d
    r: int

  Candidate = tuple
    in_range: int
    pos: Point3d

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

# class Finder ##############################################################

type
  Finder = ref object
    cand: Candidate
    bots: seq[Bot]
    skip_set: HashSet[Point3d]

proc newFinder(cand: Candidate, bots: seq[Bot]): Finder =
  new result
  result.cand = cand
  result.bots = bots
  result.skip_set = initSet[Point3d]()

func get_neighbors(self: Finder, pos: Point3d): seq[Point3d] =
  let
    (x, y, z) = (pos.x, pos.y, pos.z)

  var points = newSeq[Point3d]()
  for i in -1 .. 1:
    points &= (x-1, y-1, z+i)
    points &= (x, y-1, z+i)
    points &= (x+1, y-1, z+i)
    points &= (x-1, y, z+i)
    points &= (x+1, y, z+i)
    points &= (x-1, y+1, z+i)
    points &= (x, y+1, z+i)
    points &= (x+1, y+1, z+i)
  #
  result = points.filterIt(it notin self.skip_set)

func get_ranges(self: Finder, p: Point3d): int =
  for bot in self.bots:
    if distance_between(p, bot.pos) <= bot.r:
      result += 1

proc select_best_neighbor(self: Finder, curr: Candidate, neighbors: seq[Point3d]): Candidate =
  var best = curr
  for nb in neighbors:
    let in_range = self.get_ranges(nb)
    if in_range > best.in_range:
      best = (in_range: in_range, pos: nb)
    elif in_range == best.in_range:
      if distance_between((0, 0, 0), nb) < distance_between((0, 0, 0), best.pos):
        best.pos = nb
  #
  result = best
  #
  self.skip_set.clear()
  let pos = best.pos
  for nb in neighbors:
    if nb == pos:
      continue
    # else
    self.skip_set.incl(nb)

proc start(self: Finder) =
  var
    curr = self.cand
    cnt = 0

  while true:
    let
      neighbors = self.get_neighbors(curr.pos)
      best = self.select_best_neighbor(curr, neighbors)

    cnt += 1
    if cnt mod 50_000 == 0:
      echo "# best: ", best

    if best == curr:
      echo "# result: ", best
      echo()
      break
    else:
      curr = best
  # endwhile

  let result = curr.pos.x + curr.pos.y + curr.pos.z
  echo "Part 2: ", result

# endclass Finder ###########################################################

func get_ranges(p: Point3d, bots: seq[Bot]): int =
  for bot in bots:
    if distance_between(p, bot.pos) <= bot.r:
      result += 1

proc find_best_candidate(bots: seq[Bot]): Candidate =
  var
    maxi = -1
    closest_elem: Point3d

  for bot in bots:
    let
      p = bot.pos
      in_range = get_ranges(p, bots)
    
    if in_range > maxi:
      maxi = in_range
      closest_elem = p
      # echo (in_range, closest_elem)
    elif in_range == maxi:
      if distance_between((0, 0, 0), p) < distance_between((0, 0, 0), closest_elem):
        closest_elem = p
      # echo (in_range, closest_elem)
  # endfor
  result = (in_range: maxi, pos: closest_elem)

proc main() =
  let
    # example:
    # lines = readFile("example2.txt").strip.splitlines
    # bots = read_bots(lines)
    # candidate = find_best_candidate(bots)

    # my input:
    lines = readFile("input.txt").strip.splitlines
    bots = read_bots(lines)
    candidate = find_best_candidate(bots)

  echo "# starting point: ", candidate

  var
    finder = newFinder(candidate, bots)

  finder.start()

# ############################################################################

when isMainModule:
  main()
