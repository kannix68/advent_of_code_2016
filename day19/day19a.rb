#!/usr/bin/env ruby
##
# Advent of code 2016, AoC day 19 part 1.
# Day 19: An Elephant Named Joseph.
# This solution (ruby-2.3.3) by kannix68, @ 2016-12-19.
#
@maxrounds = 1024

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

@log_level = 0
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
def process(n)
  foundpart = 0
  parts = []
  for i in 0..n-1 do # init participants ary
    parts.push 1
  end
  infolog {"Starting, num-parts=#{n}"}
  round = 0
  finished = false
  while !finished and round < @maxrounds
    round += 1
    numparts = parts.select{|it| it>0}.size
    infolog {"ROUND ##{round}: num-parts=#{numparts}"}
    deblog {"  parts=#{parts}"}
    for i in 0..n-1 do
      if parts[i] > 0 and !finished
        for j in i+1..i+n do
          k = j % n
          #tracelog {"k=#{k}"}
          if parts[k] > 0
            parts[i] += parts[k]
            deblog {"part##{i} steals from part#{k}: #{parts[k]} => #{parts[i]}"}
            parts[k] = 0
            if parts[i] == n
              infolog {"FINISHED at round##{round}, participant=#{i+1}"}
              foundpart = i+1
              finished = true
            end
            break
          end
        end
      else
        tracelog {"part##{i} has nothing, is skipped."} unless finished
      end
    end
  end
  foundpart
end

##** MAIN
input = 5
expected = 3
result = process(input)
assertmsg(result == expected, "result=#{result} of n=#{input}, expected=#{expected}")

File.readlines("day19_data.txt").each do |line|
  input = line.strip.to_i
  break
end
result = process(input)
infolog {"result=#{result} of n=|#{input}|."}