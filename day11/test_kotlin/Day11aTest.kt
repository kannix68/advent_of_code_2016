import org.junit.Assert.*

/**
 * Created by rhe on 2016-12-16.
 */
class Day11aTest {
  @org.junit.Test
  fun createTest() {
    val to = Day11a.create()
    assert(to != null, { "test-object should be creatable" })
    assert(to is Day11a)
  }
}
