#!/usr/bin/env ruby
##
# Advent of code 2016, AoC day 5 puzzle 2.
# This solution (ruby-2.3.3) by kannix68, @ 2016-12-05.

require "minitest/autorun"

require "digest/md5"

MAXITER = 100_000_000
DOTEACH = 100_000

def process(str)
  passcode_found = false
  passcode = " "*8
  passcodect = 0
  iter = 0
  suffixnum = -1
  
  while !passcode_found do
    iter += 1
    suffixnum += 1
    testcode = str + suffixnum.to_s
    md5hash = Digest::MD5.hexdigest(testcode)
    
    if md5hash[0,5] == "00000"
      STDERR.puts "\nmd5hash=#{md5hash} for #{testcode} @iter=#{iter} yields #{[md5hash[5], md5hash[6]]} check0=#{md5hash[0,5]}"
      idx = md5hash[5]
      if !(idx =~ /^[0-7]$/)
        STDERR.puts "ignore invalid index #{idx}"
        next
      end
      idx = idx.to_i
      if passcode[idx] != " "
        STDERR.puts "ignore overwrite on index #{idx}"
        next
      end
      passcodect += 1
      passchar = md5hash[6]
      passcode[idx] = passchar
      STDERR.puts "passcode=#{passcode}<"
      if passcodect == 8
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
  STDERR.puts "passcode=#{passcode}< found after calculating #{iter} MD5-hashcodes"
  return passcode
end


class Tests < Minitest::Test
  def test_str
    str = "abc"
    expct = "05ace8e3"
    assert process(str) == expct, "passcode for roomid=#{str} should be >#{expct}<"
  end
end

str = ""
File.open("day05_data.txt").each_line do |line|
  str = line.chomp
  break
end

process(str)
