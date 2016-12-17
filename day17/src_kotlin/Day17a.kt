import java.security.*  // MessageDigest
import java.math.*  // BigInteger

/**
 * AoC2016 Day14a main class.
 * Run with:
 *
 * ```
 * run.sh
 * ```
 *
 * Document with:
 * `java -jar dokka-fatjar.jar day17a.kt -format html -module "aoc16 day17a" -nodeprecated`
 */
class Day17a {
  val LOGLEVEL = 3
  val maxround = 256 //256

  companion object {
    fun create(): Day17a = Day17a()

    /**
     * PSVM main entry point.
     */
    @JvmStatic fun main(args: Array<String>) {
      println("Starting")
      val salt: String
      if (args.size > 0) {
        salt = args[0]
      } else {
        salt = "hijkl"
      }
      println("salt is >$salt<")
      val o = create()
      o.process(salt)
    }
  }

  //**** Helpers

  fun assertmsg(cond: Boolean, msg: String) {
    if (!cond) {
      throw RuntimeException("assert-ERROR: $msg")
    }
    println("assert-OK: $msg")
  }

  fun tracelog(msg: String) {
    if (LOGLEVEL > 1) {
      println("T: $msg")
    }
  }
  fun deblog(msg: String) {
    if (LOGLEVEL > 0) {
      println("D: $msg")
    }
  }
  fun infolog(msg: String){
    println("I: $msg")
  }

  //**** RECURRING

  /**
   * Calculate an md5sum for a string, return MD5-hex-string (32 chars).
   * See: [Java calculate MD5 hash](<http://stackoverflow.com/questions/7776116/java-calculate-md5-hash>)
   */
  fun md5sumhex(s: String): String {
    val md = MessageDigest.getInstance("MD5")
    val data = s.toByteArray()  //java: s.getBytes();
    md.update(data, 0, data.size)
    return "%1$032x".format(BigInteger(1, md.digest())) // < kotlin stdlib
  }

  //**** problem domain

  fun process(salt: String): Boolean {
    println("salt=$salt")

    var round = 0
    var stack: MutableList<List<Any>>
    var nextstack = mutableListOf(listOf(0,0,""))
    var stackCounts = mutableListOf(0); stackCounts.clear()
    stackCounts.add(nextstack.size)
    while (round < maxround) {
      round += 1
      stack = copyLol(nextstack)
      nextstack.clear()
      //infolog("start-round#$round; stack=$stack; next-stack:$nextstack")
      infolog("start-Round#$round; stackCounts=$stackCounts")
      stack.forEach { world ->
        val x: Int = world[0] as Int
        val y: Int = world[1] as Int
        val path: String = world[2] as String
        //deblog("checking at($x,$y), path >$salt$path<; round=$round")
        val cksum = md5sumhex(salt+path)
        //tracelog("  cksum=$cksum")
        if ("bcdef".contains(cksum[0]) && y > 0) {
          nextstack.add(listOf(x, y-1, path+"U"))
        }
        if ("bcdef".contains(cksum[1]) && y < 3) {
          nextstack.add(listOf(x, y+1, path+"D"))
          if (x==3 && y+1==3) {
            throw RuntimeException("SOLVED! at round#$round, path=${path+"D"}.")
          }
        }
        if ("bcdef".contains(cksum[2]) && x > 0) {
          nextstack.add(listOf(x-1, y, path+"L"))
        }
        if ("bcdef".contains(cksum[3]) && x < 3) {
          nextstack.add(listOf(x+1, y, path+"R"))
          if (x+1==3 && y==3) {
            throw RuntimeException("SOLVED! at round#$round, path=${path+"R"}.")
          }
        }
      }
      //deblog("  round#$round; nextstack=$nextstack")
      //tracelog(    "oldstack=$stack")
      stackCounts.add(nextstack.size)
      //deblog("round#$round; stackCounts=$stackCounts")
      infolog("  end-Round#$round; next-stack-count=${nextstack.size}")
      if (nextstack.size == 0) {
        throw RuntimeException("ABORT unsolvable! at round#$round, next-stack-empty.")
      }
    }
    return false
  }

  private fun copyLol(stack: MutableList<List<Any>>): MutableList<List<Any>> {
    val newstack = mutableListOf(listOf(0,0,"")); newstack.clear()
    stack.forEach {
      newstack.add(it.toList())
    }
    return newstack
  }
}
