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

const
  LIMIT = 100_000_000    # chosen by trial and error

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

proc bani(self: Computer, parameters: Parameters) =
  let (a, b, c) = parameters
  #
  self.registers[c] = self.registers[a] and b

proc bori(self: Computer, parameters: Parameters) =
  let (a, b, c) = parameters
  #
  self.registers[c] = self.registers[a] or b

proc eqri(self: Computer, parameters: Parameters) =
  let (a, b, c) = parameters
  #
  self.registers[c] = if self.registers[a] == b: 1 else: 0

proc gtir(self: Computer, parameters: Parameters) =
  let (a, b, c) = parameters
  #
  self.registers[c] = if a > self.registers[b]: 1 else: 0

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
    of "bani": self.bani(parameters)
    of "bori": self.bori(parameters)
    of "eqri": self.eqri(parameters)
    of "gtir": self.gtir(parameters)
    else:
      echo "We should never get here."
      quit(1)

proc init(self: Computer) =
  self.ip = 0
  self.registers = [0, 0, 0, 0, 0, 0]

proc run_program(self: Computer, reg0value: int): tuple[reg0value, number_of_executed_instructions: int] =
  self.init()
  self.registers[0] = reg0value

  var cnt = 0
  while self.ip <= self.program.high:
    let instr = self.program[self.ip]
    self.before_instruction()
    self.execute_instruction(instr)
    self.after_instruction()
    cnt += 1
    if cnt > LIMIT:
      return (-1, -1)
  # endwhile
  # echo "# loops: ", cnt

  (reg0value, cnt)

# endclass Computer #########################################################

proc test_run(comp: Computer) =
  var
    reg0value = -1
    min_reg_value = int.high
    min_instructions = int.high

  while true:
    reg0value += 1
    let
      (result_reg, result_number_of_instructions) = comp.run_program(reg0value)
    if result_reg > -1:
      if result_number_of_instructions < min_instructions:
        min_instructions = result_number_of_instructions
        min_reg_value = result_reg
        echo()
        echo "reg value: ", min_reg_value
        echo "number of instructions: ", min_instructions
        break
    else:
      stdout.write('.') #; flushFile(stdout)
      #
    #
  # endwhile

proc main() =
  let
    # lines = readFile("example1.txt").strip.splitlines
    # lines = readFile("example2.txt").strip.splitlines
    lines = readFile("input.txt").strip.splitlines

  var
    part1 = newComputer(lines)

  # echo computer.ip
  # echo computer.ip_reg
  # for instr in computer.program:
    # echo instr
  # echo computer.registers

  test_run(part1)

  # let
    # (reg0, instr_count) = part1.run_program(reg0value=0)
    #
  # echo "reg0 start value: ", reg0
  # echo "reg0 end value: ", part1.registers[0]
  # echo "instr_count: ", instr_count

# ############################################################################

when isMainModule:
  main()
