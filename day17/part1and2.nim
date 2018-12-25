import sequtils
import strformat
import strutils

from helper import nil
import types

# types #####################################################################

type
  Direction = enum
    dirDown,
    dirLeft,
    dirRight

  Snake = ref object
    elems: seq[Point]
    alive: bool
    direction: Direction

  SnakeList = ref object
    snakes: seq[Snake]

# class Snake ###############################################################

proc copy(self: Snake): Snake =
  new result
  result.elems = self.elems
  result.alive = self.alive
  result.direction = self.direction

func get_head(self: Snake): Point =
  self.elems[^1]

proc add_head(self: Snake, m: var Matrix, pos: Point) =
  self.elems &= pos
  m[pos.row][pos.col] = '|'

proc go_right(self: Snake, m: var Matrix) =
  let
    head = self.get_head()
    pos: Point = (col: head.col + 1, row: head.row)

  self.elems &= pos
  m[pos.row][pos.col] = '|'

proc go_left(self: Snake, m: var Matrix) =
  let
    head = self.get_head()
    pos: Point = (col: head.col - 1, row: head.row)

  self.elems &= pos
  m[pos.row][pos.col] = '|'

proc we_are_at_the_bottom_of_a_glass(self: Snake, m: Matrix): bool =
  let
    head = self.get_head()
    row = head.row

  var
    col: int

  # scan left
  col = head.col - 1
  while true:
    let
      ground = m[row][col]
      below = m[row+1][col]
    
    if ground == '#':
      break
    if below == '.':
      return false
    #
    col -= 1
  # endwhile
  
  # scan right
  col = head.col + 1
  while true:
    let
      ground = m[row][col]
      below = m[row+1][col]
    
    if ground == '#':
      break
    if below == '.':
      return false
    #
    col += 1
  # endwhile
  result = true

func down_pos(self: Snake): Point =
  let head = self.get_head()
  (col: head.col, row: head.row+1)

func left_pos(self: Snake): Point =
  let head = self.get_head()
  (col: head.col - 1, row: head.row)

func right_pos(self: Snake): Point =
  let head = self.get_head()
  (col: head.col + 1, row: head.row)

func on_down(self: Snake, m: Matrix): char =
  let pos = self.down_pos()
  m[pos.row][pos.col]

func on_left(self: Snake, m: Matrix): char =
  let pos = self.left_pos()
  m[pos.row][pos.col]

func on_right(self: Snake, m: Matrix): char =
  let pos = self.right_pos()
  m[pos.row][pos.col]

func can_go_left(self: Snake, m: Matrix): bool =
  let
    value = self.on_left(m)

  value in ['.', '|']

func can_go_right(self: Snake, m: Matrix): bool =
  let
    value = self.on_right(m)

  value in ['.', '|']

proc fill_row_with_water(self: Snake, m: var Matrix) =
  let
    head = self.get_head()
    row = head.row
  
  var
    col: int

  # go left
  col = head.col - 1
  while true:
    let
      ground = m[row][col]
    
    if ground == '#':
      break
    if ground in ['.', '|']:
      m[row][col] = '~'
    #
    col -= 1

  # go right
  col = head.col + 1
  while true:
    let
      ground = m[row][col]
    
    if ground == '#':
      break
    if ground in ['.', '|']:
      m[row][col] = '~'
    #
    col += 1

  # and don't forget the head either
  m[head.row][head.col] = '~'

proc back_to_previous_row(self: Snake) =
  let
    row = self.get_head().row

  while self.elems[^1].row == row:
    discard self.elems.pop()

# class SnakeList ###########################################################

proc newSnakeList(m: var Matrix): SnakeList =
  new result
  result.snakes = newSeq[Snake]()
  let pos: Point = (col: fountain.col, row: fountain.row + 1)
  var snake1 = Snake(elems: @[pos],
                 alive: true,
                 direction: dirDown)
  m[pos.row][pos.col] = '|'
  result.snakes &= snake1

proc delete_dead_snakes(self: SnakeList) =
  self.snakes = self.snakes.filterIt(it.alive)

proc add_new_snakes(self: SnakeList, new_snakes: seq[Snake]) =
  self.snakes &= new_snakes

func snakes_alive(self: SnakeList): int =
  self.snakes.filterIt(it.alive).len

func has_snakes_alive(self: SnakeList): bool =
  for snake in self.snakes:
    if snake.alive:
      return true
    #
  #
  false

# ###########################################################################

func get_results(m: Matrix, top_row, bottom_row: int): tuple[part1, part2: int] =
  var
    tildes = 0
    pipes = 0

  for row_idx in top_row .. bottom_row:
    let row = m[row_idx]
    tildes += row.count('~')
    pipes += row.count('|')
  #
  (tildes + pipes, tildes)

proc display(m: Matrix, top_left, bottom_right: Point): string =
  for row in m:
    echo row[top_left.col .. bottom_right.col]

proc mini_display(m: Matrix, snake_list: SnakeList, top_left, bottom_right: Point, head: int): string =
  var m = m
  #
  for snake in snake_list.snakes.filterIt(it.alive):
    let
      head = snake.get_head()

    m[head.row][head.col] =
      case snake.direction:
        of dirDown: 'v'
        of dirLeft: '<'
        of dirRight: '>'
  #
  for idx, row in m:
    echo row[top_left.col .. bottom_right.col]
    if idx > head:
      break

proc main() =
  let
    # lines = readFile("example1.txt").strip.splitlines
    lines = readFile("input.txt").strip.splitlines
    intervals = helper.read_intervals(lines)
    (top_left, bottom_right) = helper.find_corners(intervals)
    (top_row, bottom_row) = helper.find_top_and_bottom_rows(intervals)

  var
    m = helper.create_matrix(intervals, bottom_right)
    snakeList = newSnakeList(m)

  var cnt = 0
  while snakeList.has_snakes_alive():
    cnt += 1
    snakeList.delete_dead_snakes()
    var new_snakes = newSeq[Snake]()
    for snake in snakeList.snakes:
      if snake.alive:
        if snake.direction == dirDown:
          let under = snake.on_down(m)
          if under == '|':
            snake.alive = false
          elif under == '.':
            let pos = snake.down_pos()
            if pos.row > bottom_right.row:    # would go out of the map
              snake.alive = false
            else:
              snake.add_head(m, pos)
          elif under in ['#', '~']:
            if snake.we_are_at_the_bottom_of_a_glass(m):
              snake.fill_row_with_water(m)
              snake.back_to_previous_row()
            else:
              var copied = false
              if snake.can_go_left(m):
                var
                  copy = snake.copy()
                copied = true
                let
                  left_pos = snake.left_pos()

                copy.add_head(m, left_pos)
                copy.direction = dirLeft
                new_snakes &= copy
              if snake.can_go_right(m):
                var
                  copy = snake.copy()
                copied = true
                let
                  right_pos = snake.right_pos()

                copy.add_head(m, right_pos)
                copy.direction = dirRight
                new_snakes &= copy
              #
              if copied:
                snake.alive = false
        # endif direction is down
        elif snake.direction == dirRight:
          if snake.can_go_right(m):
            let under = snake.on_down(m)
            if under == '.':
              snake.direction = dirDown
            elif under == '|':
              snake.alive = false
            else:
              snake.go_right(m)
          else:
            snake.alive = false
        elif snake.direction == dirLeft:
          if snake.can_go_left(m):
            let under = snake.on_down(m)
            if under == '.':
              snake.direction = dirDown
            elif under == '|':
              snake.alive = false
            else:
              snake.go_left(m)
          else:
            snake.alive = false
      # endif alive
    # endfor
    snakeList.add_new_snakes(new_snakes)

    # if cnt == 740:
      # break
  # endwhile
  # echo cnt

  # echo m.display(top_left, bottom_right)
  # echo m.mini_display(snake_list, top_left, bottom_right, 330)

  # echo snakeList.snakes_alive()

  let
    (part1, part2) = get_results(m, top_row, bottom_row)

  echo "Part 1: ", part1
  echo "Part 2: ", part2

# ############################################################################

when isMainModule:
  main()
