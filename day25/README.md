Notes
=====

Link to the exercise: https://adventofcode.com/2018/day/25

Algorithm
---------

First, loop over the points and create clusters of them. If the current
point is close to a point in a cluster, then add the current point to
that cluster.

When the clusters are found, it can happen that two neighboring clusters
are close to one another, thus they can be joined. In the second phase
I join the clusters. Say we have clusters A and B, and in B we find a point
that is close to a point in A. In this case there's a bridge between the
two clusters and they can be joined: I move every point from B
to A. Since B has become empty, cluster B can be deleted.

When there's no more movement between the clusters, we can stop.

Runtime
-------

* Part 1: 0.03 sec
