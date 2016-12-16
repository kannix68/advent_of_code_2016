## Advent of code 2016, AoC day 16 part 1.
## This solution (python2.7) by kannix68, @ 2016-12-16.

def assert_msg(assertion, msg):
  assert assertion, "ERROR on assert: {}".format(msg)
  print "assert-OK: {}".format(msg)

def reverse_str(s):
  #return s[::-1]
  return "".join(reversed(s))

def gen_pseudorand_data(input):
  a = input
  b = reverse_str(input)
  b = b.replace("0","o").replace("1","0").replace("o","1")
  return "{}0{}".format(a,b)

def gen_filldisk_data(input, disklen):
  intermed = input
  while True:
    intermed = gen_pseudorand_data(intermed)
    print "loop: intermed-filldiskdata={}".format(intermed)
    if len(intermed) >= disklen:
      break # while
  if len(intermed) != disklen:
    intermed = intermed[0:disklen]
  return intermed

def gen_cksum(input):
  n = 2
  chk = 0
  intermed = input
  started = False
  while (not started) or (chk % 2 == 0):
    started = True
    zz = ""
    print "loop: intermed-cksum={}".format(intermed)
    for i in range(0, len(intermed), n):
      p = intermed[i:i+n]
      #print "  pair={}".format(p)
      if p == "00" or p == "11":
        zz += "1"
      else:
        zz += "0"
    intermed = zz
    chk = len(intermed)
    #print "  zz={}, chk-len={}, chk-len % 2={}".format(zz,chk,chk%2)
  return zz

def process(input, disklen):
  filldiskdata = gen_filldisk_data(input, disklen)
  diskcksum = gen_cksum(filldiskdata)
  print "process: cksum={}, filldiskdata={}".format(diskcksum, filldiskdata)
  return [filldiskdata, diskcksum] 

## INITialisation

# nothing to do

## MAIN

##** testing

# 1 becomes 100.
# 0 becomes 001.
# 11111 becomes 11111000000.
# 111100001010 becomes 1111000010100101011110000.

input = "1"
expected = "100"
result = gen_pseudorand_data(input)
assert_msg( result == expected, "result enc={} expected={} of input={}".format(result, expected, input))

input = "0"
expected = "001"
result = gen_pseudorand_data(input)
assert_msg( result == expected, "result enc={} expected={} of input={}".format(result, expected, input))

input = "11111"
expected = "11111000000"
result = gen_pseudorand_data(input)
assert_msg( result == expected, "result enc={} expected={} of input={}".format(result, expected, input))

input = "111100001010"
expected = "1111000010100101011110000"
result = gen_pseudorand_data(input)
assert_msg( result == expected, "result enc={} expected={} of input={}".format(result, expected, input))

input = "110010110100"
expected = "100"
result = gen_cksum(input)
assert_msg( result == expected, "result cksum={} expected={} of input={}".format(result, expected, input))

#** testing, "whole process"

input = "10000"
disklen = 20
expected = "10000011110010000111"
diskdata = gen_filldisk_data(input, disklen)
result = diskdata
assert_msg( result == expected, "result diskdata={} expected={} of input={}".format(result, expected, input))
# >continue>
input = diskdata
expected = "01100"
result = gen_cksum(input)
assert_msg( result == expected, "result disk-cksum={} expected={} of input={}".format(result, expected, input))

result_ary = process(input, disklen)
print "test process-result: {}".format(result_ary)

##** problem domain
input = "10111011111001111"
disklen = 272
result = process(input, disklen)
print "RESULT cksum={}".format(result[1])
