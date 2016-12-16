/**
 * World class.
 */
class World(val dimx: Int, val dimy: Int) {
  public val grid: Array<IntArray>

  init {
    grid = Array(dimy){IntArray(dimx)}
    println("  grid=$grid")
  }

  //companion object Factory {
  //  fun create(): World = World()
  //}
  companion object {
    fun create(dimx: Int, dimy: Int, seed: Int): World {
      val world = World(dimx, dimy)
      for (y in 0..dimy-1) {
        for (x in 0..dimx-1) {
          val z = x*x + 3*x + 2*x*y + y + y*y + seed
          val bs = Integer.toBinaryString(z)
          val cts = bs.split("").filter{it=="1"}.joinToString("")
          val ct = cts.length
          if (ct%2 == 0) { // room
            world.grid[y][x] = 1
          } else {
            world.grid[y][x] = 0
          }
        }
      }
      return world
    }
  }

  override fun toString(): String {
    return "world($dimx,$dimy)"
  }

  fun printgrid() {
    println("v/>0123456789")
    grid.forEachIndexed { y, ar ->
      //var s = "$y:: "
      var s = "$y: "
      ar.forEachIndexed { x, v ->
        if (v == 1) {
          s += "."
        } else {
          s += "#"
        }
      }
      println(s)
    }
  }
}
