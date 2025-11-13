import strutils, sequtils, math
echo readFile("../input.txt").strip.splitlines.map(parseInt).sum
