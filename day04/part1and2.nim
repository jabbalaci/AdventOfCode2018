import strutils
import math
import algorithm
import tables


func lchop*(s, sub: string): string =
  if s.startsWith(sub):
    s[sub.len .. s.high]
  else:
    s


type
  Shift = tuple
    date: string
    id: int
    minutes: array[60, int]


iterator shifts(lines: seq[string]): seq[string] =
  var indexes = newSeq[int]()
  for idx, line in lines:
    if "Guard" in line:
      indexes &= idx
    #
  #
  for i in 0 .. (indexes.high - 1):
    yield lines[indexes[i] ..< indexes[i+1]]
  #
  yield lines[indexes[^1] .. lines.high]


func extract_minute(line: string): int =
  let
    parts = line.splitWhitespace()
    minute = parts[1][^3 ..< ^1].parseInt
  #
  minute


func extract_date(line: string): string  =
  line[^5 .. line.high]


func shift_to_record(shift: seq[string]): Shift =
  # echo shift

  let
    parts_guard = shift[0].splitWhitespace()
    guard = parts_guard[3].lchop("#").parseInt

  var
    minutes: array[60, int]

  if shift.len == 1:
    let date = extract_date(parts_guard[0])
    return (date: date, id: guard, minutes: minutes)
    
  # else, if (s)he fell asleep sometime

  let
    parts_sleepy = shift[1].splitWhitespace()
    date = extract_date(parts_sleepy[0])
    minute = parts_sleepy[1][^3 ..< ^1].parseInt
  
  for i in 0 ..< ((shift.len - 1) div 2):
    let
      idx_falls_asleep = (i * 2) + 1
      idx_wakes_up = idx_falls_asleep + 1
      falls_asleep_minute = extract_minute(shift[idx_falls_asleep])
      wakes_up_minute = extract_minute(shift[idx_wakes_up])

    for i in falls_asleep_minute ..< wakes_up_minute:
      minutes[i] = 1

    # echo &"({falls_asleep_minute}, {wakes_up_minute})"

  (date: date, id: guard, minutes: minutes)


func calculate_guards_slept_minutes(records: seq[Shift]): Table[int, int] =
  result = initTable[int, int]()
  for record in records:
    let
      key = record.id
      value = record.minutes.sum

    if key notin result:
      result[key] = 0
    result[key] += value


func find_guard_id_with_max_value(d: Table[int, int]): int =
  var max_value = 0
  for key, value in d:
    if value > max_value:
      max_value = value
      result = key


func get_what_minute_guard_was_asleep_most(records: seq[Shift], id: int): int =
  let indexes = block:
    var lst = newSeq[int]()
    for i in 0 .. records.high:
      if records[i].id == id:
        lst &= i
      #
    #
    lst
  
  # echo indexes
  
  var minutes: array[60, int]

  for col in 0 .. 59:
    for row in indexes:
      if records[row].minutes[col] == 1:
        minutes[col] += 1
      #
    #
  #
  let
    maxi = minutes.max
    
  result = minutes.find(maxi)


func get_sleeping_frequency(records: seq[Shift]): array[60, Table[int, int]] =
  for col in 0 .. 59:
    var d = initTable[int, int]()
    for row in records:
      if row.minutes[col] == 1:
        if row.id notin d:
          d[row.id] = 0
        d[row.id] += 1
      #
    #
    result[col] = d
  #
  result


func get_which_guard_is_most_frequently_asleep_on_the_same_minute(lst: array[60, Table[int, int]]): tuple[id, minute: int] =
  var
    max_value = 0
    id = 0
    minute = 0

  for i in 0 .. 59:
    let d = lst[i]
    for k, v in d:
      if v > max_value:
        max_value = v
        id = k
        minute = i
      #
    #
  #

  (id, minute)


proc main() =
  let
    # lines = sorted(readFile("example1.txt").strip().splitlines(), cmp[string])
    lines = sorted(readFile("input.txt").strip().splitlines(), cmp[string])

  let records = block:
    var records = newSeq[Shift]()

    for shift in shifts(lines):
      let record = shift_to_record(shift)
      if record.minutes.sum > 0:    # there's a gnome that didn't fall asleep, so I don't add him/her
        records &= record
      #
    #
    records

  # for rec in records:
  #   echo rec

  let
    d = calculate_guards_slept_minutes(records)
    selected_guard_id = find_guard_id_with_max_value(d)
    selected_guard_minute = get_what_minute_guard_was_asleep_most(records, selected_guard_id)

  # echo d
  echo "Selected guard's ID: ", selected_guard_id
  echo "Selected minute: ", selected_guard_minute
  echo()
  echo "Part 1: ", selected_guard_id * selected_guard_minute
  echo "-".repeat(40)

  ##########
  # Part 2 #
  ##########

  let
    lst = get_sleeping_frequency(records)
    (part2_guard_id, part2_minute) = get_which_guard_is_most_frequently_asleep_on_the_same_minute(lst)

  # for idx, d in lst:
    # echo idx, ": ", d

  echo "Guard ID: ", part2_guard_id
  echo "Minute: ", part2_minute
  echo()
  echo "Part 2: ", part2_guard_id * part2_minute

# ############################################################################

when isMainModule:
  main()
