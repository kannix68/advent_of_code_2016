#!/usr/bin/env perl6
##
# Advent of code 2016, day 18 part 1.
# This solution by kannix68, @ 2016-12-18.

use v6;
#use strict;  # perl6: always-on
#use warnings;  # perl 6: couldn't find
#use English;  # perl 6: couldn't find

#** VARAs
my $num_rows = 3;  # target number of rows
my $TEST1 = "..^^.";
my $TEST2 = ".^^.^.^^^^";

#** Helpers
sub assertmsg($cond, $msg) {
  die "assert-ERROR: $msg" unless $cond;
  say "assert-OK: $msg";
}
my $LOGLEVEL = 0;
sub tracelog($str){
  if ($LOGLEVEL >= 2) {
    say "T: $str";
  }
}
sub deblog($str){
  if ($LOGLEVEL >= 1) {
    say "D: $str";
  }
}
sub infolog($str){
  say "I: $str";
}

#** problem domain

sub compute_world($line1){
  deblog("World width="~$line1.chars~", line1= $line1 ");
  
  my @linear = split("", $line1).grep(/^.+$/);
  tracelog @linear.join(";");
  my $max_idx = @linear.elems-1;
  #assertmsg($max_idx == $line1.chars-1 , "str/ary length congruence: $max_idx");
  my $nextline = "";
  my @world = ($line1);

  for 2..$num_rows -> $it {
    for 0..$max_idx -> $idx {
      my $pic = "";
      for $idx-1..$idx+1 -> $prev_idx {
        if ($prev_idx < 0) {
          $pic ~= ".";
        } elsif ($prev_idx > $max_idx) {
          $pic ~= ".";
        } else {
          $pic ~= @linear[$prev_idx];
        }
      }
      if (($pic eq "^^.") or ($pic eq ".^^") or ($pic eq "^..") or ($pic eq "..^")) {
        $nextline ~= "^";
      } else {
        $nextline ~= ".";
      }
      tracelog "pic for idx=$idx => $pic";
    }
    deblog "pushing line #$it: $nextline";
    @world.push($nextline);
    @linear = split("", $nextline).grep(/^.+$/);
    $nextline = "";
  }
  
  return @world
}

sub print_world(@world){
  my ($dimx, $dimy) = (@world[0].chars, @world.elems);
  infolog "wld:/" ~ "="x$dimx ~ "; dim=($dimx, $dimy)";
  for 0..(@world.elems-1) -> $idx {
    infolog "l#$idx |" ~ @world[$idx];
  }
}

sub count_safetiles(@world){
  my $ct = 0;
  for @world -> $line {
    my $tmp = $line.split("").grep(".").elems;
    #tracelog "safe-ct=$tmp for grep-line=$line";
    $ct += $tmp;
  }
  return $ct;
}

#** MAIN
say "Starting day18...";

my ($inp, $expected, $ct, @world);

$num_rows = 3;
$inp = $TEST1;
$expected = 6;
say "TEST#1, input=$inp, num-rows=$num_rows";
@world = compute_world($inp);
print_world(@world);
$ct = count_safetiles(@world);
assertmsg($ct == $expected, "Result safetile-count=$ct, expected=$expected");

$num_rows = 10;
$inp = $TEST2;
$expected = 38;
say "TEST#2, input=$inp, num-rows=$num_rows";
@world = compute_world($inp);
print_world(@world);
$ct = count_safetiles(@world);
assertmsg($ct == $expected, "Result safetile-count=$ct, expected=$expected");

$num_rows = 40;
#$inp = "day18_data.txt".IO.slurp;
#$inp ~~ s:g/[^\.\^]//;
for "day18_data.txt".IO.lines -> $line {
  $inp = $line.chomp;
  last;
}
infolog "input data=::$inp ::";
@world = compute_world($inp);
print_world(@world);
$ct = count_safetiles(@world);
infolog("RESULT safetiles-count=$ct");
say "Day 18 ends.!";
