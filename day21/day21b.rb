#!/usr/bin/env ruby
##
# Advent of code 2016, AoC day 21 part 1.
# Day 21: Day 21: Scrambled Letters and Hash.
# This solution by kannix68, @ 2016-12-21.

LOGLEVEL=0

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

def cmd_swap_pos(instr, md)
  # "swap position 4 with position 0"
  output = instr.dup
  pos1 = md[1].to_i
  pos2 = md[2].to_i
  c1 = output[pos1]
  c2 = output[pos2]
  output[pos1] = c2
  output[pos2] = c1
  tracelog {"swap pos #{pos1} with #{pos2}; res=#{output}"}
  output
end

def cmd_swap_pos_inv(instr, md)
  # "swap position 4 with position 0"
  # INVERSE: SAME
  cmd_swap_pos(instr, md)
end

def cmd_swap_letter(instr, md)
  # "swap letter d with letter b"
  output = instr.dup
  pos1 = instr.index(md[1])
  pos2 = instr.index(md[2])
  c1 = output[pos1]
  c2 = output[pos2]
  output[pos1] = c2
  output[pos2] = c1
  tracelog {"swap letter #{pos1} with #{pos2}; res=#{output}"}
  output
end

def cmd_swap_letter_inv(instr, md)
  # "swap letter d with letter b"
  # INVERSE: SAME
  cmd_swap_letter(instr, md)
end

def cmd_reverse_posns(instr, md)
  # "reverse positions 0 through 4"
  output = instr.dup
  pos1 = md[1].to_i
  pos2 = md[2].to_i
  len = pos2-pos1+1
  inner = instr[pos1, len].reverse
  output[pos1, len] = inner
  tracelog { "reverse-str pos1=#{pos1}, pos2=#{pos2}, len=#{len}, swapped=#{inner}; res=#{output}" }
  output
end

def cmd_reverse_posns_inv(instr, md)
  # "reverse positions 0 through 4"
  # INVERSE: SAME
  cmd_swap_letter(instr, md)
end

def cmd_rotate_steps(instr, md)
  # "rotate left 1 step"
  output = instr.dup
  dir = md[1]
  len = md[2].to_i
  if dir == "right"
    len = -len
  end
  #output.rotate(len) # facets String
  output = output.split("").rotate(len).join("")
  tracelog { "rotate-left len=#{len}; res=#{output}" }
  output
end

def cmd_rotate_steps_inv(instr, md)
  # "rotate left 1 step"
  # INVERSE: change direction
  output = instr.dup
  dir = md[1]
  len = md[2].to_i
  if dir == "right"
    len = -len
  end
  len = -len
  output = output.split("").rotate(len).join("")
  tracelog { "rotate-left-INV len=#{len}; res=#{output}" }
  output
end

def cmd_rotate_charpos(instr, md)
  # "rotate based on position of letter b"
  output = instr.dup
  pos1 = instr.index(md[1])
  if pos1 >= 4
    idx = -pos1 - 2
  else
    idx = -pos1 - 1
  end
  output = output.split("").rotate(idx).join("")
  tracelog { "rotate-for-char-right chr=#{md[1]} pos=#{pos1} idx=#{idx}; res=#{output}" }
  output
end

def cmd_rotate_charpos_inv(instr, md)
  # "rotate based on position of letter b"
  # INVERSE: trial and error
  deblog { "cmd_rotate_charpos_inv instr=#{instr}" }
  output = instr.dup
  found = false
  (0..instr.length).each do |idx|
    output = instr.split("").rotate(idx).join("")
    tmp = cmd_rotate_charpos(output, md)
    deblog { "for in=#{instr} compare #{tmp} == #{output} " }
    if tmp == instr
      found = true
      break
    end
  end
  if !found
    raise "inverse not found for #{instr}"
  end
  output
end

def cmd_move_pos(instr, md)
  # "move position 1 to position 4"
  output = instr.dup
  pos1 = md[1].to_i
  pos2 = md[2].to_i
  c1 = output[pos1]
  output[pos1] = ""
  output.insert(pos2, c1)
  tracelog { "move char=#{c1} from=#{pos1} to=#{pos2}; res=#{output}" }
  output
end

def cmd_move_pos_inv(instr, md)
  # "move position 1 to position 4"
  # INVERSE: exchange from and to!
  output = instr.dup
  pos2 = md[1].to_i
  pos1 = md[2].to_i
  c1 = output[pos1]
  output[pos1] = ""
  output.insert(pos2, c1)
  tracelog { "move-INV char=#{c1} from=#{pos1} to=#{pos2}; res=#{output}" }
  output
end

##** problem domain

def process_cmd(cmd, input)
  if md = (/^swap position (\d+) with position (\d+)$/.match cmd)
    # "swap position 4 with position 0"
    output = cmd_swap_pos(input, md)
  elsif md = (/^swap letter ([a-zA-Z]+) with letter ([a-zA-Z]+)$/.match cmd)
    # "swap letter d with letter b"
    # one-time swap
    output = cmd_swap_letter(input, md)
  elsif md = (/^reverse positions (\d+) through (\d+)$/.match cmd)
    # "reverse positions 0 through 4"
    output = cmd_reverse_posns(input, md)
  elsif md = (/^rotate (left|right) (\d+) steps?$/.match cmd)
    # "rotate left 1 step"
    output = cmd_rotate_steps(input, md) # Array.rotate
  elsif md = (/^rotate based on position of letter ([a-zA-Z]+)?$/.match cmd)
    # "rotate based on position of letter b"
    output = cmd_rotate_charpos(input, md) # Array.rotate
  elsif md = (/^move position (\d+) to position (\d+)$/.match cmd)
    # "move position 1 to position 4"
    output = cmd_move_pos(input, md)
  else
    raise "unparseable line: #{cmd}"
  end
  output
end

def process_cmd_inverse(cmd, input)
  if md = (/^swap position (\d+) with position (\d+)$/.match cmd)
    # "swap position 4 with position 0"
    output = cmd_swap_pos_inv(input, md)
  elsif md = (/^swap letter ([a-zA-Z]+) with letter ([a-zA-Z]+)$/.match cmd)
    # "swap letter d with letter b"
    # one-time swap
    output = cmd_swap_letter_inv(input, md)
  elsif md = (/^reverse positions (\d+) through (\d+)$/.match cmd)
    # "reverse positions 0 through 4"
    output = cmd_reverse_posns(input, md)
  elsif md = (/^rotate (left|right) (\d+) steps?$/.match cmd)
    # "rotate left 1 step"
    output = cmd_rotate_steps_inv(input, md) # Array.rotate
  elsif md = (/^rotate based on position of letter ([a-zA-Z]+)?$/.match cmd)
    # "rotate based on position of letter b"
    output = cmd_rotate_charpos_inv(input, md) # Array.rotate
  elsif md = (/^move position (\d+) to position (\d+)$/.match cmd)
    # "move position 1 to position 4"
    output = cmd_move_pos_inv(input, md)
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

def process_inverse(commandsstr, input)
  deblog {"process_inverse(commands, input=#{input})."}
  output = input.dup
  cmds = []
  commandsstr.each_line do |line|
    line = line.chomp.chomp.strip
    if line == ""
      next
    end
    cmds.push line
  end
  cmds.reverse.each do |line|
    deblog {"process-INV line #{line}, input=#{output}"}
    output = process_cmd_inverse(line, output)
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

result = process_cmd_inverse(cmd, result)
assertmsg( result == input, "INVtst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "swap letter d with letter b"
expected = "edcba"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

result = process_cmd_inverse(cmd, result)
assertmsg( result == input, "INVtst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "reverse positions 0 through 4"
expected = "abcde"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

result = process_cmd_inverse(cmd, result)
assertmsg( result == input, "INVtst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "rotate left 1 step"
expected = "bcdea"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

result = process_cmd_inverse(cmd, result)
assertmsg( result == input, "INVtst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "move position 1 to position 4"
expected = "bdeac"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

result = process_cmd_inverse(cmd, result)
assertmsg( result == input, "INVtst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "move position 3 to position 0"
expected = "abdec"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

result = process_cmd_inverse(cmd, result)
assertmsg( result == input, "INVtst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "rotate based on position of letter b"
expected = "ecabd"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

result = process_cmd_inverse(cmd, result)
assertmsg( result == input, "INVtst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

input = expected
cmd = "rotate based on position of letter d"
expected = "decab"
result = process_cmd(cmd, input)
assertmsg( result == expected, "tst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

result = process_cmd_inverse(cmd, result)
assertmsg( result == input, "INVtst result=#{result} of tst-in=#{input}; expected=#{expected}; cmd=#{cmd}")

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
infolog {"Solution 1 result=#{result} of input=#{@input} and commands."}

@input = "fbgdceah"
result = process_inverse(commands, @input)
infolog {"Solution 2 result=#{result} of input=#{@input} and REVERSED commands."}

infolog {"Day Ends.!"}
