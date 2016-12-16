#!/usr/bin/env ruby
##
#  Advent of code 2016, AoC day 12 part 2.
# Day 12: Day 12: Leonardo's Monorail.
# This solution (ruby-2.3.3) by kannix68, @ 2016-12-12.
# This problem is analogous to aoc15, day23:
#   running a simple instruction set assembler program on a small set of registers.
#
TESTSTR = <<EOS
cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a
EOS

MAXINSTRUCTIONS = 100_000_000
DOTEACH = 10_000

@log_level = 0
def tracelog(s)
  STDERR.puts("T: #{s}") unless @log_level < 2
end
def deblog(s)
  STDERR.puts("D: #{s}") unless @log_level < 1
end
def infolog(s)
  STDOUT.puts("I: #{s}")
end


def compute(lines)
  regs = {"a"=>0, "b"=>0, "c"=>1, "d"=>0} # initialize registers
  maxct = lines.length - 1
  infolog "program length = #{lines.length}"
  lineptr = 0

  instrct = 0
  while lineptr <= maxct && instrct < MAXINSTRUCTIONS
    instrct += 1
    if instrct % DOTEACH == 0
      STDERR.print "."
    end
    cur_lineptr = lineptr
    line = lines[lineptr]
    if match = line.match(/^(cpy|inc|dec|jnz) ([a-d\-0-9]+) ?([a-d\-0-9]+)?$/)
      instr, p1, p2 = match.captures
      #tracelog("instruction=#{instr} on #{match.captures[2..3]}")
      case instr
      when "cpy"
        if !p2.match(/^[abcd]$/)
          raise "unparseable cpy: line"
        end
        if p1.match(/^[abcd]$/) # copy from register
          regs[p2] = regs[p1]
        else # copy from value
          regs[p2] = p1.to_i
        end
        lineptr += 1
      when "inc"
        if !p2 == ""
          raise "superfluous param on inc: line"
        end
        regs[p1] += 1
        lineptr +=1
      when "dec"
        if !p2 == ""
          raise "superfluous param on dec: line"
        end
        regs[p1] -= 1
        lineptr +=1
      when "jnz"
        val = 0
        if p1.match(/^[abcd]$/)  # jnz a, 2
          val = regs[p1]
        else  # jnz 1, 5
          val = p1.to_i
        end
        if val == 0
          lineptr += 1 # no jump
          #tracelog "jnz NOJUMP from #{cur_lineptr} to #{lineptr}"
        else
          lineptr += p2.to_i
          #tracelog "jnz from #{cur_lineptr} to #{lineptr}"
        end
      else
        raise "unknown instruction #{match.captures}"
      end # case
    else
      raise "unparseable line #{line}"
    end
    deblog "#{instrct}: instr #{instr} @##{cur_lineptr} done, cmd=#{match.captures.select{|v| !v.nil?}}, new ##{lineptr}; regs=#{regs}"
  end
  if instrct >= MAXINSTRUCTIONS
    raise "Program ABORT. #{instrct} instructions. regs=#{regs}."
  end
  infolog("program complete after #{instrct} instructions")
  regs
end

#** MAIN
lines = []
TESTSTR.each_line do |s|
  line = s.chomp
  lines.push(line)
end

infolog("testing...")
res = compute(lines)
infolog("Test-result=#{res}")

lines = []
File.readlines("day12_data.txt").each do |line|
  lines.push(line)
end

infolog("computing...")
res = compute(lines)
infolog("result=#{res}")

