import strutils


const
  diff* = ord('a') - ord('A')    # 32, a feature of the ASCII table


# even better, using a stack, version 2
func reduce_polymer*(text: string): string =
  var
    stack = newSeq[char]()

  for c in text:
    if stack.len == 0:
      stack &= c
      continue
    # else, the stack is not empty
    let top = stack[^1]
    if abs(ord(c) - ord(top)) == diff:
      discard stack.pop()
    else:
      stack &= c
  # endfor

  stack.join


# optimized, version 1
# func reduce_polymer*(text: string): string =
#   result = text

#   var i = 0
  
#   # echo result
#   while i < result.high:
#     let
#       j = i + 1
#       a = result[i]
#       b = result[j]

#     if abs(ord(a) - ord(b)) == diff:
#       result[i] = '.'
#       result[j] = '.'
#       result = result.replace(".", "")
#       i -= 1
#       continue
#     # else
#     i += 1
#   # endfor


# original idea, slow, version 0
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
