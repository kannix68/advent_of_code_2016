#!/usr/bin/env julia

function assertmsg(assertion, msg)
  if !assertion
    println("assert-ERROR: $msg")
    exit(1)
  else
    println("assert-OK: $msg")
  end
end

## expects string, returns decoded string
function process(inp)
  rest = inp
  outp = ""
  loop = 0
  println("  input=$inp")
  m = match(r"^(.*?)\((\d+)x(\d+)\)(.*)$", rest)
  while m != nothing
    loop += 1
    println("regex matched for input $inp, loop=$loop")
    pre, len, rept, remain = m.captures
    leni = parse(Int64, len)
    repti = parse(Int64, rept)
    println("  found pre=$pre, cmd(len=$len, repeat=$rept), remain=$remain")
    outp = string(outp, pre)
    println("  outp=$outp; prepended")
    torepeat = remain[1:leni]
    insrt = repeat(torepeat, repti)
    println("  torepeat=$torepeat; insrt=$insrt")
    outp = string(outp, insrt)
    println("  outp=$outp; inserted")
    rest = remain[leni+1:end]
    println("  new rest=$rest")
    m = match(r"^(.*?)\((\d+)x(\d+)\)(.*)$", rest)
  end
  outp = string(outp, rest)
  outp
end


#** MAIN

assertmsg(true, "success message")
#assertmsg(false, "fail message")
#assertmsg(true, "success message")

inp = "ABC"
expct = "ABC"
res = process(inp)
assertmsg(res == expct, "result $res of input $inp should be $expct")

tests = [
  ["ADVENT" "ADVENT"];
  ["A(1x5)BC" "ABBBBBC"];
  ["(3x3)XYZ" "XYZXYZXYZ"];
  ["A(2x2)BCD(2x2)EFG" "ABCBCDEFEFG"];
  ["(6x1)(1x3)A" "(1x3)A"];
  ["X(8x2)(3x3)ABCY" "X(3x3)ABC(3x3)ABCY"]
]

println(typeof(tests))
println(string(tests[1,1], " => ", tests[1,2]))
for i = 1:size(tests,1)
  println(string(tests[i,1], " => ", tests[i,2]))

  inp = tests[i,1]
  expct = tests[i,2]
  res = process(inp)
  assertmsg(res == expct, "result $res of input $inp should be $expct")
end

open("day09_data.txt") do f
  global data = readstring(f)
  #println("data-file=>$data<")
end
data = strip(data)
println("INPUT data-str=>$data<")
res = process(data)
println("RESULT=>$res<")
println(string("RESult length = ", length(res)))

