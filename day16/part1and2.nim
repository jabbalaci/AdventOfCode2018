import sequtils
import sets
import strformat
import strscans
import strutils
import tables


type
  Quad = array[4, int]

  Parameters = tuple
    a, b, c: int

  Sample = tuple
    before, input, after: Quad

  # function pointer
  Fptr = (func(x: Quad, y: Parameters): Quad)


proc extract_samples(lines: seq[string]): seq[Sample] =
  var
    a, b, c, d: int
    t1, t2, t3: Quad

  for i in 0 ..< (lines.len div 3):
    let
      idx = i * 3
      line1 = lines[idx]
      line2 = lines[idx + 1]
      line3 = lines[idx + 2]

    if line1.scanf("Before: [$i, $i, $i, $i]", a, b, c, d):
      t1 = [a, b, c, d]
    else:
      echo "Error with line ", line1
      quit(1)
    #
    if line2.scanf("$i $i $i $i", a, b, c, d):
      t2 = [a, b, c, d]
    else:
      echo "Error with line ", line2
      quit(1)
    #
    if line3.scanf("After:  [$i, $i, $i, $i]", a, b, c, d):
      t3 = [a, b, c, d]
    else:
      echo "Error with line ", line3
      quit(1)
    #
    result &= (before: t1, input: t2, after: t3)

proc extract_program(lines: seq[string]): seq[Quad] =
  var
    a, b, c, d: int

  for line in lines:
    if line.scanf("$i $i $i $i", a, b, c, d):
      result &= [a, b, c, d]
    else:
      echo "Error with line ", line
      quit(1)

func get_parameters(instruction: Quad): Parameters =
  (instruction[1], instruction[2], instruction[3])

func get_opcode(instruction: Quad): int =
  instruction[0]

proc clean_opcodes(d: Table[int, HashSet[string]]): Table[int, string] =
  var d = d
  result = initTable[int, string]()

  while true:
    for k, v in d:
      if v.len == 1:
        let value = toSeq(v)[0]
        result[k] = value
        for k2, v2 in d:
          if value in v2:
            d[k2] = toSet(toSeq(v2).filterIt(it != value))
          #
        #
      #
    #
    if result.len == 16:
      break
  #

# opcodes (0-15) ############################################################

# `addr` is the name of a built-in operator, so I had to rename this function
func my_addr(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = result[a] + result[b]

func addi(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = result[a] + b

func mulr(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = result[a] * result[b]

func muli(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = result[a] * b

func banr(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = result[a] and result[b]

func bani(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = result[a] and b

func borr(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = result[a] or result[b]

func bori(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = result[a] or b

func setr(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = result[a]

func seti(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = a

func gtir(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = if a > result[b]: 1 else: 0

func gtri(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = if result[a] > b: 1 else: 0

func gtrr(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = if result[a] > result[b]: 1 else: 0

func eqir(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = if a == result[b]: 1 else: 0

func eqri(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = if result[a] == b: 1 else: 0

func eqrr(register: Quad, parameters: Parameters): Quad =
  result = register
  let (a, b, c) = parameters
  #
  result[c] = if result[a] == result[b]: 1 else: 0

# ###########################################################################

proc main() =
  let
    # content = readFile("example1.txt").strip
    content = readFile("input.txt")
    parts = content.split("\n\n\n")
    lines_part1 = parts[0].strip.splitLines.filterIt(it.len > 0)
    samples = extract_samples(lines_part1)
    program: seq[Quad] = extract_program(parts[1].strip.splitLines)
    # array of instructions:
    instruction_names = ["my_addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori",
                  "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr"]
    instructions = [my_addr, addi, mulr, muli, banr, bani, borr, bori,
                    setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr]
  # endlet

  var
    total = 0
    opcodes = initTable[int, HashSet[string]]()

  for sample in samples:
    # echo sample
    var same = 0
    for idx, inst in instructions:
      let value = inst(sample.before, get_parameters(sample.input))
      if value == sample.after:
        same += 1
        let key = get_opcode(sample.input)
        if key notin opcodes:
          opcodes[key] = initSet[string]()
        opcodes[key].incl(instruction_names[idx])
      #
    #
    if same >= 3:
      total += 1
    # break
  # endfor

  echo "Part 1: ", total

  let
    opcodes2 = clean_opcodes(opcodes)
    instructions2 = block:
      var t: array[16, Fptr]
      for k, v in opcodes2:
        t[k] = instructions[instruction_names.find(v)]
      #
      t

  # echo opcodes2

  var
    current: Quad = [0, 0, 0, 0]

  for line in program:
    let (opcode, parameters) = (get_opcode(line), get_parameters(line))
    current = instructions2[opcode](current, parameters)
  #
  # echo current
  echo "Part 2: ", current[0]

# ############################################################################

when isMainModule:
  main()
