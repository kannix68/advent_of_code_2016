import java.security.*  // MessageDigest
import java.math.*  // BigInteger
import kotlin.system.exitProcess

/**
 * AoC2016 Day14a main class.
 * Run with:
 *
 * ```
 * kotlinc -verbose -include-runtime -d day14a.jar *.kt
 * java -jar day14a.jar
 * ```
 *
 * Document with:
 * `java -jar dokka-fatjar.jar day13a.kt -format html -module "aoc16 day14a" -nodeprecated`
 */
class Day14b {
  val maxiter = 64000
  val numkeystofind = 64

  companion object {
    fun create(): Day14b = Day14b()

    /**
     * PSVM main entry point.
     */
    @JvmStatic fun main(args: Array<String>) {
      println("Starting")
      val salt: String
      if (args.size > 0) {
        salt = args[0]
      } else {
        salt = "abc"
      }
      val o = create()
      //val outputstr = o.md5sumhex(input)
      //println("md5sum($input) => $outputstr")
      o.process(salt)
    }

  }

  /**
   * Calculate an md5sum for a string, return MD5-hex-string (32 chars).
   * See: [Java calculate MD5 hash](<http://stackoverflow.com/questions/7776116/java-calculate-md5-hash>)
   */
  fun md5sumhex(s: String): String {
    val md = MessageDigest.getInstance("MD5")
    val data = s.toByteArray()  //java: s.getBytes();
    md.update(data, 0, data.size)
    //println("  message-len=${data.size}")
    //val i = BigInteger(1, md.digest())
    //println("  bigint=$i")
    //return(java.lang.String.format("%1$032x", i))
    return "%1$032x".format(BigInteger(1, md.digest())) // < kotlin stdlib
    //return(java.lang.String.format("%1$032x", BigInteger(1, md.digest()))) < java standard runtime
  }

  fun process(salt: String): Boolean {
    println("salt=$salt")
    val rxkey = Regex("""([0-9a-f])\1\1""")
    var stack = mutableListOf(listOf(1, "a"))
    stack.clear()
    var ok = false
    var numkeysfound = 0
    var loop = -1
    val hashesMap = hashMapOf(Pair(0, "none"))

    while (!ok && loop < maxiter) {
      loop += 1
      var output: String

      if (hashesMap.containsKey(loop)) {
        output = hashesMap[loop] as String
      } else {
        val input = "$salt$loop"
        output = input
        (1..2017).forEach {
          output = md5sumhex(output)
        }
        println("input=$input; output=$output")
        hashesMap[loop] = output
      }
      val mrkey = rxkey.find(output)
      if (mrkey != null) {
        val foundseq = mrkey.value //groupValues[0]
        //println("found-seq=$foundseq for md5sum=$output of inp=$input")
        val searchfor = foundseq.substring(0,1).repeat(5)
        (loop+1..loop+1001).forEach { idx ->
          var verout: String
          if (hashesMap.containsKey(idx)) {
            verout = hashesMap[idx] as String
          } else {
            val verinp = "$salt$idx"
            verout = verinp
            (1..2017).forEach {
              verout = md5sumhex(verout)
            }
            hashesMap[idx] = verout
          }
          if (verout.contains(searchfor)) {
            numkeysfound +=1
            println("found key #$numkeysfound: at idx=$loop, verified @loop=$idx to $searchfor")
            if (numkeysfound >= numkeystofind) {
              println("success at loop $loop")
              return true
            }
          }
        }
      }
    }
    return false
  }
}