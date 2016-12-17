import java.security.*  // MessageDigest
import java.math.*  // BigInteger
import AocBase

/**
 * AoC2016 Day11b main class.
 * Run with:
 *
 * ```
 * run.sh
 * ```
 *
 * Document with:
 * `java -jar dokka-fatjar.jar day13a.kt -format html -module "aoc16 day11a" -nodeprecated`
 */
class Day11b : AocBase() {
  val maxround = 256
  val elems = sortedSetOf("")
  val seen = mutableSetOf("")
  init {
    seen.clear()
    elems.clear()
    LOGLEVEL = 0
  }

  val TESTSTR = """
  The first floor contains a elerium generator, a elerium-compatible microchip, a dilithium generator, a dilithium-compatible microchip, a strontium generator, a strontium-compatible microchip, a plutonium generator, and a plutonium-compatible microchip.
  The second floor contains a thulium generator, a ruthenium generator, a ruthenium-compatible microchip, a curium generator, and a curium-compatible microchip.
  The third floor contains a thulium-compatible microchip.
  The fourth floor contains nothing relevant.
  """.trimIndent()
  /*
  val TESTSTR = """
  The first floor contains a hydrogen-compatible microchip.
  The second floor contains nothing relevant.
  The third floor contains a hydrogen generator.
  The fourth floor contains a lithium-compatible microchip and a lithium generator.
  """.trimIndent()
  //!! given Test:
  val TESTSTR = """
  The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
  The second floor contains a hydrogen generator.
  The third floor contains a lithium generator.
  The fourth floor contains nothing relevant.
  """.trimIndent()
  //!! PART 1:
  val TESTSTR = """
  The first floor contains a strontium generator, a strontium-compatible microchip, a plutonium generator, and a plutonium-compatible microchip.
  The second floor contains a thulium generator, a ruthenium generator, a ruthenium-compatible microchip, a curium generator, and a curium-compatible microchip.
  The third floor contains a thulium-compatible microchip.
  The fourth floor contains nothing relevant.
  """.trimIndent()
  //!! PART 2:
  val TESTSTR = """
  The first floor contains a elerium generator, a elerium-compatible microchip, a dilithium generator, a dilithium-compatible microchip, a strontium generator, a strontium-compatible microchip, a plutonium generator, and a plutonium-compatible microchip.
  The second floor contains a thulium generator, a ruthenium generator, a ruthenium-compatible microchip, a curium generator, and a curium-compatible microchip.
  The third floor contains a thulium-compatible microchip.
  The fourth floor contains nothing relevant.
  """.trimIndent()
  */

  companion object {
    /**
     * Factory create function.
     */
    fun create(): Day11b = Day11b()

    /**
     * PSVM main entry point.
     */
    @JvmStatic fun main(args: Array<String>) {
      println("Starting")
      val o = create()
      o.process()
    }
  }

  //**** problem domain

  /**
   * Get Elevator floor number stored in world.
   */
  private fun elevatorAt(world: MutableList<MutableSet<String>>): Int {
    return world[4].toList().get(0).toInt()
  }

  /**
   * Return list of directions, 1; -1 oder 1, -1.
   */
  private fun elevatorDirsOk(oldFloorNum: Int): List<Int> {
    if (oldFloorNum == 1) {
      return listOf<Int>(1)
    } else if (oldFloorNum == 4) {
      return listOf<Int>(-1)
    } else {
      return listOf<Int>(1, -1)
    }
  }

  /**
   * Returns Combinations (like Permutations, but order does not count)
   * of 2 and 1 items of the given set.
   */
  private fun get2Permuts(fset: MutableSet<String>): MutableList<List<String>> {
    val ret = mutableListOf(listOf("")); ret.clear()
    val aset = fset.sorted()
    if (aset.size > 2) {
      for (idx in 0..aset.size-1) { // permutate-2
        for (nxidx in idx+1..aset.size-1) { // permutate-2
          //println("permut=($idx,$nxidx)")
          ret.add(listOf(aset[idx], aset[nxidx]))
        }
      }
      for (idx in 0..aset.size-1) { // permutate-1
        ret.add(listOf(aset[idx]))
      }
    } else if (aset.size == 2) {
      ret.add(listOf(aset[0], aset[1]))
      ret.add(listOf(aset[0]))
      ret.add(listOf(aset[1]))
    } else if (fset.size == 1) {
      ret.add(listOf(aset[0]))
    } else {
      // nothing to add
    }
    tracelog("getPermuts($aset) => $ret")
    return ret
  }

  private fun getElevatorPermuts(world: MutableList<MutableSet<String>>): MutableList<List<String>> {
    val currentFloor = elevatorAt(world)
    //elevatorDirsOk(currentFloor).forEach { edir ->
    //  tracelog("possible direction $edir; currently at $currentFloor")
    //}
    val fset = world[currentFloor-1]
    //deblog("fset.size=${fset.size} fset=$fset")
    return get2Permuts(fset)
  }

  private fun checkPayloadFloor(perm: List<String>, targetFloor: Int, world: MutableList<MutableSet<String>>): Boolean {
    val targetfset = world[targetFloor - 1]
    val micros = perm.filter { it.endsWith("M") }
    if (micros.size > 0) {
      val generators = targetfset.union(perm).filter { it.endsWith("G") }
      micros.forEach { micro ->
        val micGen = micro[0] + "G"
        if (generators.size > 0 && !generators.contains(micGen)) {
          tracelog("$micro fried on payload=$perm to floor#$targetFloor :: $targetfset. no $micGen")
          return false
        }
      }
    }
    return true
  }

  /**
   * Generate world from a multiline string.
   */
  private fun generateWorld(mlstr: String): MutableList<MutableSet<String>> {
    // "The second floor contains a hydrogen generator."
    val rx1 = Regex("""^The (.*) floor contains (.*)\.$""")
    val rx2 = Regex("""a ([a-z].*?).(?:compatible )?(microchip|generator)""")

    val world = mutableListOf(mutableSetOf("")); world.clear()

    mlstr.split("\n").forEach { line ->
      val mset = mutableSetOf(""); mset.clear()
      //tracelog("line=$line")
      val mr1 = rx1.find(line)
      if (mr1 == null) {
        throw RuntimeException("unparseable line:: $line")
      }
      val (floorstr, rest) = mr1.destructured
      //tracelog("floorstr=$floorstr, rest=$rest")
      if (!rest.startsWith("nothing")) {
        rx2.findAll(rest).forEach { mr2 ->
          val (elem, device) = mr2.destructured
          elems.add(elem[0].toString().toUpperCase())
          val marker: String = "${elem[0]}${device[0]}".toUpperCase()
          //infolog("add marker $marker")
          mset.add(marker)
        }
      }
      world.add(mset)
    }
    world.add(mutableSetOf(1.toString()))
    infolog("world=${signat(world)}")
    //infolog("floor#1=${world[0]}")
    assertmsg(elevatorAt(world) == 1, "elevator at creation is at floor #1")
    infolog("elements=$elems")
    return world
  }

  private fun printWorld(world: MutableList<MutableSet<String>>, title: String = "") {
    val allset = mutableSetOf(""); allset.clear()
    val cols = mutableListOf(""); cols.clear()

    world.forEachIndexed { idx, floor ->
      if (idx < 4) {
        floor.forEach { allset.add(it) }
      }
    }
    val items = allset.sorted()

    var s = "Wl>|" //">Wrld |"
    s += "El|"
    items.forEach {
      s += it + "|"
      cols.add(it)
    }
    if (title != "") {
      s += " :: >$title<"
    }
    s += " :: world-id=" + Integer.toHexString(world.hashCode())
    s += "\n"
    for (f in 4 downTo 1) {
      s += " F#$f: ;"
      if (f == elevatorAt(world)) {
        s += "El;"
      } else {
        s += "__;"
      }
      val fset = world[f-1]
      items.forEach {
        if (fset.contains(it)) {
          s += "$it;"
        } else {
          s +="..;"
        }
      }
      if (f==1) {
        s += "  :: signat=${signat(world)}"
      }
      s += "\n"
    }
    infolog("$s") // "\n$s"
  }

  /**
   * Process problem domain.
   */
  fun process(): Boolean {
    infolog(":process() started.")
    //infolog("TESTSTR =>>$TESTSTR<<.")
    assertmsg(TESTSTR.length > 0, "found TESTSTR")

    val mlstr = TESTSTR
    val world = generateWorld(mlstr)
    seen.add(signat(world))
    printWorld(world, "initial-world")

    var round = 0
    var stack: MutableList<MutableList<MutableSet<String>>>
    var nextstack = mutableListOf(world)
    var stackCounts = mutableListOf(0); stackCounts.clear()
    var lastWorlds = 1
    var lastMoves = 0
    var invalidNum = 0
    var rejectedNum = 0
    stackCounts.add(nextstack.size)
    val starttm = System.currentTimeMillis()
    var lasttm = starttm
    var tooktm: Long

    while (round < maxround) {
      round += 1
      tooktm = System.currentTimeMillis()
      stack = copyMListOfMListOfMSet(nextstack)
      nextstack.clear()
      //infolog("start-round#$round; stack=$stack; next-stack:$nextstack")
      infolog("START-ROUND #$round; stack-count=${stack.size}, seen-count=${seen.size}; invalid-ct=$invalidNum, rejected=$rejectedNum, last-TM=${tooktm-lasttm}, sum-TM=${(tooktm-starttm)/1000.0}")
      lasttm = tooktm
      infolog("stackCounts=" + stackCounts.joinToString(","))
      deblog("  last-world=$lastWorlds, last-moves=$lastMoves")
      lastWorlds = 0; lastMoves = 0
      //if (stack.size == 1) {
      //  printWorld(stack[0], "stacked1")
      //}
      stack.forEach { baseworld ->
        lastWorlds += 1
        val currentFloor = elevatorAt(baseworld)
        val permuts = getElevatorPermuts(baseworld)
        elevatorDirsOk(currentFloor).forEach { edir ->
          tracelog("possible direction $edir; currently at $currentFloor; permuts=$permuts")
          val targetFloor = currentFloor + edir
          permuts.forEach { perm ->
            if (checkPayloadFloor(perm, targetFloor, baseworld)){
              deblog("ok-move to-flr=$targetFloor from-flr=$currentFloor, perm=$perm to=${baseworld[targetFloor-1]}")
              val newworld = compute_world(edir, perm, baseworld)
              val nwsig = signat(newworld)
              if (newworld[0].isEmpty() && newworld[1].isEmpty() && newworld[2].isEmpty()) {
                printWorld(newworld, "solution-world")
                tooktm = System.currentTimeMillis()
                infolog("sum-TM=${(tooktm-starttm)/1000.0}")
                throw RuntimeException("finished-world found! at round $round")
              }
              if (!seen.contains(nwsig)) {
                lastMoves += 1
                seen.add(nwsig)
                //printWorld(newworld, title="newworld :p")
                nextstack.add(newworld)
                //!!!deblog("OK added next-move newworld-sig=$nwsig");
                //printWorld(newworld, "stacked-next-world")
              } else {
                //!!!deblog("rejected seen world $nwsig")
                rejectedNum += 1
              }
            } else {
              //!!!deblog("invalid move to-flr=$targetFloor from-flr=$currentFloor, with=$perm to=${baseworld[targetFloor-1]}")
              invalidNum += 1
            }
          }
        }
      }
      stackCounts.add(nextstack.size)
    }
    return false
  }

  private fun signat(world: MutableList<MutableSet<String>>): String {
    var sign = world[4].elementAt(0).toString() + ":"
    val pairs = mutableListOf(""); pairs.clear();

    elems.forEach { elem ->
      val elemgen = "${elem}G"
      val elemmicro = "${elem}M"
      var genat = 0
      var microat = 0
      world.forEachIndexed { idx, floor ->
        if (idx < 4){
          if (floor.contains(elemgen)) {
            genat = idx + 1
          }
          if (floor.contains(elemmicro)){
            microat = idx + 1
          }
        }
      }
      pairs.add("$genat$microat")
      //tracelog("pairstring for elem $elem == >$genat$microat<")
    }
    sign += pairs.sorted().joinToString(",")
    tracelog("signat(wrld)=$sign from ${world}")
    return sign
  }

  private fun compute_world(edir: Int, perm: List<String>, baseWorld: MutableList<MutableSet<String>>): MutableList<MutableSet<String>> {
    val newWorld = copyMListOfMSet(baseWorld)
    //printWorld(baseWorld, "oldworld :compt1");
    val currentFloor = elevatorAt(newWorld)
    val targetFloor = currentFloor + edir
    tracelog("compute ok: to-flr=$targetFloor from-flr=$currentFloor, perm=$perm to-flr-items=${baseWorld[targetFloor-1]}")
    val elevInfo = newWorld[4]; elevInfo.clear(); elevInfo.add(targetFloor.toString()) // set Elevator floor!
    val basefset = newWorld[currentFloor - 1]
    perm.forEach { basefset.remove(it) }
    val targetfset = newWorld[targetFloor - 1]
    perm.forEach { targetfset.add(it) }
    //printWorld(baseWorld, "oldworld :compt2")
    //printWorld(newWorld, "newworld")
    return newWorld
  }
}
