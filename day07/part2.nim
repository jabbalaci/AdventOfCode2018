import algorithm
import sequtils
import sets
import strformat
import strutils


type
  Connection = tuple
    src, dest: char

  Job = tuple
    task: char
    time: int

const
  IdleJob: Job = (task: '.', time: -1)

# class GraphTraverse #######################################################

type
  GraphTraverse = ref object
    connections: seq[Connection]
    black: seq[char]
    grey: seq[char]
    white: HashSet[char]
    start_node: char
    workers: seq[Job]
    plus_time: int
    ticks: int

proc newGraphTraverse: GraphTraverse =
  new result
  result.black = @[]
  result.grey = @[]
  result.white = initSet[char]()

proc add_connections(self: GraphTraverse, connections: seq[Connection]) =
  self.connections = connections

proc create_workers(self: GraphTraverse, num_workers: int) =
  for i in 1 .. num_workers:
    self.workers &= IdleJob

proc set_plus_time(self: GraphTraverse, plus_time: int) =
  self.plus_time = plus_time

func time_required(self: GraphTraverse, c: char): int =
  # A -> 1, B -> 2, etc. In addition, add plus_time to them.
  ord(c) - ord('A') + 1 + self.plus_time

proc init_white_nodes(self: GraphTraverse) =
  for pair in self.connections:
    self.white.incl(pair.src)
    self.white.incl(pair.dest)

proc set_start_node(self: GraphTraverse, start_node: char) =
  self.start_node = start_node

proc init_with_start_node(self: GraphTraverse) =
  self.workers[0] = (task: self.start_node, time: self.time_required(self.start_node))
  self.white.excl(self.start_node)

proc print_state(self: GraphTraverse) =
  echo "second: ", self.ticks
  echo "done: ", self.black
  for idx, worker in self.workers:
    let value = idx + 1
    echo &"worker {value}: ", worker
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

proc get_next_ready_node(self: GraphTraverse): Job =
  for node in sorted(toSeq(self.white)):
    if self.is_ready_node(node):
      self.white.excl(node)
      return (task: node, time: self.time_required(node))
    #
  #
  return IdleJob

proc tick(self: GraphTraverse, verbose = false) =
  self.ticks += 1

  for idx, old in self.workers:
    let worker: Job = (old.task, old.time - 1)
    self.workers[idx] = worker
    #
    if worker.time == 0:
      self.black &= worker.task
      self.workers[idx] = self.get_next_ready_node()
    
    if worker.task == '.':    # idle job
      self.workers[idx] = self.get_next_ready_node()
  # endfor

  if verbose:
    self.print_state()

proc working(self: GraphTraverse): bool =
  # Return true if there is a worker still working.
  # Return false if all workers are idle.
  for worker in self.workers:
    if worker.task != '.':
      return true
    #
  #
  false

proc start_traversal(self: GraphTraverse, verbose = true) =
  self.ticks = 0

  if verbose:
    self.print_state()

  # main loop
  while self.working():
    self.tick(verbose)

proc get_order(self: GraphTraverse): string =
  self.black.join

func get_ticks(self: GraphTraverse): int =
  self.ticks

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
    # (lines, workers, plus_time) = (readFile("example1.txt").strip.splitlines, 2, 0)
    (lines, workers, plus_time) = (readFile("input.txt").strip.splitlines, 5, 60)
    connections = get_connections(lines)
    start_node = get_start_node(connections)
    graph = newGraphTraverse()

  graph.add_connections(connections)
  graph.create_workers(workers)
  graph.set_plus_time(plus_time)
  graph.init_white_nodes()
  graph.set_start_node(start_node)
  graph.init_with_start_node()

  graph.start_traversal(verbose=true)

  let
    order = graph.get_order()
    ticks = graph.get_ticks()

  echo order
  echo ticks

# ############################################################################

when isMainModule:
  main()
