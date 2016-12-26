/**
 * Created by rhe on 26.12.16.
 */
class PointNode(nodeid: String, val nodename: String) : Node(nodeid) {
  override fun toString(): String {
    return "PtNode($nodeid; nm=$nodename)"
  }

  //fun dup(): PointNode {
  //  return PointNode(nodeid, nodename)
  //}
}
