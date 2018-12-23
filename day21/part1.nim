
discard """

I used a decompiler to understand the input.
See the `decompiler/` folder for more info.

Relevant part of my decompiled input:

     e = 0;
     do {
         d = e | 0x10000;
         e = 10552971;
 8:      f = d & 0xff;
         e += f;
         e &= 0xffffff;
         e *= 65899;
         e &= 0xffffff;
         if 256 <= d {
             f = 0;
18:          c = f + 1;
             c *= 256;
             if c <= d {
                 f += 1;
                 goto 18;
             }
             d = f;
             goto 8;
         }
     } while e != a;

"""

proc main() =
  var
    a, b, c, d, e, f: int

  d = e or 0x10000
  e = 10552971
  while true:
    f = d and 0xff
    e += f
    e = e and 0xffffff
    e *= 65899
    e = e and 0xffffff
    if 256 <= d:
      f = 0
      while true:
        c = f + 1
        c *= 256
        if c <= d:
          f += 1
        else:
          break
        # endif
      # endwhile
      d = f
    else:
      break
    # endif
  # endwhile

  echo e

# ############################################################################

when isMainModule:
  main()
