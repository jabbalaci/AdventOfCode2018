import algorithm
import sequtils
import strformat
import strutils


const
  arrows = ['^', '>', 'v', '<']
  left_right_arrows = ['<', '>']

# types and enums ###########################################################

type
  Point = tuple
    col, row: int

  Matrix = seq[string]

type
  Direction = enum
    dirUp,
    dirRight,
    dirDown,
    dirLeft

  Turning = enum
    turnLeft,
    turnStraight,    # meaning: don't turn, go on straight
    turnRight

# helpers ###################################################################

func rstrip*(s: string, chars: set[char] = Whitespace): string =
  s.strip(leading=false, trailing=true, chars=chars)

func next_turn(prev_turn: Turning): Turning =
  case prev_turn:
    of turnLeft:
      turnStraight
    of turnStraight:
      turnRight
    of turnRight:
      turnLeft

func to_direction(c: char): Direction =
  if c == '^': return dirUp
  if c == '>': return dirRight
  if c == 'v': return dirDown
  if c == '<': return dirLeft
  # we should never get here to the end

func to_char(dir: Direction): char =
  if dir == dirUp: return '^'
  if dir == dirRight: return '>'
  if dir == dirDown: return 'v'
  if dir == dirLeft: return '<'
  # we should never get here to the end

func left_from(dir: Direction): Direction =
  case dir:
    of dirUp: dirLeft
    of dirRight: dirUp
    of dirDown: dirRight
    of dirLeft: dirDown

func right_from(dir: Direction): Direction =
  case dir:
    of dirUp: dirRight
    of dirRight: dirDown
    of dirDown: dirLeft
    of dirLeft: dirUp

# class Cart ################################################################

type
  Cart = ref object
    pos: Point
    direction: Direction
    prev_turn: Turning    # default value: turnRight, so the next value will be turnLeft
    crashed: bool

func next_direction_at_crossroads(self: Cart): Direction =
  let turn = next_turn(self.prev_turn)

  self.prev_turn = turn

  if turn == turnStraight:
    return self.direction
  # else
  if turn == turnLeft:
    return left_from(self.direction)
  # else
  if turn == turnRight:
    return right_from(self.direction)
  #
  assert(false, "we should never get here")

proc move(self: Cart, m: Matrix) =
  if self.direction == dirUp:
    self.pos.row -= 1

    try:
      let under = m[self.pos.row][self.pos.col]
      if under == '\\':
        self.direction = dirLeft
      elif under == '/':
        self.direction = dirRight
      if under == '+':
        self.direction = self.next_direction_at_crossroads()
    except IndexError:
      echo "Error"
      echo self.pos.row
      echo self.pos.col
      echo m[self.pos.row+1][self.pos.col]
      raise
  elif self.direction == dirDown:
    self.pos.row += 1

    let under = m[self.pos.row][self.pos.col]
    if under == '\\':
      self.direction = dirRight
    elif under == '/':
      self.direction = dirLeft
    if under == '+':
      self.direction = self.next_direction_at_crossroads()
  elif self.direction == dirRight:
    self.pos.col += 1
    let under = m[self.pos.row][self.pos.col]
    if under == '\\':
      self.direction = dirDown
    elif under == '/':
      self.direction = dirUp
    if under == '+':
      self.direction = self.next_direction_at_crossroads()
  elif self.direction == dirLeft:
    self.pos.col -= 1
    let under = m[self.pos.row][self.pos.col]
    if under == '\\':
      self.direction = dirUp
    elif under == '/':
      self.direction = dirDown
    if under == '+':
      self.direction = self.next_direction_at_crossroads()

func crashes(self: Cart, skip_idx: int, carts: seq[Cart]): bool =
  for idx, other in carts:
    if idx == skip_idx:
      continue
    # else
    if self.pos == other.pos:    # collision
      return true
    #
  #
  false

func `$`(self: Cart): string =
  result &= "Cart("
  result &= &"pos: {self.pos}, "
  result &= &"direction: {$self.direction}, "
  result &= &"prev_turn: {$self.prev_turn}"
  result &= ")"

# endclass Cart #############################################################

proc create_matrix(lines: seq[string]): Matrix =
  let max_length = lines.mapIt(it.len).max
  for line in lines:
    result &= line & (' '.repeat(max_length - line.len))

proc line() =
  echo "#".repeat(40)

proc display(m: Matrix) =
  for row in m:
    echo row.rstrip

proc find_carts(m: Matrix): seq[Cart] =
  for row_idx, row_value in m:
    for col_idx, col_value in row_value:
      if col_value in arrows:
        result &= Cart(pos: (col: col_idx, row: row_idx),
                       direction: to_direction(col_value),
                       prev_turn: turnRight)

proc remove_carts(m: Matrix): Matrix =
  var m = m
  for row_idx, row_value in m:
    for col_idx, col_value in row_value:
      if col_value in arrows:
        if col_value in left_right_arrows:
          m[row_idx][col_idx] = '-'
        else:    # up or down arrow
          m[row_idx][col_idx] = '|'
      #
    #
  #
  result = m

proc display_with_carts(m: Matrix, carts: seq[Cart]) =
  var m = m
  for cart in carts:
    m[cart.pos.row][cart.pos.col] = to_char(cart.direction)
  #
  m.display()
  # for cart in carts:
    # echo cart
  #
  line()

func myCmp(c1, c2: Cart): int =
  if c1.pos.row != c2.pos.row:
    result = c1.pos.row - c2.pos.row
  else:
    result = c1.pos.col - c2.pos.col

# main ######################################################################

proc main() =
  let
    # lines = readFile("example2.txt").strip.splitlines
    lines = readFile("input.txt").rstrip.splitlines
    m0 = create_matrix(lines)

  var
    carts = find_carts(m0)
    steps = 0

  let
    m = m0.remove_carts()

  # m0.display()

  # for cart in carts:
    # echo repr(cart)

  # m.display()
  # line()
  # m.display_with_carts(carts)

  block outer:
    while true:
      carts = sorted(carts, myCmp)
      steps += 1
      for idx, cart in carts:
        if cart.crashed:
          continue
        # else
        cart.move(m)
        if cart.crashes(idx, carts):
          for c in carts:
            if c.pos == cart.pos:
              c.crashed = true
            #
          # endfor, crashed carts are marked
        #
      # endfor
      carts = carts.filterIt(not it.crashed)
      if carts.len == 1:
        let cart = carts[0]
        echo &"Last cart survived: ", cart.pos
        echo "steps: ", steps
        echo()
        echo &"Part 2: {cart.pos.col},{cart.pos.row}"
        break outer
      # endif
      # m.display_with_carts(carts)
    # endwhile
  # endblock

# ############################################################################

when isMainModule:
  main()
