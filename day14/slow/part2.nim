import strformat
import strutils


func toInt(digit: char): int =
  parseInt($digit)

# class Kitchen #############################################################

type
  Kitchen = ref object
    recipes: string
    elf1_idx, elf2_idx: int

proc add_new_recipes_and_move_the_elves(self: Kitchen) =
  let
    total = self.recipes[self.elf1_idx].toInt + self.recipes[self.elf2_idx].toInt
  
  self.recipes &= $total

  let last_index = self.recipes.high

  for i in 1 .. (self.recipes[self.elf1_idx].toInt + 1):
    inc self.elf1_idx
    if self.elf1_idx > last_index:
      self.elf1_idx = 0
    #
  #
  for i in 1 .. (self.recipes[self.elf2_idx].toInt + 1):
    inc self.elf2_idx
    if self.elf2_idx > last_index:
      self.elf2_idx = 0

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

# endclass Kitchen ##########################################################

proc main() =
  let
    # to_find = "51589"
    # to_find = "01245"
    # to_find = "92510"
    # to_find = "59414"
    to_find = "793061"    # my input

  var
    kitchen = Kitchen(recipes: "37", elf1_idx: 0, elf2_idx: 1)

  # echo kitchen
  var cnt = 0
  while true:
    let found_at_idx = kitchen.recipes.rfind(to_find)

    if found_at_idx == -1:    # not found
      kitchen.add_new_recipes_and_move_the_elves()
      inc cnt
    else:
      # echo kitchen
      let result = found_at_idx
      echo result
      break
    # echo kitchen
  # endwhile

  echo "# steps: ", cnt

# ############################################################################

when isMainModule:
  main()
