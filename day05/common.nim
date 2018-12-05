import strutils


const
  diff* = ord('a') - ord('A')    # 32, a feature of the ASCII table

# optimized version
func reduce_polymer*(text: string): string =
  result = text

  var i = 0
  
  # echo result
  while i < result.high:
    let
      j = i + 1
      a = result[i]
      b = result[j]

    if abs(ord(a) - ord(b)) == diff:
      result[i] = '.'
      result[j] = '.'
      result = result.replace(".", "")
      i -= 1
      continue
    # else
    i += 1
  # endfor


# original idea, slower version
# func reduce_polymer*(text: string): string =
#   result = text
  
#   var
#     changed = true

#   # echo result
#   while changed:
#     changed = false
#     for i in 0 .. (result.high - 1):
#       let
#         j = i + 1
#         a = result[i]
#         b = result[j]

#       if abs(ord(a) - ord(b)) == diff:
#         result[i] = '.'
#         result[j] = '.'
#         result = result.replace(".", "")
#         changed = true
#         # echo result
#         break    # continue with the while
#     # endfor
#   # endwhile
