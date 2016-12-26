#!/usr/bin/env ruby
##
# Advent of code 2016, AoC day 25 part 1.
# Day 25: Clock Signal
# This solution (ruby-2.3.3) by kannix68, @ 2016-12-26.
# This problem is a continuation/variation of AoC16 day23,
#   which itself is a continuation of AoC16 day 12.
#
#TESTSTR = <<EOS
#cpy 2 a
#tgl a
#tgl a
#tgl a
#cpy 1 a
#dec a
#dec a
#EOS

MAXINSTRUCTIONS = 100_000_000 # 300, 10
MAXNUM = 10_000 # search upto magic-num test
CHECK_LENGTH = 64 #8 # how many alternating 0-1 numbers are sufficient?
DO_INNER_DOTS = false
DOTEACH = 10_000 #1_000

@loglevel=0

##** Helpers
def assertmsg(cond, msg)
  if !cond
    puts "assert-ERROR: #{msg}"
    exit 1
  end
  puts "assert-OK: #{msg}"
end

def tracelog(&block)
  if @loglevel > 1
    puts "T: #{yield}" # yield <=> block.call
  end
end
def deblog(&block)
  if @loglevel > 0
    puts "D: #{yield}" # yield <=> block.call
  end
end
def infolog(&block)
  puts "I: #{yield}" # yield <=> block.call
end

##** problem domain

def compute(lines, a_value)
  regs = {"a"=>a_value, "b"=>0, "c"=>0, "d"=>0} # initialize registers
  maxct = lines.length - 1
  deblog {"compute #{a_value}"}
  lineptr = 0

  instrct = 0
  dots = 0
  linerx = /^(cpy|inc|dec|jnz|out) ([a-d\-0-9]+) ?([a-d\-0-9]+)?$/
  regsrx = /^[abcd]$/
  outstr = ""
  prevstr = ""
  while lineptr <= maxct && instrct < MAXINSTRUCTIONS
    instrct += 1
    if instrct % DOTEACH == 0 && DO_INNER_DOTS
      dots += 1
      STDERR.print "."
      if dots % 100 == 0
        dots = 0
        STDERR.puts instrct
        STDERR.puts "regs=#{regs}"
      end
    end
    cur_lineptr = lineptr
    line = lines[lineptr]
    if match = line.match(linerx)
      instr, p1, p2 = match.captures
      #tracelog("instruction=#{instr} on #{match.captures[2..3]}")
      case instr
      when "out"
        val = 0
        if p1.match(regsrx)  # tgl a
          val = regs[p1]
        else  # tgl 2
          val = p1.to_i
        end
        deblog {"write-out #{val}; instr-ct=#{instrct}; lptr=#{lineptr}; regs=#{regs}; prevs=#{outstr}."}
        if outstr.length == 0
          if val != 0
            deblog {"fail-num=#{a_value}!  instr-ct=#{instrct}; lptr=#{lineptr}; wrong initial value >#{val}<."}
            #raise "wrong initial value >#{val}<"
            return false
          else
            prevint = val
            outstr += prevint.to_s
          end
        else
          if (prevint == 0 && val == 1) or (prevint == 1 && val == 0)
            prevint = val
            outstr += prevint.to_s
            if outstr.length == CHECK_LENGTH
              infolog {"found magic-num=#{a_value}; outstr=#{outstr}"}
              return true
            end
          else
            deblog {"fail-num=#{a_value}! instr-ct=#{instrct}; lptr=#{lineptr}; wrong next-int=#{val} for prev=#{prevint}"}
            #raise "wrong next-int=#{val} for prev=#{prevint}"
            return false
          end
        end
        lineptr += 1 # tgl continues with next instruction
        #...
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
          val2 = 0
          if p2.match(/^[abcd]$/)  # jnz 1, a
            val2 = regs[p2]
          else  # jnz 1, 5
            val2 = p2.to_i
          end
          lineptr += val2
          tracelog {"jnz from #{cur_lineptr} to #{lineptr}; val1=#{val}, val2=#{val2} "}
        end
      else
        raise "unknown instruction: #{match.captures}"
      end # case
    else
      raise "unparseable line: #{line}"
    end
    tracelog {"#{instrct}: instr #{instr} @##{cur_lineptr} done, cmd=#{match.captures.select{|v| !v.nil?}}, new ##{lineptr}; regs=#{regs}"}
  end
  if instrct >= MAXINSTRUCTIONS
    raise "Program ABORT. #{instrct} instructions. regs=#{regs}."
  end
  infolog {"program complete after #{instrct} instructions; regs=#{regs}"}
  #regs
  false
end

def process(lines)
  infolog {"process(lines): program length = #{lines.length}"}
  (0..MAXNUM).each do |num|
    if num % 10 == 0
      STDERR.print "."
    end
    if compute(lines, num)
      return num
    end
  end
  return -1
end

#** MAIN
#lines = []
#TESTSTR.each_line do |s|
#  line = s.chomp.chomp
#  lines.push(line)
#end
#infolog{"testing..."}
#res = compute(lines)
#infolog{"Test-result=#{res}"}

lines = []
File.readlines("day25_data.txt").each do |line|
  line1 = line.chomp.chomp.strip
  next if line1 == ""
  lines.push(line1)
end

infolog{"computing..."}
res = process(lines)
infolog{"result=#{res}"}
