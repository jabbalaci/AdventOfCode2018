import strutils
import strformat
import sequtils
import tables


type
  Claim = tuple
    id: int
    offsetX, offsetY: int
    width, height: int

  Matrix = seq[seq[int]]


func lchop*(s, sub: string): string =
  if s.startsWith(sub):
    s[sub.len .. s.high]
  else:
    s

func rchop*(s, sub: string): string =
  if s.endsWith(sub):
    s[0 ..< ^sub.len]
  else:
    s


proc read_claims(lines: seq[string]): seq[Claim] =
  for line in lines:
    let
      parts = line.splitWhitespace()
      id = parts[0].lchop("#").parseInt
      positions = parts[2].rchop(":").split(',').map(parseInt)
      sizes = parts[3].split('x').map(parseInt)
    
    result &= (id, positions[0], positions[1], sizes[0], sizes[1])

proc required_dimension(claims: seq[Claim]): tuple[width, height: int] =
  var
    w, h = 0

  for cl in claims:
    if cl.offsetX + cl.width > w:
      w = cl.offsetX + cl.width
    if cl.offsetY + cl.height > h:
      h = cl.offsetY + cl.height

  (w, h)

func create_matrix(width, height: int): Matrix =
  for i in 1 .. width:
    result &= newSeq[int](height)

proc fill_matrix_with_claims(m: Matrix, claims: seq[Claim]): Matrix =
  var m = m
  #
  for cl in claims:
    let
      row = cl.offsetY
      col = cl.offsetX

    for i in 0 ..< cl.width:
      for j in 0 ..< cl.height:
        let
          posX = row + j
          posY = col + i
          old_value = m[posX][posY]
        
        if old_value == 0:    # free cell
          m[posX][posY] = cl.id
        else:                 # occupied
          m[posX][posY] = -1  # overlapped
  #
  m

func number_of_overlapped_cells(m: Matrix): int =
  for line in m:
    result += line.filterIt(it == -1).len

proc build_area_dict(m: Matrix): Table[int, int] =
  result = initTable[int, int]()
  for line in m:
    for val in line:
      result[val] = result.getOrDefault(val, 0) + 1

proc get_claim_id_that_doesnt_overlap(m: Matrix, claims: seq[Claim]): int =
  let d = build_area_dict(m)    # ID -> occupied_area

  for cl in claims:
    let
      expected_area = cl.width * cl.height
      got_area = d.getOrDefault(cl.id, 0)

    if expected_area == got_area:
      return cl.id
    #
  #
  -1    # No such claim was found. According to the exercise, there is exactly 1 claim
        # that is not overlapping, so we should never get here.

proc main() =
  let
    # lines = readFile("example1.txt").strip().splitlines()
    lines = readFile("input.txt").strip().splitlines()
    claims = read_claims(lines)
    (requiredWidth, requiredHeight) = required_dimension(claims)

  var
    matrix = create_matrix(requiredWidth, requiredHeight)

  matrix = fill_matrix_with_claims(matrix, claims)

  # for line in matrix:
    # echo line
  
  let
    overlapped_cells = number_of_overlapped_cells(matrix)
    intact_claim_id = get_claim_id_that_doesnt_overlap(matrix, claims)

  echo &"Part 1: {overlapped_cells}"
  echo &"Part 2: {intact_claim_id}"

# ############################################################################

when isMainModule:
  main()
