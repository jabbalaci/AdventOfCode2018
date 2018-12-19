import strutils    # strip, split, join
import strformat   # &"Hello {name}!"
import sequtils    # toSeq(iter), map, filter
import strscans
# import math        # sum
# import algorithm   # sorted(seq), reversed(seq)
# import tables
# import sets

# import pykot
# import pykot/[console, converters, euler, fs, functional,
#               pretty, process, jrandom, strings, jsystem, types, web]

# class Computer ############################################################

type
  Instruction = tuple
    name: string
    a, b, c: int

  Parameters = tuple
    a, b, c: int

  Computer = ref object
    ip: int
    ip_reg: int    # register bound to the ip
    program: seq[Instruction]
    registers: array[6, int]

func get_parameters(self: Computer, instruction: Instruction): Parameters =
  (instruction.a, instruction.b, instruction.c)

func get_instruction_name(self: Computer, instruction: Instruction): string =
  instruction.name

proc before_instruction(self: Computer) =
  self.registers[self.ip_reg] = self.ip

proc after_instruction(self: Computer) =
  self.ip = self.registers[self.ip_reg]
  self.ip += 1

proc setr(self:Computer, parameters: Parameters) =
  let (a, b, c) = parameters
  #
  self.registers[c] = self.registers[a]

proc seti(self:Computer, parameters: Parameters) =
  let (a, b, c) = parameters
  #
  self.registers[c] = a

proc my_addr(self: Computer, parameters: Parameters) =
  let (a, b, c) = parameters
  #
  self.registers[c] = self.registers[a] + self.registers[b]

proc addi(self: Computer, parameters: Parameters) =
  let (a, b, c) = parameters
  #
  self.registers[c] = self.registers[a] + b

proc mulr(self: Computer, parameters: Parameters) =
  let (a, b, c) = parameters
  #
  self.registers[c] = self.registers[a] * self.registers[b]

proc muli(self: Computer, parameters: Parameters) =
  let (a, b, c) = parameters
  #
  self.registers[c] = self.registers[a] * b

proc eqrr(self: Computer, parameters: Parameters) =
  let (a, b, c) = parameters
  #
  self.registers[c] = if self.registers[a] == self.registers[b]: 1 else: 0

proc gtrr(self: Computer, parameters: Parameters) =
  let (a, b, c) = parameters
  #
  self.registers[c] = if self.registers[a] > self.registers[b]: 1 else: 0

proc newComputer(lines: seq[string]): Computer =
  new result
  result.program = newSeq[Instruction]()
  if not lines[0].scanf("#ip $i", result.ip_reg):
    echo "Error with line ", lines[0]
    quit(1)
  var
    name: string
    a, b, c: int
  for line in lines[1 .. lines.high]:
    if line.scanf("$w $i $i $i", name, a, b, c):
      result.program &= (name, a, b, c)
    else:
      echo "Error with line ", line
      quit(1)

proc execute_instruction(self: Computer, instr: Instruction) =
  let
    name = self.get_instruction_name(instr)
    parameters = self.get_parameters(instr)

  case name:
    of "setr": self.setr(parameters)
    of "seti": self.seti(parameters)
    of "addr": self.my_addr(parameters)
    of "addi": self.addi(parameters)
    of "mulr": self.mulr(parameters)
    of "muli": self.muli(parameters)
    of "eqrr": self.eqrr(parameters)
    of "gtrr": self.gtrr(parameters)
    else:
      echo "We should never get here."
      quit(1)

proc run_program(self: Computer) =
  var cnt = 0
  while self.ip <= self.program.high:
    let instr = self.program[self.ip]
    self.before_instruction()
    self.execute_instruction(instr)
    self.after_instruction()
    cnt += 1
  # endwhile
  echo "# loops: ", cnt

# endclass Computer #########################################################

proc main() =
  let
    # lines = readFile("example1.txt").strip.splitlines
    lines = readFile("input.txt").strip.splitlines

  var
    part1 = newComputer(lines)

  # echo computer.ip
  # echo computer.ip_reg
  # for instr in computer.program:
    # echo instr
  # echo computer.registers

  part1.run_program()
  echo "Part 1: ", part1.registers[0]

  #####
  # echo()
#
  # var
    # part2 = newComputer(lines)
#
  # part2.registers[0] = 1
  # part2.run_program()
  # echo "Part 2: ", part2.registers[0]

# ############################################################################

when isMainModule:
  main()
