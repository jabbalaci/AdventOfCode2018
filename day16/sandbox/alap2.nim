# shorter version

func twice(n: int): int =
  2 * n

proc main() =
  let
    foo = [twice]

  echo twice(4)
  echo foo[0](4)

# ############################################################################

when isMainModule:
  main()
