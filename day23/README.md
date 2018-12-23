Notes
=====

Link to the exercise: https://adventofcode.com/2018/day/23

For Part 2 I realized it was impossible to use brute force.
My solution is not optimal and it's quite slow, but I didn't
find a better solution.

I followed this algorithm:

* From the 3D space let's select a good candidate. It'll be
  the starting point.
* From the starting point I do a hill climbing. I look at the
  neighbors of the current point (there are 26), and I select the
  best one, which becomes the new current point. Repeat it until
  we can find a better point. When there is no better point among
  the neighbors, we stop. The current point is the result.

When is a neighbor better?

If the neighbor is in range of more nanobots, then it's a better point.
If it's in range of the same number of nanobots but it's closer to
the point (0, 0, 0), then again it's a better point.

How to select the starting point?

I looked at the positions of the nanobots and chose the best one.
The best one is in range of the largest number of nanobots. If there
are two or more candidate points, then select the one that is closest
to (0, 0, 0).

Runtime
-------

* Part 1: 0.00 sec
* Part 2: 513.98 sec
