import strutils    # strip, split, join
import strformat   # &"Hello {name}!"
import sequtils    # toSeq(iter), map, filter


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



proc len(self: DoubleRing): int =
  if self.curr == nil:
    return 0
  # else
  result = 1    # curr counts as the first node
  var run = self.curr.next
  while run != self.curr:
    inc result
    run = run.next

proc `$`(self: DoubleRing): string =
  var sb = newSeq[string]()
  if self.curr != nil:
    sb &= &"({self.curr.value})"
    var run = self.curr.next
    while run != self.curr:
      sb &= &"{run.value}"
      run = run.next
  "[" & sb.join(" ") & "]"

proc move_forward(self: DoubleRing, steps = 1) =
  for i in 1 .. steps:
    self.curr = self.curr.next

proc move_back(self: DoubleRing, steps = 1) =
  for i in 1 .. steps:
    self.curr = self.curr.prev
    

proc main() =
  var ring = DoubleRing()

  ring.add(1)
  ring.add(2)
  ring.add(3)
  ring.add(4)
  ring.add(5)
  echo "length: ", ring.len()
  echo ring
  ring.move_forward(2)
  echo ring
  ring.move_back(2)
  echo ring
  echo ring.pop()
  echo ring
  echo ring.pop()
  echo ring

# ############################################################################

when isMainModule:
  main()
