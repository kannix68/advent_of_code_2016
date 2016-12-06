#!/usr/bin/env ruby
##
# Advent of code 2016, AoC day 5 puzzle 1
# This solution (ruby-2.3.3) by kannix68, @ 2016-12-05.

require "minitest/autorun"

require "digest/md5"

MAXITER = 10000000
DOTEACH = 10000

def process(str)
  passcode_found = false
  passcode = ""
  iter = 0
  suffixnum = -1
  
  while !passcode_found do
    iter += 1
    suffixnum += 1
    testcode = str + suffixnum.to_s
    md5hash = Digest::MD5.hexdigest(testcode)
    
    if md5hash[0,5] == "00000"
      STDERR.puts "\nmd5hash=#{md5hash} for #{testcode} @iter=#{iter} yields #{md5hash[5]} check=#{md5hash[0,5]}"
      passcode += md5hash[5]
      if passcode.length == 8
        break
      end
    end
    if iter % DOTEACH == 0
      STDERR.print "."
    end
    if iter > MAXITER
      abort "max iterations reached"
    end
  end
  STDERR.puts "passcode=#{passcode} found after calculation #{iter} MD5-hashcodes"
  return passcode
end


class Tests < Minitest::Test
  def test_str
    str = "abc"
    expct = "18f47a30"
    assert process(str) == expct, "passcode for roomid=#{str} should be {expct}"
  end
end

str = ""
File.open("day05_data.txt").each_line do |line|
  str = line.chomp
  break
end

process(str)
#exit
