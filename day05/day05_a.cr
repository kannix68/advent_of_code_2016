#!/usr/bin/env crystal
##
# Advent of code 2016, AoC day 5 puzzle 1
# This solution (crystal 0.20.1) by kannix68, @ 2016-12-05.

require "crypto/md5"

MAXITER = 10_000_000
DOTEACH = 10_000

# helper
def assertmsg(cond, msg)
  if !cond
    abort "assert-ERROR on: #{msg}"
  else
    STDERR.puts "assert-OK: #{msg}"
  end
end

def process(str)
  passcode_found = false
  passcode = ""
  iter = 0
  suffixnum = -1
  
  while !passcode_found # no trailing `do` allowed!
    iter += 1
    suffixnum += 1
    testcode = str + suffixnum.to_s
    md5hash = Crypto::MD5.hex_digest(testcode)
    
    if md5hash[0,5] == "00000"
      STDERR.puts "\nmd5hash=#{md5hash} for #{testcode} @iter=#{iter} yields #{md5hash[5]} check=#{md5hash[0,5]}"
      passcode += md5hash[5]
      if passcode.size == 8 # no `.length` message, but *always* `.size`
        break
      end
    end
    if iter % DOTEACH == 0
      STDERR.print "."; STDERR.flush # has to be flushed, gets flushed only at puts and prog-end
    end
    if iter > MAXITER
      abort "max iterations reached"
    end
  end
  STDERR.puts "passcode=#{passcode}< found after calculating #{iter} MD5-hashcodes"
  return passcode
end

#** MAIN

str = "abc"
expct = "18f47a30"
assertmsg(process(str) == expct, "code for #{str} should be >#{expct}<")

str = ""
File.open("day05_data.txt").each_line do |line|
  str = line.chomp
  break
end

process(str)
