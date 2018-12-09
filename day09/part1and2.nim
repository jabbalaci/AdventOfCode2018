import strutils
import strformat
import strscans

# class DoubleRing ##########################################################

type
  Node = ref object
    prev, next: Node
    value: int

  DoubleRing = ref object
    curr: Node

proc add(self: DoubleRing, value: int) =
  let node = Node(value: value)

  if self.curr == nil:    # empty
    self.curr = node
    node.prev = node
    node.next = node
  else:
    node.next = self.curr.next
    self.curr.next.prev = node
    self.curr.next = node
    node.prev = self.curr

func empty(self: DoubleRing): bool =
  self.curr == nil

proc pop(self:DoubleRing): int =
  assert not self.empty, "you cannot remove elements from an empty ring"
  #
  result = self.curr.value

  if self.curr.next == self.curr:    # has 1 element only
    self.curr = nil
  else:
    var
      prev_node = self.curr.prev
      next_node = self.curr.next
    
    prev_node.next = next_node
    next_node.prev = prev_node
    self.curr = next_node

proc move_forward(self: DoubleRing, steps = 1) =
  for i in 1 .. steps:
    self.curr = self.curr.next

proc move_back(self: DoubleRing, steps = 1) =
  for i in 1 .. steps:
    self.curr = self.curr.prev

# endclass DoubleRing #######################################################

type
  Game = tuple
    n_players, n_marbles, expected_score: int

func extract_values(line: string): Game =
  var a, b, c: int
  if line.scanf("$i players; last marble is worth $i points: high score is $i", a, b, c):
    (a, b, c)
  else:
    (-1, -1, -1)

proc play_game(game: Game): int =
  var
    players = newSeq[int](game.n_players)
    player_idx = -1
    ring = DoubleRing()

  ring.add(0)    # init

  for i in 1 .. game.n_marbles:
    player_idx += 1
    if player_idx >= game.n_players:
      player_idx = 0

    if i mod 23 == 0:
      players[player_idx] += i
      ring.move_back(7)
      players[player_idx] += ring.pop()
    else:
      ring.move_forward()
      ring.add(i)
      ring.move_forward()
  #
  players.max

proc main() =
  let
    # line = "9 players; last marble is worth 25 points: high score is 32"
    # line = "10 players; last marble is worth 1618 points: high score is 8317"
    # line = "13 players; last marble is worth 7999 points: high score is 146373"
    # line = "17 players; last marble is worth 1104 points: high score is 2764"
    # line = "21 players; last marble is worth 6111 points: high score is 54718"
    # line = "30 players; last marble is worth 5807 points: high score is 37305"
    # game = extract_values(line)
    game1 = (430, 71_588, -1)    # part 1, input, -1 means: unknown
    result1 = play_game(game1)
    game2 = (430, 7_158_800, -1)    # part 2, input, -1 means: unknown
    result2 = play_game(game2)

  # echo game1
  echo "Part 1: ", result1

  # echo game2
  echo "Part 2: ", result2

# ############################################################################

when isMainModule:
  main()
