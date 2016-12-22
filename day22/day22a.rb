#!/usr/bin/env ruby
##
# Advent of code 2016, AoC day 22 part 1.
# Day 22: Grid Computing.
# This solution by kannix68, @ 2016-12-22.

LOGLEVEL=1

##** Helpers
def assertmsg(cond, msg)
  if !cond
    puts "assert-ERROR: #{msg}"
    exit 1
  end
  puts "assert-OK: #{msg}"
end

def tracelog(&block)
  if LOGLEVEL > 1
    puts "T: #{yield}" # yield <=> block.call
  end
end
def deblog(&block)
  if LOGLEVEL > 0
    puts "D: #{yield}" # yield <=> block.call
  end
end
def infolog(&block)
  puts "I: #{yield}" # yield <=> block.call
end

##** problem domain

#def process_cmd(dfstr)
#end

# find solution, apply commands to input string, return result.
def process(dfstr)
  tracelog {"process(commands, input)."}
  #"""Filesystem              Size  Used  Avail  Use%
  #   /dev/grid/node-x0-y0     92T   73T    19T   79%"""
  linect = 0
  nodes = {}
  dfstr.each_line do |line|
    linect += 1
    line = line.chomp.chomp
    tracelog { "read-line #{linect}: #{line}" }
    if md = (/^\/dev\/grid\/node\-x(\d+)\-y(\d+) +(\d+)T +(\d+)T +(\d+)T +(\d+)%$/.match line) #md = (/^\/dev\/grid\/node\-x(\d+)\-y(\d+) +(\d+) +(\d+) +(\d+) +(\d+)%$/.match line)
      x = md[1].to_i
      y = md[2].to_i
      siz = md[3].to_i
      usd = md[4].to_i
      ava = md[5].to_i
      prc = md[6].to_i
      key = "#{x},#{y}"
      nodes[key] = {:size=>siz, :used=>usd, :avail=>ava, :useperc=>prc}
      tracelog {"node[#{key}]=#{nodes[key]}"}
    else
      deblog {"  skipped line ##{linect} #{line}."}
    end
  end
  deblog {"#nodes=#{nodes.size} of #lines=#{linect}"}
  
  viabpairnum = 0
  nodes.each do |a_key, a_vals|
    nodes.each do |b_key, b_vals|
      #next if a_key == b_key
      if a_vals[:used] > 0 && a_key != b_key && a_vals[:used] <= b_vals[:avail]
        tracelog {"viable pair: A=#{a_key}, used=#{a_vals[:used]}; B=#{b_key}, avail=#{b_vals[:avail]}"}
        viabpairnum += 1
      end
    end
  end
  viabpairnum
end

##** MAIN
infolog {"Day starts..."}

#input = "abcde"
#cmd = "swap position 4 with position 0"
#expected = "ebcda"
#result = process_cmd(cmd, input)
#assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

#input = "abcde"
#commands = <<EOS
#swap position 4 with position 0
#swap letter d with letter b
#reverse positions 0 through 4
#rotate left 1 step
#move position 1 to position 4
#move position 3 to position 0
#rotate based on position of letter b
#rotate based on position of letter d
#EOS
#expected = "decab"
#result = process(commands, input)
#assertmsg( result == expected, "ALL tst result=#{result} of tst-in=#{input}; expected=#{expected}; commands.")

filename = "day22_data.txt"
dfstr = IO.read(filename)
infolog {"INPUT from file #{filename}"}
result = process(dfstr)
infolog {"Solution result=#{result} of in-file=#{filename}."}

infolog {"Day Ends.!"}
