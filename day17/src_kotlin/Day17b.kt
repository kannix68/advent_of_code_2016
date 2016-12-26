import java.security.*  // MessageDigest
import java.math.*  // BigInteger

/**
 * AoC2016 Day16b main class.
 * Run with: `runb.sh`.
 */
class Day17b {
  val LOGLEVEL = 3
  val maxround = 1024 //256

  companion object {
    fun create(): Day17b = Day17b()

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

  /**
   * Copy a MutableList<List<Any>> to another instance.
   * @return the new mutableList-of-List
   */
  fun copyLol(stack: MutableList<List<Any>>): MutableList<List<Any>> {
    val newstack = mutableListOf(listOf(0,0,"")); newstack.clear()
    stack.forEach {
      newstack.add(it.toList())
    }
    return newstack
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
    return "%1$032x".format(BigInteger(1, md.digest())) // < kotlin stdlib string format
  }

  //**** problem domain

  fun process(salt: String): Boolean {
    println("salt=$salt")

    var round = 0
    var stack: MutableList<List<Any>>
    val nextstack = mutableListOf(listOf(0,0,""))
    val stackCounts = mutableListOf(0); stackCounts.clear()
    var foundNum = 0
    stackCounts.add(nextstack.size)
    while (round < maxround) {
      round += 1
      stack = copyLol(nextstack)
      nextstack.clear()
      //infolog("start-round#$round; stack=$stack; next-stack:$nextstack")
      //infolog("start-Round#$round; stackCounts=$stackCounts")
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
          if (x==3 && y+1==3) {
            //throw RuntimeException("SOLVED! at round#$round, path=${path+"D"}.")
            foundNum += 1
            val newpath = path+"D"
            infolog("FOUND#$foundNum path-len=${path.length+1} !, @round=$round, path=${ppath(newpath)}.")
          } else {
            nextstack.add(listOf(x, y+1, path+"D")) // only add to next moves of not end-found
          }
        }
        if ("bcdef".contains(cksum[2]) && x > 0) {
          nextstack.add(listOf(x-1, y, path+"L"))
        }
        if ("bcdef".contains(cksum[3]) && x < 3) {
          if (x+1==3 && y==3) {
            //throw RuntimeException("SOLVED! at round#$round, path=${path+"R"}.")
            foundNum += 1
            val newpath = path+"R"
            infolog("FOUND#$foundNum path-len=${newpath.length} !, @round=$round, path=${ppath(newpath)}.")
          } else {
            nextstack.add(listOf(x+1, y, path+"R")) // only add to next moves of not end-found
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

  private fun  ppath(path: String): String {
    val ds = path.split("").filter{it == "D"}.joinToString("").length
    val us = path.split("").filter { it == "U" }.joinToString("").length
    val ls = path.split("").filter { it == "L" }.joinToString("").length
    val rs = path.split("").filter { it == "R" }.joinToString("").length
    val ckx = 1 + rs - ls
    val cky = 1 + ds - us
    //tracelog("ds=$ds, us=$us; ls=$ls, rs=$rs; ckx=$ckx; cky=$cky")
    assertmsg(ckx == 4 && cky == 4, "checksums ckx=$ckx and cky=$cky should each be == 4")
    if (path.length > 42) {
      return path.substring(0..20) + ".." + path.substring(path.length-20) + "; ckx=$ckx, cky=$cky"
    } else {
      return path + "; ckx=$ckx, cky=$cky"
    }
  }

}
