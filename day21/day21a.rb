#!/usr/bin/env ruby
##
# Advent of code 2016, AoC day 21 part 1.
# Day 21: Day 21: Scrambled Letters and Hash.
# This solution by kannix68, @ 2016-12-21.

LOGLEVEL=1

#TESTSTR=<<EOS
#4-7
#EOS

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

def process_cmd(cmd, input)
  output = input.dup
  if md = (/^swap position (\d+) with position (\d+)$/.match cmd)
    # "swap position 4 with position 0"
    pos1 = md[1].to_i
    pos2 = md[2].to_i
    c1 = output[pos1]
    c2 = output[pos2]
    output[pos1] = c2
    output[pos2] = c1
    tracelog {"swap pos #{pos1} with #{pos2}; res=#{output}"}
  elsif md = (/^swap letter ([a-zA-Z]+) with letter ([a-zA-Z]+)$/.match cmd)
    # "swap letter d with letter b"
    # one-time swap
    pos1 = input.index(md[1])
    pos2 = input.index(md[2])
    c1 = output[pos1]
    c2 = output[pos2]
    output[pos1] = c2
    output[pos2] = c1
    tracelog {"swap letter #{pos1} with #{pos2}; res=#{output}"}
  elsif md = (/^reverse positions (\d+) through (\d+)$/.match cmd)
    # "reverse positions 0 through 4"
    pos1 = md[1].to_i
    pos2 = md[2].to_i
    len = pos2-pos1+1
    inner = input[pos1,len].reverse
    output[pos1,len] = inner
    tracelog {"reverse-str pos1=#{pos1}, pos2=#{pos2}, len=#{len}, swapped=#{inner}; res=#{output}"}
  elsif md = (/^rotate (left|right) (\d+) steps?$/.match cmd)
    # "rotate left 1 step"
    dir = md[1]
    len = md[2].to_i
    if dir == "right"
      len = -len
    end
    #output.rotate(len) # facets String
    output = input.split("").rotate(len).join("") # Array.rotate
    tracelog {"rotate-left len=#{len}; res=#{output}"}
  elsif md = (/^rotate based on position of letter ([a-zA-Z]+)?$/.match cmd)
    # "rotate based on position of letter b"
    pos1 = input.index(md[1])
    if pos1 >= 4
      idx = -pos1 - 2
    else
      idx = -pos1 - 1
    end 
    output = input.split("").rotate(idx).join("") # Array.rotate
    tracelog {"rotate-for-char-right chr=#{md[1]} pos=#{pos1} idx=#{idx}; res=#{output}"}
  elsif md = (/^move position (\d+) to position (\d+)$/.match cmd)
    # "move position 1 to position 4"
    pos1 = md[1].to_i
    pos2 = md[2].to_i
    c1 = output[pos1]
    output[pos1] = ""
    output.insert(pos2, c1)
    tracelog {"move char=#{c1} from=#{pos1} to=#{pos2}; res=#{output}"}
  else
    raise "unparseable line: #{cmd}"
  end
  output
end

# find solution, apply commands to input string, return result.
def process(commandsstr, input)
  tracelog {"process(commands, input)."}
  output = input.dup
  commandsstr.each_line do |line|
    #tracelog {"process line #{line}"}
    output = process_cmd(line, output)
  end
  output
end

##** MAIN
infolog {"Day starts..."}

input = "abcde"
cmd = "swap position 4 with position 0"
expected = "ebcda"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "swap letter d with letter b"
expected = "edcba"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "reverse positions 0 through 4"
expected = "abcde"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "rotate left 1 step"
expected = "bcdea"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "move position 1 to position 4"
expected = "bdeac"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "move position 3 to position 0"
expected = "abdec"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "rotate based on position of letter b"
expected = "ecabd"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "rotate based on position of letter d"
expected = "decab"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = "abcde"
commands = <<EOS
swap position 4 with position 0
swap letter d with letter b
reverse positions 0 through 4
rotate left 1 step
move position 1 to position 4
move position 3 to position 0
rotate based on position of letter b
rotate based on position of letter d
EOS
expected = "decab"
result = process(commands, input)
assertmsg( result == expected, "ALL tst result=#{result} of tst-in=#{input}; expected=#{expected}; commands.")

@input = "abcdefgh"
commands = IO.read("day21_data.txt")
infolog {"INPUT0=#{@input}"}
result = process(commands, @input)
infolog {"INPUT=#{@input}"}
infolog {"Solution result=#{result} of input=#{@input} and commands."}

infolog {"Day Ends.!"}
