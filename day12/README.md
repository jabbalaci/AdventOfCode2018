Notes
=====

Link to the exercise: https://adventofcode.com/2018/day/12

I suffered with this exercise :) But the execution times show that it was worth...

Part 1 was OK.

However, Part 2 was challenging. I knew processing 50 billion generations
would be impossible, so there had to be a trick.

First, I thought the same state would repeat itself after a while.
Here I compared the pattern of plants *and* the leftmost index too and I didn't
find a repetition.

Then, I thought there would be a loop, i.e. the same pattern of plants
would return after a while. After visualizing the patterns, I could figure out
that the pattern of plants stabilizes after a while BUT the plants
move one position to the right (shift right). It means that the leftmost
index also moves to the right, and that's why I didn't find a repetition
at the beginning.

After this it was easy to compute the leftmost index of the last (50 billionth)
generation. The pattern of plants was the same.

Runtime
-------

* Part 1: 0.00 sec
* Part 2: 0.00 sec :)
