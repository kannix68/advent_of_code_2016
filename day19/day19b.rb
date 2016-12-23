#!/usr/bin/env ruby
##
# Advent of code 2016, AoC day 19 part 1.
# Day 19: An Elephant Named Joseph.
# This solution (ruby-2.3.3) by kannix68, @ 2016-12-19.
#
@maxrounds = 1000_000 #_000_000
DOTEACH = 10_000

#TESTSTR = <<EOS
#cpy 41 a
#EOS

#MAXINSTRUCTIONS = 100_000_000
#DOTEACH = 10_000

##** Helpers
def assertmsg(cond, msg)
  if !cond
    puts "assert-ERROR: #{msg}"
    exit 1
  end
  puts "assert-OK: #{msg}"
end

@loglevel = 1
def tracelog(&block)
  STDERR.puts("T: #{yield}") unless @loglevel < 2
end
def deblog(&block)
  STDERR.puts("D: #{yield}") unless @loglevel < 1
end
def infolog(&block)
  STDOUT.puts("I: #{yield}")
end

##** problem domain

# find solution, input n=number of participants
def process(n)
  foundpart = 0
  parts = {}
  curkeys = []
  for i in 1..n do # init participants hash
    parts[i] = 1
    curkeys.push i
  end
  infolog {"Starting, num-parts=#{parts.size}"}
  round = 0
  finished = false
  playrptr = -1
  loop = 0
  lasttm = Time.now
  while !finished and round < @maxrounds
    playrptr += 1
    loop += 1
    if loop % DOTEACH == 0
      tm = Time.now
      deblog {". remain=#{parts.size}; loop-tm=#{tm-lasttm}; sum-tm=#{tm-@starttm}"}
      lasttm = tm
    end
    if playrptr > parts.size-1
      round += 1
      playrptr = 0
      infolog {"next ROUND #{round}, left-num-parts=#{parts.size}"}
    end
    #curkeys = parts.keys.sort
    curkeysize = curkeys.size
    oppositeidx = ((curkeysize/2)+playrptr)%curkeysize
    curkey = curkeys[playrptr]
    stealkey = curkeys[oppositeidx]
    #tracelog {"rnd#{round}, idx=#{playrptr}, p=#{curkey} has #{parts[curkey]}, st=#{stealkey} has #{parts[stealkey]} idx=#{oppositeidx}"}
    parts[curkey] += parts[stealkey]
    if parts[curkey] == n
      finished = true
      foundpart = curkey
      tm = Time.now
      infolog {"FINISHED @ loop #{loop}, round #{round}; loop-tm=#{tm-lasttm}; sum-tm=#{tm-@starttm}"}
      break
    end
    parts.delete(curkeys[oppositeidx])
    curkeys.delete_at oppositeidx
    #tracelog {parts}
    if oppositeidx < playrptr # adjust next player position
      playrptr -= 1
      #tracelog {"  reduce-idx"}
    end
  end
  foundpart
end

##** MAIN
@starttm = Time.now
input = 5
expected = 2
result = process(input)
assertmsg(result == expected, "result=#{result} of n=#{input}, expected=#{expected}")

File.readlines("day19_data.txt").each do |line|
  input = line.strip.to_i
  break
end
@starttm = Time.now
result = process(input)
infolog {"result=#{result} of n=|#{input}|."}
