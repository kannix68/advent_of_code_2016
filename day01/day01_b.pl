#!/usr/bin/env perl
## Advent of code 2016, AoC day 1 puzzle 2.
## This solution by kannix68, @ 2016-12-01.
use v5.8.4;
use strict;
use warnings;
use English;

my %turns_r = ("N"=>"E", "E"=>"S", "S"=>"W", "W"=>"N"); # "R" turns
my %turns_l = ("N"=>"W", "W"=>"S", "S"=>"E", "E"=>"N"); # "L" turns

## Expects Message and asserion condition, dies on error, prints message otherwise.
sub assertmsg($$) {
  my ($msg, $assertion) = @ARG; # @_
  die("assert-ERROR on: $msg") unless $assertion;
  print("assert-OK: $msg\n");
}

## Expects String input like "R2L3...", returns (int) distance from origin.
sub process($) {
  my $input = shift();
  my $santa_heading = "N";  # initial heading
  my @santa_gridpos = (0,0);  # initial grid position, (x,y)
  my $iter = 0;
  foreach my $walk (split(/, /, $input)) {
    $iter++;
    my ($dir, $len) = split(/(?<=[RL])/, $walk);
    if ($dir eq "R") {  # get new heading
      $santa_heading = $turns_r{$santa_heading};
    } elsif ($dir eq "L") {
      $santa_heading = $turns_l{$santa_heading};
    }
    if ($santa_heading eq 'N') {  # get new grid-position
      $santa_gridpos[1] += $len;
    } elsif ($santa_heading eq 'S') {
      $santa_gridpos[1] -= $len;
    } elsif ($santa_heading eq 'E') {
      $santa_gridpos[0] += $len;
    } elsif ($santa_heading eq 'W') {
      $santa_gridpos[0] -= $len;
    }
  }
  print("$iter data points\n");
  return(abs($santa_gridpos[0])+abs($santa_gridpos[1]));  # return dist from origin
}

sub process2($) {
  my $input = shift();
  my $santa_heading = "N";  # initial heading
  my @santa_gridpos = (0,0);  # initial grid position, (x,y)
  my %pts_visited = ();
  my $iter = 0;
  $pts_visited{$santa_gridpos[0].','.$santa_gridpos[1]} = 1;
  foreach my $walk (split(/, /, $input)) {
    $iter++;
    my ($dir, $len) = split(/(?<=[RL])/, $walk);
    if ($dir eq "R") {  # get new heading
      $santa_heading = $turns_r{$santa_heading};
    } elsif ($dir eq "L") {
      $santa_heading = $turns_l{$santa_heading};
    }
    for(my $i=1; $i <= $len; $i++) { # number of grid single steps
      if ($santa_heading eq 'N') {  # get new grid-position
        $santa_gridpos[1] += 1;
      } elsif ($santa_heading eq 'S') {
        $santa_gridpos[1] -= 1;
      } elsif ($santa_heading eq 'E') {
        $santa_gridpos[0] += 1;
      } elsif ($santa_heading eq 'W') {
        $santa_gridpos[0] -= 1;
      }
      if (defined($pts_visited{$santa_gridpos[0].','.$santa_gridpos[1]})) {
        print("iteration $iter: grid position " . $santa_gridpos[0].','.$santa_gridpos[1] . " already visited\n");
        return(abs($santa_gridpos[0])+abs($santa_gridpos[1]));  # return dist from origin
      } else {
        $pts_visited{$santa_gridpos[0].','.$santa_gridpos[1]} = 1;
      }
    }
  }
  #return(abs($santa_gridpos[0])+abs($santa_gridpos[1]));  # return dist from origin
  die("no gridpos visited twice");
}

my $input = "R2, L3";
my $result = process($input);
assertmsg("result $result of input $input", $result==5);

$input = "R2, R2, R2";
$result = process($input);
assertmsg("result $result of input $input", $result==2);

$input = "R5, L5, R5, R3";
$result = process($input);
assertmsg("result $result of input $input", $result==12);

open(DATAFP, "day01_data.txt")
  or die($!);
my $data = <DATAFP>;
close(DATAFP);
$data =~ s/(\x0D)?\x0A$//; # get rid of lineending
$input = $data;
$result = process($input);
print("result of my data input = $result\n");

$input ="R8, R4, R4, R8";
$result = process2($input);
assertmsg("result (B) $result of input $input", $result==4);

$input = $data;
$result = process2($input);
print("result (B) of my data input = $result\n");


