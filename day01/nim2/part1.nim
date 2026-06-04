#!/usr/bin/env nimbang
#off:nimbang-args c -d:release
#nimbang-settings hideDebugInfo

import std/strutils    # strip, split, join
import std/sequtils    # toSeq(iter), map, filter
import std/math        # sum

proc main() =
  # let fname = "example.txt"
  let fname = "input.txt"

  let result = readFile(fname).strip.splitLines.map(parseInt).sum

  echo result

# ############################################################################

when isMainModule:
  main()
