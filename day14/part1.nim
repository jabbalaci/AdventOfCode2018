import sequtils
import strformat
import strutils


type
  Kitchen = ref object
    recipes: seq[int]
    elf1_idx, elf2_idx: int

proc `$`(self: Kitchen): string =
  var elems = newSeq[string]()
  for idx, value in self.recipes:
    if idx == self.elf1_idx:
      elems &= &"({value})"
    elif idx == self.elf2_idx:
      elems &= &"[{value}]"
    else:
      elems &= $value
  #
  elems.join(" ")

proc add_new_recipes_and_move_the_elves(self: Kitchen) =
  let
    total = self.recipes[self.elf1_idx] + self.recipes[self.elf2_idx]
    digits = toSeq($total).mapIt(($it).parseInt)
  #
  self.recipes &= digits
  let last_index = self.recipes.high
  #
  for i in 1 .. (self.recipes[self.elf1_idx] + 1):
    inc self.elf1_idx
    if self.elf1_idx > last_index:
      self.elf1_idx = 0
    #
  #
  for i in 1 .. (self.recipes[self.elf2_idx] + 1):
    inc self.elf2_idx
    if self.elf2_idx > last_index:
      self.elf2_idx = 0
  

proc main() =
  let
    (recipes_before, recipes_after) = (793061, 10)
  var
    kitchen = Kitchen(recipes: @[3, 7], elf1_idx: 0, elf2_idx: 1)


  # echo kitchen
  while kitchen.recipes.len < (recipes_before + recipes_after):
    kitchen.add_new_recipes_and_move_the_elves()
    # echo kitchen
  #
  let
    idx = recipes_before
    result = kitchen.recipes[idx ..< idx + recipes_after].join

  echo result

# ############################################################################

when isMainModule:
  main()
