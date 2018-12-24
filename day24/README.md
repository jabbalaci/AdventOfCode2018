Notes
=====

Link to the exercise: https://adventofcode.com/2018/day/24

Part 1
------

I had a problem with Part 1. My code worked with the example
but gave an incorrect result for my input. The value was too low.

I found a little help on [/r/adventofcode](https://old.reddit.com/r/adventofcode/comments/a93e27/day_24_part_1_wrong_answer_for_input/):

```
If a group tries to select a target but it would do 0 damage to the target,
skip the selection and let another group choose a target.
```

With this addition my code gave the correct result.

Part 2
------

I solved it with a technique similar to binary search. The program has a command-line
parameter, which is the boost value. Playing with this value I could find the correct
answer quickly.

```
$ ./part2 20
Winner: sdInfection
Part 1: 16852
==============================================================================
$ ./part2 30
Winner: sdImmuneSystem
Part 1: 7176
==============================================================================
$ ./part2 25
Winner: sdInfection
Part 1: 10869
==============================================================================
$ ./part2 28
Winner: sdImmuneSystem
Part 1: 4893
==============================================================================
$ ./part2 26
Winner: sdInfection
Part 1: 8796
==============================================================================
$ ./part2 27
^CSIGINT: Interrupted by Ctrl-C.
```

At value 27 it ran into an infinite loop, so I tried the output
of boost value 28 and it was the correct result.

What happened at value 27?
--------------------------

I looked into what happened with boost value 27. Both the immune system
and the infection have only one group left that are too weak to kill each other.
Hence the infinite loop.

Runtime
-------

* Part 1: 0.07 sec
* Part 2: 0.17 sec (by executing "`$ ./part2 28`")
