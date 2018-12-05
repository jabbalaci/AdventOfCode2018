import strutils
import sequtils


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


func find_shortest_polymer(text: string): string =
  var shortest_polymer = text
  let alphabet = ('a' .. 'z').toSeq
  
  for c in alphabet:
    let
      C = chr(ord(c) - diff)    # uppercase the current character
      current_polymer = text.replace($c, "").replace($C, "")
      reduced_polymer = reduce_polymer(current_polymer)

    if reduced_polymer.len < shortest_polymer.len:
      shortest_polymer = reduced_polymer
  #
  shortest_polymer


proc main() =
  let
    # input = "dabAcCaCBAcCcaDA"
    input = readFile("input.txt").strip
    result = find_shortest_polymer(input)
  
  # echo result
  echo "Part 2: ", result.len

# ############################################################################

when isMainModule:
  main()
