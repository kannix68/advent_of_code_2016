#!/usr/bin/env python2.7
## Advent of code 2016, AoC day 2 puzzle 2
## This solution (python2.7) by kannix68, @ 2016-12-02.

def assert_msg(msg, assertion):
  assert assertion, "ERROR on assert: {}".format(msg)
  print "assert-OK: {}".format(msg)

def invert_dict(indict):
  outdict = {}
  for key, val in indict.iteritems():
    outdict[val] = key
  return outdict

def process(input):
  output = ""
  pos = "5"
  for line in input:  # iterate lines
    for char in line:  # iterate chars in line
      pos = moves.get(char).get(pos, pos) # move to new position on valid move, else stay
    output += pos
  return output

moves_r = {"2":"3", "3":"4", "5":"6", "6":"7", "7":"8", "8":"9", "A":"B", "B":"C"} # "R" moves
moves_l = invert_dict(moves_r) # "L" moves, is "R" inverted
moves_u = {"A":"6", "6":"2", "D":"B", "B":"7", "7":"3", "3":"1", "C":"8", "8":"4"} # "U" moves
moves_d = invert_dict(moves_u) # "D" moves, is "U" inverted
moves = { "R": moves_r, "L": moves_l, "U": moves_u, "D": moves_d, }

## MAIN

input = '''
ULL
RRDDD
LURDL
UUUUD
'''.strip() # test data

print("input " + input)
data = input.splitlines()
result = process(data)
assert_msg("result = {}".format("5DB3"), result == "5DB3") # asser test data

infile = open("day02_data.txt", "r") # challenge data
input = infile.read()
data = input.splitlines()
result = process(data)
print("result for fileinput = {}; inp={}".format(result, input)) # show challenge solution result
