/**
 * World class.
 */
class World(val dimx: Int, val dimy: Int) : AocBase() {
  val grid: Array<IntArray>
  var pointnodes = mutableListOf<PointNode>()

  init {
    grid = Array(dimy){IntArray(dimx)}
    deblog("init-world dimx=$dimx, dimy=$dimy")
    deblog("  World-grid=$grid")
  }

  //companion object Factory {
  //  fun create(): World = World()
  //}
  companion object {
    /**
     * Create from a string representation.
     */
    fun create(repr2d: String): World {
      var dimx = 0
      var linenum = 0
      repr2d.split("\n").forEach { line ->
        linenum += 1
        tracelog("found >$line<")
        if (line.length > dimx) {
          dimx = line.length
        }
      }
      val dimy = linenum
      val world = World(dimx, dimy)
      var y = -1
      repr2d.split("\n").forEach { line ->
        y += 1
        for (x in 0..line.length-1) {
          val c = line[x].toString()
          if (c == "#") { // wall:
            world.grid[y][x] = 0
          } else if (c == "."){ // room:
            world.grid[y][x] = 1
          } else { // "1" room with node:
            world.grid[y][x] = 1
            val pointnode = PointNode("$x,$y", c)
            deblog("create pointnode $pointnode.")
            world.pointnodes.add(pointnode)
          }
        }
      }
      return world
    }

    /**
     * Create alogrithmicly with dimensions and a numeric seed/salt.
     */
    fun create(dimx: Int, dimy: Int, seed: Int): World {
      val world = World(dimx, dimy)
      for (y in 0..dimy-1) {
        for (x in 0..dimx-1) {
          val z = x*x + 3*x + 2*x*y + y + y*y + seed
          val bs = Integer.toBinaryString(z)
          val cts = bs.split("").filter{it=="1"}.joinToString("")
          val ct = cts.length
          if (ct%2 == 0) { // room:
            world.grid[y][x] = 1
          } else {  // wall:
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
    println("v/>0123456789abcdef")
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
