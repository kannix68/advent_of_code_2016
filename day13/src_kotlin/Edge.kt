/**
 * Created by rhe on 15.12.16.
 */
/**
 * Edge class.
 */

class Edge(val nid1: String, val nid2: String) {
  fun ident(other: Edge): Boolean {
    return this.nid1 == other.nid1 && this.nid2 == other.nid2
  }

  override fun toString(): String {
    return "edge($nid1;$nid2)"
  }
}
