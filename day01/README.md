Notes
=====

At first, [part2.nim](part2.nim) was much slower than the [Python solution](part2.py).
At IRC we figured out that this line caused the problem:

    var seen = initSet[int]()

When the initial size of the set was specified, it became
very fast (faster than the Python version):

    var seen = initSet[int](2 ^ 17)    # 131_072

However, when the initial size was set to `65_536 (2 ^ 16)`, it
was also very slow. In this case the set had to be enlargened
just once, so it's not clear why it is that slow in this case...
This is something to be investigated.

Solution
--------

It turned out that there is an [intsets](https://nim-lang.org/docs/intsets.html)
module in the stdlib, which is similar to Java's BitSet, i.e. it implements an int set
using a bit set.

After some benchmarks, this proved to be the fastest solution:

    import intsets

    var
      seen = initIntSet()    # we don't specify its size

Then, you can use it similarly to a `HashMap[int]`.
