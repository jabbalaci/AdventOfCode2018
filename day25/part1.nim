import math
import sequtils
import strformat
import strscans
import strutils


const
  dist_limit = 3

type
  Point = tuple
    a, b, c, d: int

  Cluster = seq[Point]

  Galaxy = seq[Cluster]

func distance(p1, p2: Point): int =
  abs(p1.a - p2.a) + abs(p1.b - p2.b) + abs(p1.c - p2.c) + abs(p1.d - p2.d)

proc extract_points(lines: seq[string]): seq[Point] =
  var
    a, b, c, d: int

  for line in lines:
    if line.scanf("$i,$i,$i,$i", a, b, c, d):
      result &= (a, b, c, d)
    else:
      echo "Error with line ", line
      quit(1)

proc fill_clusters(points: seq[Point]): Galaxy =
  var clusters = newSeq[Cluster]()

  for curr in points:
    var found = false
    block find_cluster:
      for cl in clusters.mitems():
        for p in cl:
          if curr.distance(p) <= dist_limit:
            found = true
            cl &= curr
            break find_cluster
          #
        #
      #
    #
    if not found:
      clusters &= @[curr]
  #
  result = clusters

proc display(cl: Cluster, idx: int) =
  echo &"Cluster {idx}:"
  for p in cl:
    echo p
  #
  echo "-".repeat(78)

func close_to(cl1, cl2: Cluster): bool =
  for p1 in cl1:
    for p2 in cl2:
      if p1.distance(p2) <= dist_limit:
        return true
      #
    #
  #
  false

func size(g: Galaxy): int =
  g.mapIt(it.len).sum

proc join_clusters(g: Galaxy): Galaxy =
  var
    clusters = g
    changed = true
    cnt = 0

  while changed:
    cnt += 1
    changed = false
    # echo "Size: ", clusters.size()
    for i in 0 .. (clusters.high - 1):
      for j in (i + 1) .. clusters.high:
        if clusters[i].close_to(clusters[j]):
          for p in clusters[j]:
            clusters[i] &= p
            changed = true
          #
          clusters[j] = @[]
        #
      #
    #
    clusters = clusters.filterIt(it.len > 0)
  #
  echo "# repetitions: ", cnt
  #
  result = clusters

proc main() =
  let
    # lines = readFile("example4.txt").strip.splitlines.filterIt(not it.startsWith('#'))
    lines = readFile("input.txt").strip.splitlines

    points = extract_points(lines)
    clusters: Galaxy = fill_clusters(points)
    joined_clusters: Galaxy = join_clusters(clusters)

  # for idx, cl in joined_clusters:
    # cl.display(idx+1)

  echo "Part 1: ", joined_clusters.len

# ############################################################################

when isMainModule:
  main()
