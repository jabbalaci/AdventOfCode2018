type
  Node = ref object
    next: Node
    value: int

  LinkedList = ref object
    head, tail: Node


proc add(self: LinkedList, value: int) =
  let node = Node(value: value)

  if self.head == nil:
    self.head = node
    self.tail = node
  else:
    self.tail.next = node
    self.tail = node

proc len(self: LinkedList): int =
  var curr = self.head
  while curr != nil:
    inc result
    curr = curr.next


proc main() =
  var numbers = LinkedList()

  numbers.add(2)
  numbers.add(8)
  echo numbers.len()

# ############################################################################

when isMainModule:
  main()
