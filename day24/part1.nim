import algorithm
import math
import sequtils
import strformat
import strscans
import strutils
import sugar
import tables


const
  debug = false


iterator next_id_iter(): int {.closure.} =
  var cnt = 1
  while true:
    yield cnt
    cnt += 1

let next_id = next_id_iter

# types #####################################################################

type
  Side = enum
    sdImmuneSystem,
    sdInfection

  AttackType = enum
    atRadiation,
    atBludgeoning,
    atFire,
    atSlashing,
    atCold

  Attack = tuple
    damage: int
    dType: AttackType

  Group = tuple
    id: int
    local_id: int
    side: Side
    units: int
    hit_points: int
    weak_to: seq[AttackType]
    immune_to: seq[AttackType]
    attack: Attack
    initiative: int
    selected: bool

  Army = seq[Group]

const
  attack_type_names = ["radiation", "bludgeoning", "fire", "slashing", "cold"]
  attack_type_enums = [atRadiation, atBludgeoning, atFire, atSlashing, atCold]

# endtype ###################################################################

func effective_power(gr: Group): int =
  gr.units * gr.attack.damage

proc display(army: Army) =
  for gr in army:
    echo gr

proc init_army(side: Side, lines: seq[string]): Army =
  var cnt = 1
  for line in lines:
    var
      tmp: string
      units, hit_points: int
      damage, initiative: int
      damage_type: string
      dType: AttackType
      weak_to = newSeq[AttackType]()
      immune_to = newSeq[AttackType]()
      inside: string

    if not line.scanf("$i units each with $i hit points", units, hit_points):
      echo "Error #1 with line ", line
      quit(1)
    #
    if line.scanf("$*with an attack that does $i $w damage at initiative $i", tmp, damage, damage_type, initiative):
      dType = attack_type_enums[attack_type_names.find(damage_type)]
    else:
      echo "Error #2 with line ", line
      quit(1)
    #
    if line.scanf("$*($*)", tmp, inside):
      var value: string
      let parts = inside.split("; ")
      for part in parts:
        var part = part & ')'    # so that scanf can go until this sign
        if part.scanf("weak to $*)", value):
          let attacks = value.split(", ")
          for attack in attacks:
            weak_to &= attack_type_enums[attack_type_names.find(attack)]
        elif part.scanf("immune to $*)", value):
          let attacks = value.split(", ")
          for attack in attacks:
            immune_to &= attack_type_enums[attack_type_names.find(attack)]
    #
    result &= (next_id(), cnt, side, units, hit_points, weak_to, immune_to, (damage, dType), initiative, false)
    cnt += 1
  # endfor

func alive(gr: Group): bool =
  gr.units > 0

func alive(army: Army): bool =
  for gr in army:
    if gr.alive():
      return true
    #
  #
  false

func myCmp(g1, g2: Group): int =
  let
    ep1 = g1.effective_power()
    ep2 = g2.effective_power()

  if ep1 != ep2:
    result = ep1 - ep2
  else:
    result = g1.initiative - g2.initiative

# proc set_selected(gr: Group, value: bool) =
  # gr.selected = value

proc compute_possible_damage(attacker, defender: Group, verbose = false): int =
  let
    default_damage = attacker.effective_power()

  if attacker.attack.dType in defender.immune_to:
    result = 0
  elif attacker.attack.dType in defender.weak_to:
    result = 2 * default_damage
  else:
    result = default_damage
  #
  if debug:
    if verbose:
      echo &"{attacker.side} group {attacker.local_id} would deal defending group {defender.local_id} {result} damage"

proc select_enemy(curr: Group, enemy: Army): seq[Group] =

  proc myCmpSelectEnemy(g1, g2: Group): int =
    let
      possible_damage1 = compute_possible_damage(curr, g1, verbose=true)
      possible_damage2 = compute_possible_damage(curr, g2, verbose=true)

    if possible_damage1 != possible_damage2:
      return possible_damage1 - possible_damage2
    # else, if possible_damage1 == possible_damage2
    let
      ep1 = g1.effective_power()
      ep2 = g2.effective_power()

    if ep1 != ep2:
      return ep1 - ep2
    # else, if ep1 == ep2
    result = g1.initiative - g2.initiative

  # We return a seq[Group] that can have 0 or 1 item.
  let
    sorted_candidates = sorted(enemy, myCmpSelectEnemy, order=Descending)
    candidates = sorted_candidates.filterIt(not it.selected)

  if candidates.len == 0:
    result = @[]
  else:
    result = @[candidates[0]]

proc attack(attacker: Group, defender: Group): Group =
  var defender = defender

  let
    defense = defender.units * defender.hit_points
    damage = compute_possible_damage(attacker, defender)

  if damage >= defense:
    if debug:
      echo &"{attacker.side} group {attacker.local_id} attacks defending group {defender.local_id}, killing {defender.units} units"
    defender.units = 0    # destroyed
    return defender
  # else
  let lost_units = damage div defender.hit_points
  # if lost_units == 0:
    # echo "# debug ON:"
    # echo attacker
    # echo defender
    # echo "# debug OFF:"
  if debug:
    echo &"{attacker.side} group {attacker.local_id} attacks defending group {defender.local_id}, killing {lost_units} units"
  defender.units -= lost_units
  result = defender

proc show_armies(a1, a2: Army) =
  let length = 78
  a1.display()
  echo "-".repeat(length)
  a2.display()
  echo "#".repeat(length)

func find_by_id(groups: Army, id: int): int =
  for idx, group in groups:
    if group.id == id:
      return idx
  #
  -1    # we should never get here

proc show_short_summary(immune_system, infection: Army) =
  echo "#".repeat(78)
  echo "Immune System:"
  for gr in immune_system:
    echo &"Group {gr.local_id} contains {gr.units} units"
  #
  echo "Infection:"
  for gr in infection:
    echo &"Group {gr.local_id} contains {gr.units} units"
  #
  if debug:
    echo()

proc war(immune_system, infection: Army): tuple[winner: Side, result: int] =
  var
    immune_system = immune_system
    infection = infection

  var cnt = 0
  while immune_system.alive() and infection.alive():
    immune_system = sorted(immune_system, myCmp, order=Descending).filterIt(it.alive())
    infection = sorted(infection, myCmp, order=Descending).filterIt(it.alive())

    cnt += 1
    if debug:
      show_short_summary(immune_system, infection)
    var who_attacks_whom = initTable[int, int]()

    # Phase 1: target selection
    for gr in immune_system.mitems():
      gr.selected = false
    for gr in infection.mitems():
      gr.selected = false

    for gr in immune_system:
      var selected_enemy = gr.select_enemy(infection)
      if selected_enemy.len > 0:
        let enemy = selected_enemy[0]
        if compute_possible_damage(gr, enemy) == 0:
          continue
        for e in infection.mitems():
          if e.id == enemy.id:
            e.selected = true
            break
        who_attacks_whom[gr.id] = enemy.id
    # endfor
    for gr in infection:
      var selected_enemy = gr.select_enemy(immune_system)
      if selected_enemy.len > 0:
        let enemy = selected_enemy[0]
        if compute_possible_damage(gr, enemy) == 0:
          continue
        for e in immune_system.mitems():
          if e.id == enemy.id:
            e.selected = true
            break
        who_attacks_whom[gr.id] = enemy.id
    # endfor

    # echo who_attacks_whom

    # Phase 2: attack
    if debug:
      echo()
    var everyone = sorted(immune_system & infection, (x, y) => (x.initiative - y.initiative), order=Descending)
    for attacker_idx, attacker in everyone:
      if attacker.id in who_attacks_whom:
        let
          defender_idx = everyone.find_by_id(who_attacks_whom[attacker.id])
        var
          defender = everyone[defender_idx]

        defender = attack(attacker, defender)
        everyone[defender_idx] = defender
      #
    # endfor
    immune_system = everyone.filterIt(it.side == sdImmuneSystem)
    infection = everyone.filterIt(it.side == sdInfection)

    # show_armies(immune_system, infection)
    
    # if cnt >= 11:
      # break
  # endwhile

  if debug:
    show_short_summary(immune_system, infection)

  let
    winner_side = if immune_system.alive(): sdImmuneSystem else: sdInfection
    winner = if winner_side == sdImmuneSystem: immune_system else: infection
    part1_result = winner.mapIt(it.units).sum

  (winner_side, part1_result)

proc main() =
  let
    # lines = readFile("example1.txt").strip.splitLines
    lines = readFile("input.txt").strip.splitLines
    sep = lines.find("")
    (immune_system_lines, infection_lines) = (lines[1 ..< sep], lines[(sep + 2) .. lines.high])
    immune_system = init_army(sdImmuneSystem, immune_system_lines)
    infection = init_army(sdInfection, infection_lines)
    (winner, part1_result) = war(immune_system, infection)

  # show_armies(immune_system, infection)

  echo "Winner: ", winner
  echo "Part 1: ", part1_result

# ############################################################################

when isMainModule:
  main()
