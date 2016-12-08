import java.io.*;
import java.util.regex.*;

/**
 * Advent of code 2016, AoC day 8 puzzle 1.
 * This solution (Java 7) by kannix68, @ 2016-12-08.
 * Run as:
 * `java -jar `
 */
public class Aoc16Day08a {
  private boolean[][] mxdisplay;
  private int xdim; // this backs mxdisplay.length
  private int ydim; // this backs mxdisplay[0].length

  /**
   * Constructor accepting matrixdisplay x-y-size.
   */
  public Aoc16Day08a(int xdim, int ydim) {
    this.xdim = xdim;
    this.ydim = ydim;
    mxdisplay = new boolean[xdim][ydim];
    System.out.println("initialized mxdisplay [" + xdim + ", " + ydim + "].");
  }

  /**
   * Get count of cells being active ("on"/true).
   */
  public int getActiveCells() {
    int counter = 0;
    for(boolean[] innerary: mxdisplay) {
      for (boolean active: innerary) {
        if (active) {
          counter += 1;
        }
      }
    }
    //System.out.println("counted " + counter + " active cells");
    return counter;
  }

  /**
   * Print a text representation of the mxdisplay to stdout.
   */
  public void printMxDisplay() {
    System.out.println("mxdisplay[" + xdim + "," + ydim + "], " + getActiveCells() + " active ::");
    for(int y=0; y < ydim; y++) {
      String lineDisp = "";
      for(int x=0; x < xdim; x++) {
        if(mxdisplay[x][y]) {
          lineDisp += "#";  // on
        } else {
          lineDisp += ".";  // off
        }
      }
      System.out.println(lineDisp);
    }
  }

  /**
   * Activate a rectange xw wide an yh tall on upper-left corner of mxdisplay.
   */
  public void activateRect(int xw, int yh) {
    for(int y=0; y < yh; y++) { // height
      for(int x=0; x < xw; x++) {  // width
        if (!mxdisplay[x][y]) {
          mxdisplay[x][y] = true;
        }
      }
    }
    System.out.println("activated rect " + xw + "x" + yh);
  }
  
  /**
   * Rotate a row (fixed y, line) right by byCols columns, overflowing.
   * @param rowNum int 0-based row number
   * @param byCols int number of columns to shift the row to the right
   */
  public void rotateRow(int rowNum, int byCols) {
    boolean[] newRow = new boolean[xdim];
    for(int x=0; x < xdim; x++) { // shift on (new) buffered line
      newRow[(x+byCols)%xdim] = mxdisplay[x][rowNum];
    }
    for(int x=0; x < xdim; x++) { // copy resultto mxdisplay
      mxdisplay[x][rowNum] = newRow[x];
    }
    System.out.println("rotated X row #" + rowNum + " by " + byCols + " cols");
  }

  /**
   * Rotate a column (fixed x) down by byRows rows, overflowing.
   * @param colNum int 0-based column number
   * @param byRowss int number of rows to shift the column down
   */
  public void rotateCol(int colNum, int byRows) {
    boolean[] newCol = new boolean[ydim];
    for(int y=0; y < ydim; y++) { // shift on (new) buffered line
      newCol[(y+byRows)%ydim] = mxdisplay[colNum][y];
    }
    for(int y=0; y < ydim; y++) { // copy resultto mxdisplay
      mxdisplay[colNum][y] = newCol[y];
    }
    System.out.println("rotated Y col #" + colNum + " by " + byRows + " rows");
  }

  /**
   * Process a string command (single line) on the mxdisplay;
   * knows "rect", "rotate column x" and "rotate row y" commands.
   */
  public void processCmdStr(String cmd) {
    System.out.println("processing command: " + cmd);
    Pattern pattern;
    Matcher matcher;
    pattern = Pattern.compile("^rect (\\d+)x(\\d+)$"); //"rect 3x2"
    matcher = pattern.matcher(cmd);
    if (matcher.matches()) {
      int x = Integer.parseInt(matcher.group(1));
      int y = Integer.parseInt(matcher.group(2));
      activateRect(x, y);
      return;
    }
    pattern = Pattern.compile("^rotate column x=(\\d+) by (\\d+)$"); //"rotate column x=1 by 1"
    matcher = pattern.matcher(cmd);
    if (matcher.matches()) {
      int col = Integer.parseInt(matcher.group(1));
      int by = Integer.parseInt(matcher.group(2));
      rotateCol(col, by);
      return;
    }
    pattern = Pattern.compile("^rotate row y=(\\d+) by (\\d+)$"); //"rotate row y=0 by 4"
    matcher = pattern.matcher(cmd);
    if (matcher.matches()) {
      int row = Integer.parseInt(matcher.group(1));
      int by = Integer.parseInt(matcher.group(2));
      rotateRow(row, by);
      return;
    }
    throw new RuntimeException("invalid command " + cmd);
  }

  /**
   * Process all the commands given as (multiline) string on the mxdisplay.
   */
  public void processCommands(String data) {
    //System.out.println("  data=" + data + "<!" );
    try {
      String line=null;
      BufferedReader bufReader = new BufferedReader(new StringReader(data));
      while( (line=bufReader.readLine()) != null ) {
        //System.out.println("  Line=" + line + "<!" );
        processCmdStr(line);
        printMxDisplay();
      }
    } catch (IOException ex) {
      throw new RuntimeException(ex);
    }
  }

  /**
   * "Factory method" instance getter, initializing 2d-bool-array (mxdisplay).
   */
  public static Aoc16Day08a getInstance(int xdim, int ydim) {
    return new Aoc16Day08a(xdim, ydim);
  }

  /**
   * Read a named file into a String.
   */
  public static String readFileStr(String filename) {
    String strLine;
    StringBuffer fileDataBuf = new StringBuffer("");
    System.out.println("reding file " + filename);
    try {
      FileInputStream fstream = new FileInputStream(filename); // Open the file
      BufferedReader br = new BufferedReader(new InputStreamReader(fstream));
      while ((strLine = br.readLine()) != null) { //Read File Line By Line
        fileDataBuf.append(strLine + "\n");
      }
      br.close(); //Close the input stream
    } catch (IOException ex) {
      throw new RuntimeException(ex);
    }
    return fileDataBuf.toString();
  }

  /**
   * PSVM Application main entry point.
   * @param args  command line arguments
   */
  public static void main(String[] args) {
    String filename;
    int dimx, dimy;
    boolean testing = false;

    //for(String arg: args) {
    //  System.out.println("  ARG=" + arg);
    //}
    if (args.length > 0 && args[0].equals("test")) {
      System.out.println("Starting, mode=test...");
      testing = true;
    } else {
      System.out.println("Starting, mode=data...");
    }
    if (testing) { // test data:
      filename = "day08_test.txt";
      dimx = 7;
      dimy = 3;
    } else { // problem data:
      filename = "day08_data.txt";
      dimx = 50;
      dimy = 6;
    }
    Aoc16Day08a aoc16day08a = Aoc16Day08a.getInstance(dimx, dimy);
    aoc16day08a.printMxDisplay();
    String data = readFileStr(filename);
    aoc16day08a.processCommands(data);
  }
}
