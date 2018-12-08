Notes
=====

Link to the exercise: https://adventofcode.com/2018/day/5

I put the function `reduce_polymer()` in a common module.

First, I implemented it in a naive way. That is, when I made a change,
I restarted the traversal of the polymer from left to right. Of course,
it was expensive.

Then, I realized, that if you make a change, you don't need to jump back
to the beginning of the polymer, you can go on. The optimized version
traverses the polymer just once, from left to right.

Runtimes of Part 2:

* not optimized: 6.26 sec
* optimized: 2.99 sec

Update
------

After solving the exercise, I looked around on /r/adventodcode , and someone
said (s)he used a stack. And then I realized that I should have also used this
data structure!

I re-implemented `reduce_polymer()` with a stack and it became ultra fast :)

New runtime of Part 2: 0.03 sec
