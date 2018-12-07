import algorithm
import sequtils
import sets
import strformat
import strutils


type
  Connection = tuple
    src, dest: char

# extra stuff ###############################################################

proc write_dot_file(pairs: seq[Connection]) =
  var f = open("out.dot", fmWrite)

  f.writeLine("digraph {")
  f.writeLine("  rankdir=LR;")
  for pair in pairs:
    f.writeLine(&"  {pair.src} -> {pair.dest};")
  f.writeLine("}")

  f.close()

# class GraphTraverse #######################################################

type
  GraphTraverse = ref object
    connections: seq[Connection]
    black: seq[char]
    grey: seq[char]
    white: HashSet[char]
    start_node: char

proc newGraphTraverse: GraphTraverse =
  new result
  result.black = @[]
  result.grey = @[]
  result.white = initSet[char]()

proc add_connections(self: GraphTraverse, connections: seq[Connection]) =
  self.connections = connections

proc init_white_nodes(self: GraphTraverse) =
  for pair in self.connections:
    self.white.incl(pair.src)
    self.white.incl(pair.dest)

proc set_start_node(self: GraphTraverse, start_node: char) =
  self.start_node = start_node

proc make_node_grey(self: GraphTraverse, node: char) =
  # move the node from white to grey
  self.grey &= node
  self.grey.sort()    # sort in place
  self.white.excl(node)

proc make_node_black(self: GraphTraverse, node: char) =
  self.black &= node
  self.grey.delete(self.grey.find(node))    # should be at position 0 BTW

proc print_state(self: GraphTraverse) =
  echo "black: ", self.black
  echo "grey: ", self.grey
  echo "white: ", self.white
  echo "-".repeat(40)

func is_ready_node(self: GraphTraverse, node: char): bool =
  # a node is ready to be visited if all its predecessors are black nodes
  let parents = self.connections.filterIt(it.dest == node).mapIt(it.src).deduplicate
  for p in parents:
    if p notin self.black:
      return false
    #
  #
  true

proc start_traversal(self: GraphTraverse, verbose = true) =
  self.make_node_grey(self.start_node)
  if verbose:
    self.print_state()

  # main loop
  while self.grey.len > 0:
    let selected = self.grey[0]

    self.make_node_black(selected)

    let ready_nodes = toSeq(self.white).filterIt(self.is_ready_node(it))

    for node in ready_nodes:
      self.make_node_grey(node)

    if verbose:
      self.print_state()
  # endwhile

proc get_result(self: GraphTraverse): string =
  self.black.join

# endclass GraphTraverse ####################################################

func get_connections(lines: seq[string]): seq[Connection] =
  for line in lines:
    let parts = line.splitWhitespace()
    result &= (parts[1][0], parts[^3][0])    # string to char

func get_start_node(pairs: seq[Connection]): char =
  let
    left_side = pairs.mapIt(it.src).toSet
    right_side = pairs.mapIt(it.dest).toSet

  # echo toSeq(left_side - right_side)
  sorted(toSeq(left_side - right_side))[0]
  
proc main() =
  let
    # lines = readFile("example1.txt").strip.splitlines
    lines = readFile("input.txt").strip.splitlines
    connections = get_connections(lines)
    start_node = get_start_node(connections)
    graph = newGraphTraverse()

  graph.add_connections(connections)
  graph.init_white_nodes()
  graph.set_start_node(start_node)

  graph.start_traversal(verbose=false)

  let result = graph.get_result()

  echo result

# ############################################################################

when isMainModule:
  main()
