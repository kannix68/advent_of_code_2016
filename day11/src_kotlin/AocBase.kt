/**
 * Base class for AdventOfCode 2016 solutions, contains helper functionse etc.
 */
open class AocBase {
  var LOGLEVEL = 3

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

  /**
   * Copy a MutableList<MutableSet<String>> to another instance.
   * @return the new mutableList-of-MutableSet
   */
  fun copyMListOfMSet(world: MutableList<MutableSet<String>>): MutableList<MutableSet<String>> {
    //val newWorld = world.toList()  // COPY
    val newWorld = mutableListOf(mutableSetOf("")); newWorld.clear()
    world.forEach { fset ->
      val st = mutableSetOf(""); st.clear()
      fset.forEach { item ->
        //tracelog("copy-item: $item")
        st.add(item)
      }
      newWorld.add(st)
    }
    return newWorld
  }

  /** Print trace-levl message. */
  fun tracelog(msg: String) {
    if (LOGLEVEL > 1) {
      println("T: $msg")
    }
  }

  /** Print debug-levl message. */
  fun deblog(msg: String) {
    if (LOGLEVEL > 0) {
      println("D: $msg")
    }
  }

  /** Print info message, unconditionally. */
  fun infolog(msg: String){
    println("I: $msg")
  }

  fun copyMListOfMListOfMSet(stack: MutableList<MutableList<MutableSet<String>>>): MutableList<MutableList<MutableSet<String>>> {
    val newStack = mutableListOf(mutableListOf(mutableSetOf(""))); newStack.clear()
    stack.forEach { newStack.add(copyMListOfMSet(it)) }
    return newStack
  }
}
