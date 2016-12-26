/**
 * Node class.
 */

open class Node(val nodeid: String) {
  fun ident(other: Node): Boolean {
    println("indent? ${this.nodeid} ==? ${other.nodeid}")
    return this.nodeid == other.nodeid
  }

  override open fun toString(): String {
    return "node($nodeid)"
  }
}
