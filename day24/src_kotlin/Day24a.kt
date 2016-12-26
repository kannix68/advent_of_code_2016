import java.io.File

/**
 * AoC2016 Day24a main class.
 * Day 24: Air Duct Spelunking.
 * The labyrinth/graph works exactly like in AoC16 day 13.
 *
 * Run with: `runb.sh`.
 */
class Day24a : AocBase() {
  companion object {
    val MAXROUNDS_LABYR = 256  // max calc rounds for gettng shortest path between two nodes in labyrinth
    val MAXROUNDS_TRAVEL = 10  // max hops for getting shortest travele for all points
    val MAXSOLUTIONS = 1024
    val DOTEACH = 100000

    val TESTSTR = """
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
  """.trimIndent()

    fun create(): Day24a = Day24a()

    @JvmStatic fun main(args: Array<String>) {
      println("Day starting...")
      val o = create()
      o.process(TESTSTR)
      println("TEST ended, problem-solution starting...")
      //o.process(TESTSTR)
      //File("somefile.txt").readLines().forEach {
      //}
      val datastr = File("day24_data.txt").readText()
      o.process(datastr)
      println("...Day ends.!")
    }
  }

  var starttm = System.currentTimeMillis()
  var lastttm = System.currentTimeMillis()

  private fun process(repr2d: String) {
    tracelog("found:\n$repr2d")
    starttm = System.currentTimeMillis()

    val world = World.create(repr2d)
    world.printgrid()
    val pointedges: List<PointEdge> = getPointEdges(world)
    deblog("edges: ${pointedges}")
    val g = buildWorldGraph(world)
    println("graph: $g")
    lastttm = System.currentTimeMillis()
    infolog("world-building-TM=${lastttm-starttm}")

    pointedges.forEach { ptsedge ->
      deblog("calc shortestPath for pointedge: $ptsedge")
      val ptsdist = getShortestPath(ptsedge.node1, ptsedge.node2, g)
      val tm = System.currentTimeMillis()
      infolog("  getShortestPath TM=${tm-lastttm}")
      lastttm = tm
      ptsedge.dist = ptsdist
    }
    pointedges.forEach { ptsedge ->
      infolog("weighted edge: $ptsedge")
    }
    val startnode = world.pointnodes.filter { it.nodename == "0" }.first()
    infolog("start-node: $startnode")
    val minTravelDist = solveMinDist(pointedges, startnode)
    infolog("travel complete with dist=$minTravelDist")
  }

  private fun solveMinDist(pointedges: List<PointEdge>, startnode: PointNode): Int {
    var bestdist = -1
    var bestpath = Path(PointNode("0,0", "undef"))

    deblog("solveMinDist, num-wt-edges=${pointedges.size}, startpt=$startnode")

    val nodeset = mutableSetOf<String>()
    pointedges.forEach {
      nodeset.add(it.node1.nodename)
      nodeset.add(it.node2.nodename)
    }
    val findsize = nodeset.size
    infolog("find-size=$findsize; from>> $nodeset")

    val alledges = mutableListOf<PointEdge>()
    pointedges.forEach { ptedge ->
      alledges.add(ptedge)
      alledges.add(PointEdge(ptedge.node2, ptedge.node1, ptedge.dist))
    }

    val solutions = mutableSetOf<Path>()

    val firstPath = Path(startnode)
    var round = 0
    val curPaths = mutableListOf<Path>()
    curPaths.clear()
    curPaths.add(firstPath)
    val nextPaths = mutableListOf<Path>()
    nextPaths.clear()
    while (round < MAXROUNDS_TRAVEL) {
      round += 1
      tracelog("ROUND #$round")
      nextPaths.forEach { curPaths.add(it) } // some datastruct shifting
      nextPaths.clear() // clear next paths
      curPaths.forEach { curPath ->
        tracelog("curPath: ${curPath.toExtString()}")
        val curNode = curPath.lastnode
        alledges.filter { it.node1.nodename == curNode.nodename }.forEach { edge ->
          tracelog("possible next node ${edge.node2}, dist=${edge.dist} < edge=$edge")
          val nextPath = curPath.dup() //.copy
          nextPath.addEdge(edge)
          tracelog("  adding next-path=${nextPath.toExtString()}")
          if (nextPath.nodeset.size == findsize) {
            //throw RuntimeException("found solution path, min-dst=${nextPath.totaldist}")
            //infolog("found solution path, min-dst=${nextPath.totaldist}, nodes=${nextPath.nodeset}, edges=${nextPath.edges}")
            tracelog(getPathDiag(nextPath))
            solutions.add(nextPath)
            if (nextPath.totaldist < bestdist || bestdist < 0) {
              bestdist = nextPath.totaldist
              bestpath = nextPath
              deblog("new best path, dist=${nextPath.totaldist} >>" + getPathDiag(nextPath))
            }
            if (solutions.size >= MAXSOLUTIONS) {
              infolog("best path I of #${solutions.size} @ round=$round")
              infolog(getPathDiag(bestpath))
              return bestpath.totaldist
            }
          } else {
            nextPaths.add(nextPath)
          }
        }
      }
      curPaths.clear()
      deblog("end-of-round #$round next-paths-size=${nextPaths.size}")
    }
    if (solutions.size > 0 ) {
      infolog("best path II of #${solutions.size} @ round=$round")
      infolog(getPathDiag(bestpath))
      return bestpath.totaldist
    } else {
      return -1
    }
  }

  private fun getPathDiag(nextPath: Path): String {
    var os = ""
    nextPath.edges.forEach {
      os += it.node1.nodename
      os += "(${it.dist})"
    }
    os += nextPath.lastnode.nodename
    os = "FOUND SolvPath min-dst=${nextPath.totaldist}, nodes=$os"
    return os
  }

  private fun getShortestPath(pn1: PointNode, pn2: PointNode, graph: GraphUndirUnwtd): Int {
    deblog("getShortestPath(${pn1.nodename}, ${pn2.nodename}): ${pn1.nodeid} - ${pn2.nodeid}")

    val startNode = Node(pn1.nodeid)
    val endNode = Node(pn2.nodeid)
    val proctm = System.currentTimeMillis()

    val startNodeid = startNode.nodeid
    val endNodeid = endNode.nodeid
    val firstnid = startNodeid
    val firstPath = listOf(firstnid)
    var round = 0
    val curPaths = mutableListOf(listOf<String>())
    curPaths.clear()
    curPaths.add(firstPath)
    //assertmsg(firstPath.size == 1, "one in List firstpath")
    //assertmsg(curPaths.size == 1, "one in List curpaths ${curPaths.size}")
    val nextPaths = mutableListOf(listOf<String>())
    nextPaths.clear()
    val seenNodes = mutableSetOf<String>()
    seenNodes.add(startNodeid)
    var lastrdtm = System.currentTimeMillis()
    var rejectednum = 0
    var acceptednum = 0
    while (round < MAXROUNDS_LABYR) {
      round += 1
      val rdtm = System.currentTimeMillis()
      var s = ""
      if (acceptednum >= DOTEACH) {
        s += "\n   "
      }
      deblog("${s}ROUND #$round, watch-paths=${nextPaths.size}; reject#=${rejectednum}. dTM=${(rdtm-lastrdtm)/1000.0}")
      acceptednum = 0
      rejectednum=0
      lastrdtm = rdtm
      nextPaths.forEach { curPaths.add(it) } // some datastruct shifting
      nextPaths.clear() // clear next paths
      curPaths.forEach { curPath ->
        val curnid = curPath.last()
        val nextNodes = graph.edges.filter { it.nodeid1 == curnid }.map { it.nodeid2 }
        nextNodes.forEach { str ->
          if (str == endNodeid) {
            if (!seenNodes.contains(str)) {
              seenNodes.add(str)
            }
            deblog("FOUND shortest path ${pn1.nodename}-${pn2.nodename}, len=${curPath.size}! ${curPath} $str. seen-nodes-#=${seenNodes.size}")
            deblog("  proc-TM=${(System.currentTimeMillis() - proctm)/1000.0}")
            //throw RuntimeException("found at ROUND #$round; path-len=${curPath.size}")
            return curPath.size
          } else if (!curPath.contains(str)) {
            val nw = mutableListOf<String>()
            curPath.forEach { nw.add(it) }
            nw.add(str)
            //tracelog("adding next path $nw")
            acceptednum += 1
            nextPaths.add(nw)
            if (!seenNodes.contains(str)) {
              seenNodes.add(str)
            }
            if (acceptednum % DOTEACH == 0) {
              System.err.print(".${System.currentTimeMillis()-lastrdtm} ")
              System.err.flush()
            }
          } else {
            //tracelog("rejected self-ref path ${curPath} $str")
            rejectednum += 1
          }
        }
      }
      curPaths.clear()
    }
    //println("ABORT after round #$round; seen-nodes-#=${seenNodes.size}")
    throw RuntimeException("ABORT after round #$round; seen-nodes-#=${seenNodes.size}")
    //return -1
  }

  private fun buildWorldGraph(world: World): GraphUndirUnwtd {
    //** build world nodes graph
    val g = GraphUndirUnwtd()
    for (y in 0..world.dimy - 1) {
      for (x in 0..world.dimx - 1) {
        if (world.grid[y][x] == 1) {
          tracelog("add node($x,$y)")
          g.addNode("$x,$y")
        }
      }
    }
    deblog("buildworldgraph: nodes #:${g.nodes.size}")

    //** build world nodes-graph Edges
    for (y in 0..world.dimy - 1) {
      for (x in 0..world.dimx - 1) {
        if (world.grid[y][x] == 1) {
          // check edges
          var yy = y - 1
          if (yy >= 0 && g.containsNode("$x,$yy")) {
            //println("add edge($x,$y<=>$x,$yy)")
            g.addEdge("$x,$y", "$x,$yy")
          }
          yy = y + 1
          if (yy < world.dimy && g.containsNode("$x,$yy")) {
            //println("add edge($x,$y<=>$x,$yy)")
            g.addEdge("$x,$y", "$x,$yy")
          }
          var xx = x - 1
          if (xx >= 0 && g.containsNode("$xx,$y")) {
            //println("add edge($x,$y<=>$xx,$y)")
            g.addEdge("$x,$y", "$xx,$y")
          }
          xx = x + 1
          if (xx < world.dimx && g.containsNode("$xx,$y")) {
            //println("add edge($x,$y<=>$xx,$y)")
            g.addEdge("$x,$y", "$xx,$y")
          }
        }
      }
    }
    deblog("buildworldgraph: edges #:${g.edges.size}")
    return g
  }

  private fun getPointEdges(world: World): List<PointEdge> {
    val pointnodes = world.pointnodes
    val pointedges = mutableListOf<PointEdge>()
    pointnodes.forEach { ptnode ->
      pointnodes.forEach { ptnode2 ->
        if (!(ptnode.nodename == ptnode2.nodename)) {
          //if (!pointedges.contains("${ptnode2.nodename}-${ptnode.nodename}")) {
          //  infolog("edge: ${ptnode.nodename}<=>${ptnode2.nodename}; ${ptnode.nodeid}-${ptnode2.nodeid}")
          //  pointedges.add("${ptnode.nodename}-${ptnode2.nodename}")
          //}
          var seen = false
          pointedges.forEach { ptedge ->
            if (
            (ptnode.nodeid == ptedge.node1.nodeid && ptnode2.nodeid == ptedge.node2.nodeid)
              || (ptnode.nodeid == ptedge.node2.nodeid && ptnode2.nodeid == ptedge.node1.nodeid)
            ) {
              seen = true
            }
          }
          if (!seen) {
            infolog("add Pointedge $ptnode to $ptnode2")
            pointedges.add(PointEdge(ptnode, ptnode2))
          }
        }
      }
    }
    return pointedges.sortedBy { it.node1.nodename + it.node2.nodename }.toList()
  }
}
