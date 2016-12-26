/**
 * Created by rhe on 26.12.16.
 */
class Path(val startnode: PointNode) { //val node1: PointNode, val node2:PointNode, var dist: Int = 0) {
  val edges = mutableListOf<PointEdge>()
  val nodeset = mutableSetOf<String>() //mutableSetOf<PointNode>()
  var lastnode = startnode
  var totaldist: Int = 0

  init {
    nodeset.add(startnode.nodename)
  }

  fun addEdge(pointEdge: PointEdge) {
    edges.add(pointEdge)
    totaldist += pointEdge.dist
    lastnode = pointEdge.node2
    nodeset.add(pointEdge.node2.nodename)
  }

  fun dup(): Path {
    //val stid = startnode.nodeid
    //val stnm = startnode.nodename
    //--val lastid = lastnode.nodeid
    //--val lstnm = lastnode.nodename
    val target = Path(startnode)
    edges.forEach {
      target.edges.add(it)
    }
    target.totaldist = totaldist
    nodeset.forEach {
      target.nodeset.add(it)
    }
    target.lastnode = lastnode
    return target
  }

  fun toExtString(): String {
    return "path: edges#=${edges.size}, nodest#=${nodeset.size}, sum-dist=$totaldist; start-nd=$startnode; last-nd=$lastnode :> $edges"
  }

  override fun toString(): String {
    return "path: edges#=${edges.size}, sum-dist=$totaldist; start-nd=$startnode; last-nd=$lastnode."
  }
}
