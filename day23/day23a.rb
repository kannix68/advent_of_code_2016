#!/usr/bin/env ruby
##
# Advent of code 2016, AoC day 23 part 1.
# Day 23: Safe Cracking
# This solution (ruby-2.3.3) by kannix68, @ 2016-12-23.
# This problem is a continuation/variation of AoC16 day 12.
#
TESTSTR = <<EOS
cpy 2 a
tgl a
tgl a
tgl a
cpy 1 a
dec a
dec a
EOS

MAXINSTRUCTIONS = 100_000_000 # 300, 10
DOTEACH = 10_000 #1_000
EGGS = 7

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

def compute(lines)
  regs = {"a"=>EGGS, "b"=>0, "c"=>0, "d"=>0} # initialize registers
  maxct = lines.length - 1
  infolog {"program length = #{lines.length}"}
  lineptr = 0

  instrct = 0
  dots = 0
  while lineptr <= maxct && instrct < MAXINSTRUCTIONS
    instrct += 1
    if instrct % DOTEACH == 0
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
    linerx = /^(cpy|inc|dec|jnz|tgl) ([a-d\-0-9]+) ?([a-d\-0-9]+)?$/
    if match = line.match(linerx)
      instr, p1, p2 = match.captures
      #tracelog("instruction=#{instr} on #{match.captures[2..3]}")
      case instr
      when "tgl"
        val = 0
        if p1.match(/^[abcd]$/)  # tgl a
          val = regs[p1]
        else  # tgl 2
          val = p1.to_i
        end
        targetptr = lineptr + val
        infolog {"tgl-instr for line##{targetptr+1}: #{line} :: #{lines[targetptr]}"}
        if targetptr > maxct || targetptr < 0
          deblog {"skip invalid target-lineptr #{targetptr} instr-ct=#{instrct}"}
          lineptr += 1
          next
        end
        if md2 = lines[targetptr].match(linerx)
          trginstr, tp1, tp2 = md2.captures
          case trginstr
          when "tgl"
            lines[targetptr] = lines[targetptr].sub("tgl", "inc")
            tracelog {"switch line#=#{targetptr+1}: tgl to inc: #{lines[targetptr]}"}
          when "inc"
            lines[targetptr] = lines[targetptr].sub("inc", "dec")
            tracelog {"switch line#=#{targetptr+1}: inc to dec: #{lines[targetptr]}"}
          when "dec"
            lines[targetptr] = lines[targetptr].sub("dec", "inc")
            tracelog {"switch line#=#{targetptr+1}: dec to inc: #{lines[targetptr]}"}
          when "jnz"
            lines[targetptr] = lines[targetptr].sub("jnz", "cpy")
            tracelog {"switch line#=#{targetptr+1}: jnz to cpy: #{lines[targetptr]}"}
          when "cpy"
            lines[targetptr] = lines[targetptr].sub("cpy", "jnz")
            tracelog {"switch line#=#{targetptr+1}: cpy to jnz: #{lines[targetptr]}"}
          else
            raise "unknown target instruction #{lines[targetptr]}"
          end
        else
          raise "unparseable target line #{lines[targetptr]}"
        end
        infolog {"  new line##{targetptr+1}: #{lines[targetptr]}"}
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
    deblog {"#{instrct}: instr #{instr} @##{cur_lineptr} done, cmd=#{match.captures.select{|v| !v.nil?}}, new ##{lineptr}; regs=#{regs}"}
  end
  if instrct >= MAXINSTRUCTIONS
    raise "Program ABORT. #{instrct} instructions. regs=#{regs}."
  end
  infolog {"program complete after #{instrct} instructions"}
  regs
end

#** MAIN
lines = []
TESTSTR.each_line do |s|
  line = s.chomp.chomp
  lines.push(line)
end

infolog{"testing..."}
res = compute(lines)
infolog{"Test-result=#{res}"}

lines = []
File.readlines("day23_data.txt").each do |line|
  line1 = line.chomp.chomp.strip
  next if line1 == ""
  lines.push(line1)
end

infolog{"computing..."}
res = compute(lines)
infolog{"result=#{res}"}
