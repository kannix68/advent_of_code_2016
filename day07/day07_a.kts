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
  val abbaBrkRx = """\[[a-z]*?(([a-z])([a-z])\3\2)[a-z]*?\]""".toRegex()
  val abbaBrkFound = abbaBrkRx.containsMatchIn(str)  // RX2: test on part of string, return bool
  if (abbaBrkFound) { // abba not allowed in square brackets
    System.err.println("  abbaBrkFound=$abbaBrkFound on $str")
    return false
  }
  val abbaRx = """(([a-z])([a-z])\3\2)""".toRegex()  // RX3: test if part found, store results
  val matchRes = abbaRx.find(str) // capture MatchResult
  if (matchRes?.value?.length != 4) {  // Test3_1: match found?
    System.err.println("  abbaOk=false on $str")
    return false
  }
  if ( matchRes!!.groupValues[2] == matchRes.groupValues[3] ) {  // Test3_2: not 4 same chars?
    System.err.println("  foundGrp=${matchRes.value} on abba in $str")
    System.err.println("  foundFourSame=${matchRes.groupValues[2]} on $str")
    return false
  }
  return true
}

//** MAIN
println("starting day07_a kt")

//* testing
val testInvalidChar = "abba[mnop]qAst" // invalid
val testStr1 = "abba[mnop]qrst" // valid
val testStr2 = "abcd[bddb]xyyx" // invalid
val testStr3 = "aaaa[qwer]tyui" // invalid
val testStr4 = "ioxxoj[asdfgh]zxcvbn" // valid
// extra pattern tests:
val testStr8 = "abcd[mnop]xabbay" // valid, abba at end
val testStr9 = "abba[xabbay]abba" // invalid, "edge case"

var res = checkIp(testInvalidChar)
assertMsg(res == false, "invalid IP $testInvalidChar should check to false")

res = checkIp(testStr1)
assertMsg(res == true, "valid IP $testStr1 should check to true")
res = checkIp(testStr2)
assertMsg(res == false, "invalid IP $testStr2 should check to false")
res = checkIp(testStr3)
assertMsg(res == false, "invalid IP $testStr3 should check to false")
res = checkIp(testStr4)
assertMsg(res == true, "valid IP $testStr4 should check to true")
res = checkIp(testStr8)
assertMsg(res == true, "valid IP $testStr8 should check to true")
res = checkIp(testStr9)
assertMsg(res == false, "invalid IP $testStr9 should check to false")

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
