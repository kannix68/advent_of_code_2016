#!/usr/bin/env python2.7
## Advent of code 2016, AoC day 3 puzzle 1.
## This solution (python2.7) by kannix68, @ 2016-12-03.

def assert_msg(msg, assertion):
  assert assertion, "ERROR on assert: {}".format(msg)
  print "assert-OK: {}".format(msg)

# process a line, check if triangle is valid
def process_line(input):
  sides = map(int, input.split())
  print("sides={}".format(sides)),
  hypothenuse = max(sides)
  cathetes = sides
  cathetes.remove(hypothenuse)
  cathsum = sum(cathetes)
  isvalid = cathsum > hypothenuse
  print("  hypoth={}, cathetes={}, cathsum={}, isvalid={}".format(hypothenuse, cathetes, cathsum, isvalid))
  return isvalid

def process(input):
  trianglevalidct = 0
  for line in input:
    if process_line(line):
      trianglevalidct += 1
  return trianglevalidct

## MAIN

input = '''
5 10 25
'''.strip() # test data

print("input " + input)
result = process_line(input)
assert_msg("result = {}".format(result), result == False) # asser test data

infile = open("day03_data.txt", "r") # challenge data
input = infile.read()
infile.close()
data = input.splitlines()
result = process(data)
print("result = {} of ct={} for fileinput = {}".format(result, len(data), data[0:2])) # show challenge solution result
