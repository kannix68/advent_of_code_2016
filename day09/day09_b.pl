## Advent of code 2016, AoC day 9 puzzle 2.
## This solution by kannix68, @ 2016-12-09.
use v5.8.4;
use strict;
use warnings;
use English;

my $doteach = 250000;
my $start_tm;

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

# format thousands
#  see <
sub fts($) {
  return reverse(join('_', unpack("(A3)*", reverse(shift()))));
}

## expects string, returns decoded string
sub process($) {
  my $input = shift();
  my $rest = $input;
  my $output = "";
  my $loop = 0;
  #print "  input=$input\n";
  my ($last_llen, $last_rlen) = (0, 0);
  my $last_tm = time();
  $start_tm = $last_tm;
  while ($rest =~ m/^(.*?)\((\d+)x(\d+)\)(.*)$/) {
    my ($pre, $len, $rept, $remain) = ($1, $2, $3, $4); # found regex groups
    if ($loop % $doteach == 0) {
      my ($llen, $rlen) = (length($output), length($rest));
      my $tm = time();
      print STDERR ". left-len=" .  fts($llen) .
        "; right-len=" . fts(length($rest)) .
        "; delta-left=" . fts(($llen-$last_llen)) .
        "; delta-right=" . fts(($rlen-$last_rlen)) .
        "; time=" . ($tm - $last_tm) .
        "; sumTM=" . fts($tm - $start_tm) .
        "; loops=" . fts($loop) .
        ".\n";
      ($last_llen, $last_rlen, $last_tm) = ($llen, $rlen, $tm);
    }
    $loop++;
    #print "  found pre=$pre, cmd(len=$len, repeat=$rept), remain=$remain\n";
    $output .= $pre;
    #print "  output=$output; prepend\n";
    my $torepeat = substr($remain, 0, $len);
    my $insert = $torepeat x $rept;
    #$output .= $insert;
    #print "  output=$output; insert=$insert; remain=" . substr($remain, $len) . ".\n";
    $rest = $insert . substr($remain, $len);
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
  ["(3x3)XYZ", "XYZXYZXYZ"],
  ["X(8x2)(3x3)ABCY", "XABCABCABCABCABCABCY"],
  ["(27x12)(20x12)(13x14)(7x10)(1x12)A", "A" x 241920],
];

foreach my $test (@$tests) {
  my ($input, $expected) = @$test;
  my $result = process($input);
  assertmsg($result eq $expected, "result '$result' was expected to be '$expected' of input '$input'");
  print "result length = " . length($result) . "\n";
}
my $tinput = "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN";
my $tres = process($tinput);
assertmsg(length($tres) == 445, "result length should be 445 for input $tinput");

#* problem solution
my $input = readfile("day09_data.txt");
#print "raw input=>$input<\n";
$input =~ s/\s+//g; # strip whitspace including newlines
print "INPUT=>" . substr($input, 0, 16) . "...!\n";
my $result = process($input);
print "RESULT=>" . substr($result, 0, 16) . "...!\n";
print "result length = " . length($result) . "\n";
print "  time used=" . fts(time()-$start_tm) . " secs\n";
