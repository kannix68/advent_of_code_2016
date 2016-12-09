## Advent of code 2016, AoC day 9 puzzle 1.
## This solution by kannix68, @ 2016-12-09.
use v5.8.4;
use strict;
use warnings;
use English;

## Expects Message and asserion condition, dies on error, prints message otherwise.
sub assertmsg($$) {
  my ($assertion, $msg) = @ARG; # @_
  die("assert-ERROR on: $msg") unless $assertion;
  print("assert-OK: $msg\n");
}

## read a file given by filename, return content as is.
sub readfile($) {
  my $filename = shift();
  my $outstr = "";
  open(my $fh, "<$filename") #open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open file '$filename' $!";
  while (my $line = <$fh>) {
    $outstr .= $line; #chomp $line; print "$line\n";
  }
  return $outstr;
}

## expects string, returns decoded string
sub process($) {
  my $input = shift();
  my $rest = $input;
  my $output = "";
  my $loop = 0;
  #print "  input=$input\n";
  while ($rest =~ m/^(.*?)\((\d+)x(\d+)\)(.*)$/) {
    my ($pre, $len, $rept, $remain) = ($1, $2, $3, $4); # found regex groups
    $loop++;
    #print "  found pre=$pre, cmd(len=$len, repeat=$rept), remain=$remain\n";
    $output .= $pre;
    #print "  output=$output; prepend\n";
    my $torepeat = substr($remain, 0, $len);
    my $insert = $torepeat x $rept;
    $output .= $insert;
    #print "  output=$output; after inserting decoded $insert.\n";
    $rest = substr($remain, $len);
    #print "  rest is now=$rest\n";
  }
  $output .= $rest;
  #print "  final output=$output; after $loop replacements.\n";
  print "  decoded $loop replacements.\n";
  return $output;
}

#** MAIN
#* tests
my $tests = [
  ["ADVENT", "ADVENT"],
  ["A(1x5)BC", "ABBBBBC"],
  ["(3x3)XYZ", "XYZXYZXYZ"],
  ["A(2x2)BCD(2x2)EFG", "ABCBCDEFEFG"],
  ["(6x1)(1x3)A", "(1x3)A"],
  ["X(8x2)(3x3)ABCY", "X(3x3)ABC(3x3)ABCY"],
];

foreach my $test (@$tests) {
  my ($input, $expected) = @$test;
  my $result = process($input);
  assertmsg($result eq $expected, "result '$result' was expected to be '$expected' of input '$input'");
  print "result length = " . length($result) . "\n";
}

#* problem solution
my $input = readfile("day09_data.txt");
#print "raw input=>$input<\n";
$input =~ s/\s+//g; # strip whitspace including newlines
print "INPUT=>$input<\n";
my $result = process($input);
print "RESULT=>$result<\n";
print "result length = " . length($result) . "\n";
