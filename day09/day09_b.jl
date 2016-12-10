#!/usr/bin/env julia
##
# julia --compile=all day09_b.jl

doteach = 20000 #1000 #250000
start_tm = round(time())

function assertmsg(assertion, msg)
  if !assertion
    println("assert-ERROR: $msg")
    exit(1)
  else
    println("assert-OK: $msg")
  end
end

# format thousands
#  see <
function fts(i)
  #return reverse(join('_', unpack("(A3)*", reverse(shift()))));
  string(">", i, "<")
end


## expects string, returns decoded string
function process(inp)
  rest = inp
  outpBuf = IOBuffer() 
  loop = 0
  #println("  input=$inp")
  regex = r"^(.*?)\((\d+)x(\d+)\)(.*)$"
  last_llen = 0; last_rlen = 0
  start_tm = round(time())
  last_tm = start_tm
  m = match(regex, rest)
  while m != nothing
    #println("regex matched for input $inp, loop=$loop")
    pre, len, rept, remain = m.captures
    #println(string("mod=", mod(loop, doteach)))
    if mod(loop, doteach) == 0
      llen = -1; rlen = length(rest)
      tm = round(time())
      println(string(
        ". left-len=$(fts(llen)); right-len=$(fts(rlen))",
        "; dlt-left=$(fts(llen-last_llen)); dlt-right=$(fts(rlen-last_rlen))",
        "; time=$(tm-last_tm)",
        "; sumTM=$(fts(tm-start_tm))",
        "; loops=$(fts(loop))"
      ))
      last_llen = llen; last_rlen = rlen; last_tm = tm
    end
    loop += 1
    leni = parse(Int64, len)
    repti = parse(Int64, rept)
    #println("  found pre=$pre, cmd(len=$len, repeat=$rept), remain=$remain")
      #outp = string(outp, pre)
    print(outpBuf, pre)
    #println("  outp=$outp; prepended")
    #println("  torepeat=$torepeat; insrt=$insrt")
    #outp = string(outp, insrt)
    #println("  outp=$outp; inserted")
    rest = string(repeat(remain[1:leni], repti), remain[leni+1:end])
    #println("  new rest=$rest")
    m = match(regex, rest)
  end
    #outp = string(outp, rest)
  print(outpBuf, rest)
  takebuf_string(outpBuf) 
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
  ["(3x3)XYZ" "XYZXYZXYZ"];
  ["X(8x2)(3x3)ABCY" "XABCABCABCABCABCABCY"];
  ["(27x12)(20x12)(13x14)(7x10)(1x12)A"  repeat("A", 241920)]
]

println(typeof(tests))
println(string(tests[1,1], " => ", tests[1,2]))
for i = 1:size(tests,1)
  println(string(tests[i,1], " => ", tests[i,2]))

  inp = tests[i,1]
  expct = tests[i,2]
  res = process(inp)
  assertmsg(res == expct, "result $res of input $inp should be $expct")
  println(string("TestRESult-length=", length(res)))
end

start_tm = round(time())
println("started $start_tm")

open("day09_data.txt") do f
  global data = readstring(f)
  #println("data-file=>$data<")
end
data = strip(data)
#println("INPUT data-str=>$data<")
println(string("INPUT data-str=>", data[1:16], "...<"))
res = process(data)
println(string("RESult=>", res[1:16], "...<"))
println(string("RESult length = ", length(res)))

