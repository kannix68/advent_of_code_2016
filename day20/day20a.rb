#!/usr/bin/env ruby
##
# Advent of code 2016, AoC day 20 part 1.
# Day 20: Firewall rules.
# This solution (ruby-2.3.3) by kannix68, @ 2016-12-20.
#

TESTSTR = <<EOS
5-8
0-2
4-7
EOS

##** Helpers
def assertmsg(cond, msg)
  if !cond
    puts "assert-ERROR: #{msg}"
    exit 1
  end
  puts "assert-OK: #{msg}"
end

@log_level = 1
def tracelog(&block)
  STDERR.puts("T: #{yield}") unless @log_level < 2
end
def deblog(&block)
  STDERR.puts("D: #{yield}") unless @log_level < 1
end
def infolog(&block)
  STDOUT.puts("I: #{yield}")
end

##** problem domain

# find solution, input n=number of participants
def process(teststr)
  minnum = 0
  lastminnum = -1
  round = 0
  while lastminnum != minnum
    round += 1
    deblog {"Round-iter##{round}: last-min-num=#{lastminnum}"}
    lastminnum = minnum
    linum = 0
    teststr.each_line do |line|
      linum += 1
      line = line.chomp.chomp
      tracelog { "line##{linum}: #{line}" }
      rx = /^(\d+)\-(\d+)$/
      md = rx.match line
      if md.nil?
        raise "line ##{linum} not matched: #{line}"
      end
      tracelog { "found range=#{md[1]} to #{md[2]}" }
      rngmin = md[1].to_i
      rngmax = md[2].to_i
      if minnum >= rngmin && minnum <= rngmax
        deblog {"new min=#{rngmax+1} from #{minnum} by-range=#{rngmin}, #{rngmax}"}
        minnum = rngmax + 1
      end
    end
  end
  deblog {"found minimum=#{minnum}"}
  minnum
end

##** MAIN
infolog {"Day starts..."}
input = TESTSTR
expected = 3
result = process(input)
assertmsg(result == expected, "result=#{result} of TESTSTR, expected=#{expected}")

input = IO.read("day20_data.txt")
result = process(input)
infolog {"result=#{result} of input."}