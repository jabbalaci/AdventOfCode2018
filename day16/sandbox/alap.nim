# Thanks to @zacharycarter on IRC for showing me how to store
# functions in an array.

type
  fptr = (func(x: int): int)

func twice(n: int): int =
  2 * n

proc main() =
  let
    myf: fptr = twice
    foo: array[1, fptr] = [myf]

  echo twice(4)
  echo foo[0](4)

# ############################################################################

when isMainModule:
  main()
