Notes
=====

After solving Part 2, a few hours later it popped into my mind: "I could've used rfind()".
I tried it with `rfind()` too but it was very slow. And the reason is that if the substring
is not found on the right side, it goes on until the beginning, which becomes very expensive if
the base string is long.

So the original idea was good: take the end of the base string and narrow the substring search
to this part only.
