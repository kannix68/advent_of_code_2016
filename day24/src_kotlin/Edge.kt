/**
 * Created by rhe on 15.12.16.
 */
/**
 * Edge class.
 */

open class Edge(val nodeid1: String, val nodeid2: String) {
  fun ident(other: Edge): Boolean {
    return this.nodeid1 == other.nodeid1 && this.nodeid2 == other.nodeid2
  }

  open override fun toString(): String {
    return "edge($nodeid1;$nodeid2)"
  }
}
