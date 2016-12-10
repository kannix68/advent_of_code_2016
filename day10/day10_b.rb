#!/usr/bin/env ruby
##
# Advent of code 2016, AoC day 10 puzzle 2.
# This solution (ruby-2.3.3) by kannix68, @ 2016-12-10.
#
# test data:
TESTSTR = <<EOS
value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2
EOS

class Bot
  attr_reader :name
  attr_accessor :values
  attr_reader :output_low_type, :output_low
  attr_reader :output_high_type, :output_high
  
  def initialize(name, output_low_type, output_low, output_high_type, output_high)
    @name = name
    @output_low_type = output_low_type
    @output_low = output_low
    @output_high_type = output_high_type
    @output_high = output_high
    @values = []
  end
  
  def to_s
    "bot(#{@name}; o_l=#{@output_low_type}:#{@output_low}, o_h=#{@output_high_type}:#{@output_high}; vv=#{@values})"
  end
end

def process_line(str)
  STDERR.puts "process: #{str}"
  if /^value (\d+) goes to bot (\d+)$/.match(str) then
    matchdata = Regexp.last_match
    v, b = matchdata[1..2]
    STDERR.puts "  val=#{v}, to-bot=#{b}"
    $vals.push [v, b]
  elsif /^bot (\d+) gives low to (output|bot) (\d+) and high to (output|bot) (\d+)$/.match(str)
    matchdata = Regexp.last_match
    b, olt, ol, oht, oh = matchdata[1..5]
    newbot = Bot.new(b, olt, ol, oht, oh)
    STDERR.puts "  created-bot=#{newbot}"
    $bots[newbot.name] = newbot
    if olt == "output" then
      $outs[ol] = ""
    end
    if oht == "output" then
      $outs[oh] = ""
    end
  else
    raise "unknown command: #{str}"
  end
end

def process_bot_values(bot)
  if bot.values.size == 2 then
    loval, hival = bot.values.map {|v| v.to_i}.sort # compare integer values!
    STDERR.puts "  bot #{bot.name} full, comparing #{loval}, #{hival}."
    bot.values = []
    if bot.output_low_type == "output"
      outp = bot.output_low
      STDERR.puts "  set-output id=#{outp} value=#{loval}"
      $outs[outp] = loval
    elsif bot.output_low_type == "bot"
      targetbot = $bots[bot.output_low]
      STDERR.puts "  set-bot-val id=#{targetbot.name} value=#{loval}"
      targetbot.values.push loval
    end
    if bot.output_high_type == "output"
      outp = bot.output_high
      STDERR.puts "  set-output id=#{outp} value=#{hival}"
      $outs[outp] = hival
    else
      targetbot = $bots[bot.output_high]
      STDERR.puts "  set-bot-val id=#{targetbot.name} value=#{hival}"
      targetbot.values.push hival
    end
  end
end

def process_bot_value(bot, val)
  bot.values.push val
  STDERR.puts "process-bot-val: val=#{val} to-bot=#{bot.name} :now: #{bot}"
  process_bot_values(bot)
end

def process(str)
  str.each_line do |line|
    process_line(line)
  end
  STDERR.puts "num bots=" + $bots.keys.size.to_s
  STDERR.puts "num values=" + $vals.size.to_s
  STDERR.puts "num outputs=" + $outs.keys.size.to_s
  $bots.sort.to_h.each_key do |k|
    STDERR.puts "Bot #{k} = #{$bots[k]}"
  end
  loop = 0
  STDERR.puts "Values-Loop #{loop} >>>"
  $vals.each do |va|
    val, tobot = va
    bot = $bots[tobot]
    process_bot_value(bot, val)
  end
  compared = true
  while compared do
    loop += 1
    STDERR.puts "Values-Loop #{loop} >>>"
    compared = false
    $bots.sort.to_h.each_key do |k|
      if $bots[k].values.size == 2 then
        compared = true
        process_bot_values($bots[k])
      end
    end
  end # while
  $outs.sort.to_h.each_key do |k|
    STDERR.puts "Output #{k} = #{$outs[k]}"
  end
  STDERR.puts "PROCESS done."
end

$bots = {}
$vals = []
$outs = {}

#data_str = TESTSTR
data_str = File.read("day10_data.txt")
process(data_str)

res = $outs["0"] * $outs["1"] * $outs["2"]
puts "multiplied outputs 0..2 = #{res}"
