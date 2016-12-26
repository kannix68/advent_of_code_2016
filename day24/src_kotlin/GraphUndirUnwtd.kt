
import kotlin.collections.*
import java.util.*

/**
 * Graph class, undirected (edges go both ways), unweighted (all edge distances/costs are same).
 */
class GraphUndirUnwtd {
  val nodes = mutableListOf<Node>()
  val edges = mutableListOf<Edge>()
  val visitedNodes = hashMapOf<Node, Boolean>()
  val prevPaths = hashMapOf<Node, Node>()

  fun getDirections(startNd: Node, endNd: Node): List<Node>  {
    val list = mutableListOf<Node>()
    list.add(startNd)
    list.add(endNd)
    return list.toList()
  }

  //fun addNode(intArrayOf: IntArray) {
  //  val node = Node(intArrayOf)
  //  pointnodes.add(node)
  //}

  fun addNode(nodeid: String) {
    nodes.add(Node(nodeid))
  }

  fun addNode(node: Node) {
    nodes.add(node)
  }

  fun addEdge(nid1: String, nid2: String) {
    edges.add(Edge(nid1, nid2))
  }

  fun containsNode(nodeid: String): Boolean {
    return nodes.map { it.nodeid }.contains(nodeid)
  }
}
