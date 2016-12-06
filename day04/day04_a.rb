#!/usr/bin/env ruby
##
# Advent of code 2016, AoC day 4 puzzle 1.
# This solution (ruby-2.3) by kannix68, @ 2016-12-04.

require 'minitest/autorun'
require 'PP'

##
# Determine if given room string is valid
def room_valid(str)
  # aaaaa-bbb-z-y-x-123[abxyz]
  if /^([a-z]+[a-z\-]+)\-(\d+)\[([a-z]{5})\]$/.match(str) then
    matchdata = Regexp.last_match
    letters = matchdata[1].gsub('-','')
    secid = matchdata[2]
    cksum = matchdata[3]
    puts "match, letters=#{letters}, secid=#{secid}, cksum=#{cksum} for #{str}"
    letter_freqs = Hash.new(0) # default number 0
    letters.split("").each do |c|
      letter_freqs[c] += 1
    end
    pp letter_freqs
    letters_ary = []
    letter_freqs.each_key do |k|
      letters_ary.push k
    end
    # sort by number found descending and then lexical
    letters_sorted = letters_ary.sort { |a,b| [ -letter_freqs[a], a ] <=> [ -letter_freqs[b], b ] }
    pp letters_sorted
    newcksum = letters_sorted[0..4].join('')
    puts "newcksum=#{newcksum}"
    return newcksum == cksum
  else
    puts "NO-match for #{str}"
    return false
  end
end

def room_secid(str)
  if /^([a-z]+[a-z\-]+)\-(\d+)\[([a-z]{5})\]$/.match(str) then
    matchdata = Regexp.last_match
    letters = matchdata[1].gsub('-','')
    secid = matchdata[2]
    cksum = matchdata[3]
    #puts "match, letters=#{letters}, secid=#{secid}, cksum=#{cksum} for #{str}"
    letter_freqs = Hash.new(0) # default number 0
    letters.split("").each do |c|
      letter_freqs[c] += 1
    end
    #pp letter_freqs
    letters_ary = []
    letter_freqs.each_key do |k|
      letters_ary.push k
    end
    # sort by number found descending and then lexical
    letters_sorted = letters_ary.sort { |a,b| [ -letter_freqs[a], a ] <=> [ -letter_freqs[b], b ] }
    #pp letters_sorted
    newcksum = letters_sorted[0..4].join('')
    #puts "newcksum=#{newcksum}"
    if newcksum == cksum then
      puts "OK checksum-match for secid=#{secid}"
      return secid.to_i
    else
      puts "NO-checksum-match for #{str}"
      return 0 
    end
  else
    puts "NO-match for #{str}"
    return 0
  end
end

#** MAIN

class Tests < Minitest::Test
  def test_str
    str = "aaaaa-bbb-z-y-x-123[abxyz]"
    assert room_valid(str) == true, "room #{str} should be OK"
    
    str = "a-b-c-d-e-f-g-h-987[abcde]"
    assert room_valid(str) == true, "room #{str} should be OK"
    
    str = "not-a-real-room-404[oarel]"
    assert room_valid(str) == true, "room #{str} should be OK"
    
    str = "totally-real-room-200[decoy]"
    assert room_valid(str) == false, "room #{str} should be invalid"
  end
end

#infolog("query idx=#{qidx}");
linect = 0
secsum = 0
File.open('day04_data.txt').each do |line|
  linect += 1
  secsum += room_secid(line.chomp)
end

puts "number of rooms=#{linect}, sector-id-sum=#{secsum}"
