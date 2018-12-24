import os

## Mimicking Python's ``sys`` module to some extent.
##
## To avoid confusion with the ``system`` module from the stdlib,
## it's called ``jsystem``, which stands for "jabba's system" module.


# #######
# Types #
# #######

type
  JabbaSys = tuple
    argv: seq[string]


# ######
# Vars #
# ######

proc getArgv(): seq[string] =
  result &= getAppFilename()
  for i in 1 .. paramCount():
    result &= paramStr(i)

var sys*: JabbaSys = (
  argv: getArgv()
)
  ## Mimics Python's ``sys.argv``. It contains the file name and the parameters,
  ## just like in C or Python.
  ##
  ## ``sys.argv`` can be modified in Python, that's why it's a ``var``.
