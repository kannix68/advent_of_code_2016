/**
 * Node class.
 */

class Node(val nid: String) {
  fun ident(other: Node): Boolean {
    println("indent? ${this.nid} ==? ${other.nid}")
    return this.nid == other.nid
  }

  override fun toString(): String {
    return "node($nid)"
  }
}
