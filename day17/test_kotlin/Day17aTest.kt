import org.junit.Assert.*

/**
 * Created by rhe on 14.12.16.
 */
class Day17aTest {
  @org.junit.Test
  fun md5sumhex() {
    val to = Day17a.create()
    val md5str = to.md5sumhex("")
    assert(md5str.length == 32, { "md5sum str-len should be 32" }) //, "length of md5sum = 32 chars")
  }

  @org.junit.Test
  fun main() {
    val to = Day17a()
    assert(to is Day17a)
  }

}
