#!/usr/bin/env crystal
##
# Advent of code 2016, AoC day 5 puzzle 1
# This solution (crystal 0.20.1) by kannix68, @ 2016-12-05.
#
# compile with:
#    crystal build day05_b.cr --release
#    ./day05_b
# or run slowly with
#    crystal day05_b.cr

require "crypto/md5"

MAXITER = 100_000_000
DOTEACH = 100_000

# helper
def assertmsg(cond, msg)
  if !cond
    abort "assert-ERROR on: #{msg}"
  else
    STDERR.puts "assert-OK: #{msg}"
  end
end

# helper method for replacing character at index of string.
# !It is really tedious to have to do this instead of in-place-replace,
#   but Strings seem to be immutable.
def str_repl_idx(str, idx, replchar)
  ary = str.chars #str.split(""): this would be array of strings
  ary[idx] = replchar
  return ary.join("")
end

def process(str)
  passcode_found = false
  passcode = " "*8
  passcodect = 0
  iter = 0
  suffixnum = -1
  
  while !passcode_found
    iter += 1
    suffixnum += 1
    testcode = str + suffixnum.to_s
    md5hash = Crypto::MD5.hex_digest(testcode)
    
    if md5hash[0,5] == "00000"
      STDERR.puts "\nmd5hash=#{md5hash} for #{testcode} @iter=#{iter} yields #{[md5hash[5], md5hash[6]]} check0=#{md5hash[0,5]}"
      idxstr = md5hash[5]
      if !(idxstr.to_s =~ /^[0-7]$/) # !convert char to String!
        STDERR.puts "ignore invalid index #{idxstr}"
        next
      end
      idx = idxstr.to_i
      if passcode[idx].to_s != " " # !convert char to String!
        STDERR.puts "ignore overwrite on index #{idxstr}, char remains #{passcode[idx]}."
        next
      end
      passcodect += 1
      passchar = md5hash[6]
      #passcode[idx] = passchar
      passcode = str_repl_idx(passcode, idx, passchar)
      STDERR.puts "passcode=#{passcode}<"
      if passcodect == 8
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
expct = "05ace8e3"
assertmsg(process(str) == expct, "code for #{str} should be >#{expct}<")

str = ""
File.open("day05_data.txt").each_line do |line|
  str = line.chomp
  break
end

process(str)
