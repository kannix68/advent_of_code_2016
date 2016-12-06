#!/usr/bin/env python2.7
## Advent of code 2016, AoC day 3 puzzle 1.
## This solution (python2.7) by kannix68, @ 2016-12-03.

def assert_msg(msg, assertion):
  assert assertion, "ERROR on assert: {}".format(msg)
  print "assert-OK: {}".format(msg)

# process a list of 3 sides, check if triangle is valid
def process_list(sides):
  print("sides={}".format(sides)),
  hypothenuse = max(sides)
  cathetes = sides
  cathetes.remove(hypothenuse)
  cathsum = sum(cathetes)
  isvalid = cathsum > hypothenuse
  print("  hypoth={}, cathetes={}, cathsum={}, isvalid={}".format(hypothenuse, cathetes, cathsum, isvalid))
  return isvalid

# process a line, check if triangle is valid
def process_line(input):
  sides = map(int, input.split())
  return process_list(sides)

def process(input):
  col1 = []
  col2 = []
  col3 = []
  for line in input:
    sides = map(int, line.split())
    col1.append(sides[0])
    col2.append(sides[1])
    col3.append(sides[2])
  allsides = col1 + col2 + col3
  print("list of all sides={}".format(allsides))
  trianglevalidct = 0
  for i in range(0, len(allsides)-1, 3):
    sides = allsides[i:i+3]
    print("trinagle sides={}".format(sides))
    if process_list(sides):
      trianglevalidct += 1
  return trianglevalidct

## MAIN

input = '''
101 301 501
102 302 502
103 303 503
201 401 601
202 402 602
203 403 603
'''.strip() # test data

print("input " + input)
data = input.splitlines()
result = process(data)
print("result = {} of ct={} for fileinput = {}".format(result, len(data), data[0:2])) # show challenge solution result

infile = open("day03_data.txt", "r") # challenge data
input = infile.read()
infile.close()
data = input.splitlines()
result = process(data)
print("result = {} of ct={} for fileinput = {}".format(result, len(data), data[0:2])) # show challenge solution result
