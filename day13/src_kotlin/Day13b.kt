/**
 * AoC2016 Day13a main class.
 * Day 13: A Maze of Twisty Little Cubicles.
 *
 * Run with:
 *
 * ```
 * kotlinc -verbose -include-runtime -d day13a.jar Day13b.kt
 * java -jar day13b.jar
 * ```
 *
 * Document with:
 * `java -jar dokka-fatjar.jar Day13a.kt -format html -module "aoc16 day13a" -nodeprecated`
 */
class Day13b {
  companion object {
    @JvmStatic fun main(args: Array<String>) {
      println("Starting")
      val testnode = Node("1,2")
      println("test-node=$testnode")

      val testworld = World.create(1, 2, 0)
      println("test-world=$testworld of seed 0")
      val testworld2 = World.create(1, 2, 7)
      println("test-world2=$testworld2 of seed 7")
      testworld.printgrid()
      val grid = testworld.grid
      grid[1][0] = 1
      // ^ y  x  ^
      println("grid=$grid")
      testworld.printgrid()
      val t = 5
      val bs = Integer.toBinaryString(t)
      val cts = bs.split("").filter { it == "1" }.joinToString("")
      val ct = cts.length
      println("$t => $bs; cts=$cts length=$ct")

      // #######################################
      //val salt = 10
      //val gridwidth = 10
      //val gridheight = 7
      //val maxrounds = 14
      //val startstr = "1,1"
      //val targetstr = "7,4"
      val salt = 1352
      val gridwidth = 55
      val gridheight = 55
      val maxrounds = 50
      val startstr = "1,1"
      val targetstr = "31,39"

      val world = World.create(gridwidth, gridheight, salt)
      world.printgrid()

      //**** build node graph
      val g = GraphUndirUnwtd()
      //g.addNode(intArrayOf(0,0))
      for (y in 0..world.dimy-1) {
        for (x in 0..world.dimx-1) {
          if (world.grid[y][x] == 1) {
            //println("add node($x,$y)")
            g.addNode("$x,$y")
          }
        }
      }
      println("nodes #:${g.nodes.size}")
      for (y in 0..world.dimy-1) {
        for (x in 0..world.dimx-1) {
          if (world.grid[y][x] == 1) {
            // check edges
            var yy = y-1
            if (yy >= 0 && g.containsNode("$x,$yy")) {
              //println("add edge($x,$y<=>$x,$yy)")
              g.addEdge("$x,$y", "$x,$yy")
            }
            yy = y+1
            if (yy < world.dimy && g.containsNode("$x,$yy")) {
              //println("add edge($x,$y<=>$x,$yy)")
              g.addEdge("$x,$y", "$x,$yy")
            }
            var xx = x-1
            if (xx >= 0 && g.containsNode("$xx,$y")) {
              //println("add edge($x,$y<=>$xx,$y)")
              g.addEdge("$x,$y", "$xx,$y")
            }
            xx = x+1
            if (xx < world.dimx && g.containsNode("$xx,$y")) {
              //println("add edge($x,$y<=>$xx,$y)")
              g.addEdge("$x,$y", "$xx,$y")
            }
          }
        }
        println("edges #:${g.edges.size}")
      }
      // adjacents: 7,1
      var paths = g.edges.filter{ it.nid1 == "7,1" }
      paths.forEach {
        println("found1 adj-edge: $it")
      }
      paths = g.edges.filter{ it.nid1 == "6,1" }
      paths.forEach {
        println("found2 adj-edge: $it")
      }

      val node1 = Node("1,2")
      val node2 = Node("1,2")
      println("node1=$node1, node2=$node2")
      //assert(node1 == node2, {"nodes with same id compare"})
      assertmsg(node1.ident(node2), "nodes with same id compare")

      // #######################################
      // **** 1,1 => 7,4

      val startNode = Node(startstr)
      val endNode = Node(targetstr)

      val startnid = startNode.nid
      val endnid = endNode.nid
      val firstnid = startnid
      val firstPath = listOf(firstnid)
      var round = 0
      val curPaths =  mutableListOf(listOf<String>())
      curPaths.clear()
      curPaths.add(firstPath)
      assertmsg(firstPath.size == 1, "one in List firstpath")
      assertmsg(curPaths.size == 1, "one in List curpaths ${curPaths.size}")
      val nextPaths = mutableListOf(listOf<String>())
      nextPaths.clear()
      val seenNodes = mutableSetOf<String>()
      seenNodes.add(startnid)
      while (round < maxrounds) {
        round += 1
        println("ROUND #$round")
        nextPaths.forEach { curPaths.add(it) } // some datastruct shifting
        nextPaths.clear() // clear next paths
        curPaths.forEach { curPath ->
          val curnid = curPath.last()
          val nextNodes = g.edges.filter{ it.nid1 == curnid }.map{ it.nid2 }
          nextNodes.forEach { str ->
            if (str == endnid) {
              if (!seenNodes.contains(str)) {
                seenNodes.add(str)
              }
              println("FOUND shortest path! ${curPath} $str")
              throw RuntimeException("found at ROUND #$round; path-len=${curPath.size}")
            } else if (!curPath.contains(str)) {
              val nw = mutableListOf<String>()
              curPath.forEach { nw.add(it) }
              nw.add(str)
              println("adding next path $nw")
              nextPaths.add(nw)
              if (!seenNodes.contains(str)) {
                seenNodes.add(str)
              }
            } else {
              println("rejected self-ref path ${curPath} $str")
            }
          }
        }
        curPaths.clear()
      }
      println("ABORT after round #$round; seen-nodes-#=${seenNodes.size}")
    }

    private fun assertmsg(cond: Boolean, msg: String) {
      if (!cond) {
        throw RuntimeException("assert-ERROR: $msg")
      }
      println("assert-OK: msg")
    }
  }
}
