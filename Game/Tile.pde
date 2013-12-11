import java.awt.Polygon;
class Tile implements Comparable {
  int x,y,z, size;
  // center koordinaatti 
  int cx, cy, cz;
  int squareX, squareY;
  Vector3d a, b, c, d;
  Vector3d pa, pb, pc, pd;
  Game game;
  Side side;
  boolean isCurrentTile;

  Tile(int x, int y, int z, int size, Side side, int squareX, int squareY, Game game) {
    this.a = new Vector3d(x, y, z);    
    if (side == Side.FRONT || side == Side.BACK) {
      this.b = new Vector3d(x+size, y, z);
      this.c = new Vector3d(x+size, y+size, z);
      this.d = new Vector3d(x, y+size, z);
      this.cx = (x + size/2);
      this.cy = (y + size/2);
      this.cz = z;
    }
    if (side == Side.RIGHT || side == Side.LEFT) {
      this.b = new Vector3d(x, y+size, z);
      this.c = new Vector3d(x, y+size, z+size);
      this.d = new Vector3d(x, y, z+size);
      this.cx = x;
      this.cy = (y + size/2);
      this.cz = (z + size/2);
    }
    if (side == Side.TOP || side == Side.BOTTOM) {
      this.b = new Vector3d(x+size, y, z);
      this.c = new Vector3d(x+size, y, z+size);
      this.d = new Vector3d(x, y, z+size);
      this.cx = (x + size/2);
      this.cy = y;
      this.cz = (z + size/2);
    }
    this.x = x;
    this.y = y;
    this.z = z;
    this.squareX = squareX;
    this.squareY = squareY;
    this.size = size;
    this.side = side;
    this.isCurrentTile = false;
    this.game = game;
  }

  public void display() {

    fill(255);
    
    if (isCurrentTile) {
      fill(0, 0, 255);
    }
    beginShape();
    vertex(a.x, a.y, a.z);
    vertex(b.x, b.y, b.z);
    vertex(c.x, c.y, c.z);
    vertex(d.x, d.y, d.z);
    endShape(CLOSE);

  }

  void project() {
    pa = a.project();
    pb = b.project();
    pc = c.project();
    pd = d.project();
  }

  boolean mouseOver() {
    // "cheating" using Java's generic polygon class instead of writing my own triangle intersection routine, which probably would be faster
    Polygon p = new Polygon( new int [] { 
      (int)pa.x, (int)pb.x, (int)pc.x
    }
    , new int [] { 
      (int)pa.y, (int)pb.y, (int)pc.y
    }
    , 3);
    return p.inside(mouseX, mouseY);
  }


  int compareTo(Object other) {
    // compare average depth
    float d1 = pa.z+pb.z+pc.z+pd.z;
    Tile t2 = (Tile)other;
    float d2 = t2.pa.z+t2.pb.z+t2.pc.z+t2.pd.z;
    if (d1>d2) {
      return 1;
    }
    else if (d1==d2) {
      return 0;
    }
    else {
      return -1;
    }
  }

}
