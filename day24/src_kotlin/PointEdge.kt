/**
 * Created by rhe on 26.12.16.
 */
//class PointEdge(nodeid1: String, nodeid2: String, val nodename1: String, val nodename2: String) : Edge(nodeid1, nodeid2) {

/**
 * PointEdge.
 */
class PointEdge(val node1: PointNode, val node2:PointNode, var dist: Int = 0) {
  override fun toString(): String {
    return "PtEdge dst=$dist: ${node1.nodename}-${node2.nodename}(${node1.nodeid}:${node2.nodeid})"
  }

  //fun dup(): PointEdge {
  //  return PointEdge(node1, node2, dist)
  //}
}
