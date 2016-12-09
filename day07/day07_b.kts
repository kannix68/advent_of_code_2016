/**
 * Advent of code 2016, AoC day 7 puzzle 1.
 * This solution (kotlin 1.0.4) by kannix68, @ 2016-12-07.
 * Run as:
 * `kotlinc -verbose -script day07_a.kts`
 */

/* inline */ fun assertMsg(condit: Boolean, msg: String) {
  if (!condit) {
    throw AssertionError("assert-ERROR: $msg")
  } else {
    println("assert-OK: $msg")
  }
}

/**
 * check for a vaild input "IP-v7 address" as defined by aoc2016 day7 p1.
 */
fun checkIp(str: String): Boolean {
  val charsetRx = """^[a-z\[\]]+$""".toRegex()
  val charsOk = charsetRx.matches(str)  // RX1: test on entire string, return bool
  if (!charsOk) { // found invalid characters
    System.err.println("  charsOk=$charsOk on $str")
    return false
  }
  
  val sslBabRx = """(?:^|\])[a-z]*?([a-z])([a-z])(\1).*?\[[a-z]*?\2\1\2[a-z]*?\]""".toRegex()
  val babSslRx = """\[[a-z]*?([a-z])([a-z])(\1)[a-z]*?\].*?\2\1\2[a-z]*?(?:\[|$)""".toRegex()
  
  var matchRes = sslBabRx.find(str) // capture MatchResult
  val matchRes2 = babSslRx.find(str) // capture MatchResult
  //System.err.println("    matchResult?.value?=" + matchRes?.value)
  var foundFirst = true
  if (matchRes?.value == null && matchRes2?.value == null) {  // Test3_1: match found?
    System.err.println("  sslOk=false on $str")
    return false
  } else if (matchRes?.value != null) {
    foundFirst = true
    matchRes = matchRes
  } else if (matchRes2?.value != null) {
    foundFirst = false
    matchRes = matchRes2
  }
  val mr = matchRes!!
  //System.err.println("    val1, val2 = " + mr.groupValues[1] + ", " + mr.groupValues[2])
  if ( mr.groupValues[1] == mr.groupValues[2] ) {  // Test3_2: not 2/3 same chars?
    //System.err.println("  foundGrp=${mr.value} on ssl in $str")
    System.err.println("  foundThreeSame=${mr.groupValues[2]} on $str")
    return false
  }
  var m1: String
  var m2: String
  if ( foundFirst ) {
    m1 = mr.groupValues[1]
    m2 = mr.groupValues[2]
  } else {
    m2 = mr.groupValues[1]
    m1 = mr.groupValues[2]
  }
  val rep1 = m1+m2+m1
  val rep2 = m2+m1+m2
  var str2 = str.replace(rep1, ">"+rep1+"<").replace(rep2, "/"+rep2+"/") + " $foundFirst"
  println( "found=$m1$m2$m1 out + $m2$m1$m2 in ON valid $str2" )
  return true
}

//** MAIN
println("starting day07_a kt")

//* testing
val testInvalidChar = "aba[bab]xYz" // invalid, extra
val testStr1 = "aba[bab]xyz" // valid
val testStr2 = "xyx[xyx]xyx" // invalid
val testStr3 = "aaa[kek]eke" // valid
val testStr4 = "zazbz[bzb]cdb" // valid, watch overlappinx xyxzx in outer text!
// extra pattern tests:
val testStr7 = "xbbby[abbbc]fghj" // invalid, three-same "edge case"
val testStr8 = "cdb[abzbc]zazbz" // valid, ssl at end, zbz
val testStr9 = "abxyxab[ayxx]abxyxab" // invalid, "edge case"

/*
var res = checkIp(testInvalidChar)
assertMsg(res == false, "invalid IP $testInvalidChar should check to false")

res = checkIp(testStr1)
assertMsg(res == true, "valid IP $testStr1 should check to true")
res = checkIp(testStr2)
assertMsg(res == false, "invalid IP $testStr2 should check to false")
res = checkIp(testStr3)
assertMsg(res == true, "valid IP $testStr3 should check to true")
res = checkIp(testStr4)
assertMsg(res == true, "valid IP $testStr4 should check to true")
res = checkIp(testStr7)
assertMsg(res == false, "invalid IP $testStr7 should check to false")
res = checkIp(testStr8)
assertMsg(res == true, "valid IP $testStr8 should check to true")
res = checkIp(testStr9)
assertMsg(res == false, "invalid IP $testStr9 should check to false")
*/

//System.exit(0)

//* problem domain:
var okCount = 0
var linesCount = 0
java.io.File("day07_data.txt").forEachLine() { line ->
  linesCount += 1
  if (checkIp(line)) { // line endings are chopped already
    println( "  IP $line is valid")
    okCount += 1
  } else {
    println( "    IP $line is INvalid")
  }
}
println("data result: OK-counter=$okCount, of $linesCount lines")
//System.exit(0)
