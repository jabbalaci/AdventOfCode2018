import strformat
import strutils


type
  Rule = tuple
    left_side: string
    right_side: char

# class Generation ##########################################################

type
  Generation = ref object
    state: string
    leftmost_idx: int

proc padding(self: Generation) =
  if self.state.startsWith("......"):    # 6 dots
    self.state = self.state[1 .. self.state.high]
    self.leftmost_idx += 1
  while not self.state.startsWith("....."):    # 5 dots
    self.state = "." & self.state
    self.leftmost_idx -= 1
  #
  if self.state.endsWith("......"):    # 6 dots
    self.state = self.state[0 ..< self.state.high]    # cut off the last one
  while not self.state.endsWith("....."):    # 5 dots
    self.state &= "."

proc newGeneration(state: string, leftmost_idx: int): Generation =
  new result
  result.state = state
  result.leftmost_idx = leftmost_idx
  result.padding()

proc copy(self:Generation): Generation =
  new result
  result.state = self.state
  result.leftmost_idx = self.leftmost_idx

func `$`(self: Generation): string =
  &"{self.state} ({self.leftmost_idx})"

# class Cave ################################################################

type
  Cave = ref object
    current_state: Generation
    rules: seq[Rule]
    generations: seq[Generation]

proc read_input_and_init(self: Cave, fname: string) =
  var rules = newSeq[Rule]()
  let
    lines = readFile(fname).strip.splitLines

  self.current_state = newGeneration(lines[0].splitWhitespace()[^1], 0)
  for line in lines[2 .. lines.high]:
    let parts = line.split(" => ")
    rules &= ((parts[0], parts[1][0]))
  #
  self.rules = rules
  self.generations &= self.current_state

func find_matching_rule_idx(self: Cave, sub: string): int =
  for idx, rule in self.rules:
    if rule.left_side == sub:
      return idx
    #
  #
  -1    # not found

proc produce_next_generation(self: Cave) =
  var gen = self.current_state.copy()
  for i in 0 .. (self.current_state.state.len - 5):
    let sub = self.current_state.state[i ..< i+5]
    assert(sub.len == 5, "sub's len is not 5")
    let rule_idx_to_apply = self.find_matching_rule_idx(sub)
    if rule_idx_to_apply > -1:
      let rule = self.rules[rule_idx_to_apply]
      # echo &"{sub} at position {i} matched with the rule {rule.left_side} -> {rule.right_side}"
      gen.state[i+2] = rule.right_side
    else:
      gen.state[i+2] = '.'
    #
  #
  self.current_state = newGeneration(gen.state, gen.leftmost_idx)
  self.generations &= self.current_state

func sum_of_the_numbers_of_all_pots_which_contain_a_plant(self: Cave, gen: Generation): int =
  for idx, value in gen.state:
    if value == '#':
      result += idx + gen.leftmost_idx

proc `$`(self: Cave): string =
  # for rule in self.rules:
    # echo &"{rule.left_side} -> {rule.right_side}"
  # echo()
  echo self.current_state

# endclasses ################################################################

proc main() =
  let
    # fname = "example1.txt"
    fname = "input.txt"

  let
    cave = Cave()

  cave.read_input_and_init(fname)
  
  # echo cave

  for i in 1 .. 20:
    cave.produce_next_generation()
    # echo cave

  # for gen in cave.generations:
    # echo gen

  # echo()
  # echo cave.current_state
  let result = cave.sum_of_the_numbers_of_all_pots_which_contain_a_plant(cave.current_state)

  echo result

# ############################################################################

when isMainModule:
  main()
