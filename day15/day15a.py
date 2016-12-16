## Advent of code 2016, AoC day 15 part 1.
## This solution (python2.7) by kannix68, @ 2016-12-16.

##** imports
import re

##** Helpers
def assert_msg(assertion, msg):
  assert assertion, "ERROR on assert: {}".format(msg)
  print "assert-OK: {}".format(msg)

def reverse_str(s):
  #return s[::-1]
  return "".join(reversed(s))

def copy_full(inlist): # < deep-copy of list-of-lists
  if isinstance(inlist, list):
    return list( map(copy_full, inlist) )
  return inlist

##** Problem domain functions
def parse_disks(mlstr):
  rx = '''^Disc #(\d+) has (\d+) positions; at time=(\d+), it is at position (\d+).$'''
  rxc = re.compile(rx)

  strdata = input.splitlines()
  disks = []
  print "disks={}".format(disks)
  for line in strdata:  # iterate lines
    print "line={}".format(line)
    mr = rxc.match(line)
    #print "  rx result={}".format(mr)
    disknr = mr.group(1)
    numposns = mr.group(2)
    diskt0 = mr.group(3)
    post0 = mr.group(4)
    print "  rx mresult={}, {}, {}, {}".format(disknr, numposns, diskt0, post0)
    inner = [int(numposns), int(post0)]
    disks.append(inner)
    print "disks={}".format(disks)
  return disks

def tick(disks):
  res = copy_full(disks)
  loop = 0
  #print "tick:"
  for disk in res:
    loop += 1
    newpos = (disk[1] + 1) % disk[0]
    #print "  disc#{} newpos={}; from pos={} of #disks={}".format(loop, newpos, disk[1], disk[0])
    disk[1] = newpos
  return res


def tick_n(disks, ticks):
  res = copy_full(disks)
  loop = 0
  #print "tick:"
  for disk in res:
    loop += 1
    newpos = (disk[1] + ticks) % disk[0]
    #print "  disc#{} newpos={}; from pos={} of #disks={}".format(loop, newpos, disk[1], disk[0])
    disk[1] = newpos
  return res


def process(disks):
  max_preticks = 1000000 #10000 # CONSTANT

  numdisks = len(disks)
  print "found num disks={}".format(numdisks)
  initdisks = copy_full(disks)

  state = False
  preticks = -1
  while state == False and preticks < max_preticks:
    preticks += 1
    disks = initdisks
    #print "preticks={}".format(preticks)

    #for n in range(preticks): # n preticks clockticks
    #  disks = tick(disks)
    disks = tick_n(disks, preticks)

    for n in range(numdisks):
      #print "  loop t={} n={}".format(preticks+n, n)
      disks = tick(disks)
      state = disks[n][1] == 0
      if not state:
        if n > 1:
          print "  loop n={} FAIL for disk {}; preticks t0={}; tsum={}".format(n, n, preticks, preticks+n)
        break
      #else:
      #  #print "   ok for disk {}".format(n)
    #-print "State={} after disc-ticks={} and pre-ticks={}.".format(state,numdisks, preticks)
  if state == True:
    return preticks
  else:
    return -preticks

## INITialisation

# nothing to do

## MAIN

##** testing
input = '''
Disc #1 has 5 positions; at time=0, it is at position 4.
Disc #2 has 2 positions; at time=0, it is at position 1.
'''.strip()

disks = parse_disks(input)

t0 = process(disks)
print "TEST t0 !=! {}".format(t0)

##** problem domain
input = '''
Disc #1 has 13 positions; at time=0, it is at position 10.
Disc #2 has 17 positions; at time=0, it is at position 15.
Disc #3 has 19 positions; at time=0, it is at position 17.
Disc #4 has 7 positions; at time=0, it is at position 1.
Disc #5 has 5 positions; at time=0, it is at position 0.
Disc #6 has 3 positions; at time=0, it is at position 1.
'''.strip()

disks = parse_disks(input)
t0 = process(disks)
print "RESULT t0 !=! {}".format(t0)
