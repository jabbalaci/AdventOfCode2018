import strutils


const
  diff = ord('a') - ord('A')    # 32, a feature of the ASCII table


func reduce_polymer(text: string): string =
  result = text
  
  var
    changed = true

  # echo result
  while changed:
    changed = false
    for i in 0 .. (result.high - 1):
      let
        j = i + 1
        a = result[i]
        b = result[j]

      if abs(ord(a) - ord(b)) == diff:
        result[i] = '.'
        result[j] = '.'
        result = result.replace(".", "")
        changed = true
        # echo result
        break    # continue with the while
    # endfor
  # endwhile


proc main() =
  let
    # input = "dabAcCaCBAcCcaDA"
    input = readFile("input.txt").strip
    result = reduce_polymer(input)

  # echo result
  echo "Part 1: ", result.len

# ############################################################################

when isMainModule:
  main()
