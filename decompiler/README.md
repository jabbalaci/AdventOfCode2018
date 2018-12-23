Notes
=====

The virtual machine exercises f\*ed my brain, so I
used a decompiler, written by @ttencate. Thanks!

Reddit announcement of the decompiler is here:
https://old.reddit.com/r/adventofcode/comments/a8dkz2/2018_days_16_19_21_i_made_an_elfcode_decompiler/

Usage example
-------------

```bash
$ ./decompiler < ../day19/example1.txt
     b = 5;
     c = 6;
     goto 4;
     d = b + c;
 4:  ip = b;
     e = 8;
     f = 9;
```
