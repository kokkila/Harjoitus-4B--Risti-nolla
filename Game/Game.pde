import java.util.Collections;
float rotx = PI/4;
float roty = PI/4;
Tile[][] frontTiles, backTiles, rightTiles, leftTiles, topTiles, bottomTiles;
ArrayList<Tile> tiles2;
Tile[][][] tiles;
int tileSize, cubeSize;
//kuution reunojen koordinaatit
int max;
Tile currentTile;
int picked;
int tmpCounter;


void setup() {
  tmpCounter = 0;
  size(640, 360, P3D);
  this.tileSize = 20;
  this.cubeSize = 10;  
  frontTiles = new Tile [cubeSize][cubeSize];
  backTiles = new Tile [cubeSize][cubeSize];
  rightTiles = new Tile [cubeSize][cubeSize];
  leftTiles = new Tile [cubeSize][cubeSize];
  topTiles = new Tile [cubeSize][cubeSize];
  bottomTiles = new Tile [cubeSize][cubeSize];
  tiles2 = new ArrayList<Tile>();
  tiles = new Tile [6][cubeSize][cubeSize];
  max = cubeSize*tileSize/2;
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      frontTiles[i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k, this);
      tiles[0][i][k] = new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k, this);
      tiles2.add(new Tile(-max + i * tileSize, -max + k * tileSize, max, tileSize, Side.FRONT, i, k, this));
    }
  }

  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, -max + k * tileSize, -max, tileSize, Side.BACK, i, k, this);
      backTiles[i][k] = tmpTile;
      tiles[1][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.RIGHT, i, k, this);
      rightTiles[i][k] = tmpTile;
      tiles[2][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max, -max + k * tileSize, -max + i * tileSize, tileSize, Side.LEFT, i, k, this);
      leftTiles[i][k] = tmpTile;
      tiles[3][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, max, -max + k * tileSize, tileSize, Side.TOP, i, k, this);
      topTiles[i][k] = tmpTile;
      tiles[4][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }
  for (int i = 0; i < cubeSize; i++) {
    for (int k = 0; k < cubeSize; k++) {
      Tile tmpTile = new Tile(-max + i * tileSize, -max, -max + k * tileSize, tileSize, Side.BOTTOM, i, k, this);
      bottomTiles[i][k] = tmpTile;
      tiles[5][i][k] = tmpTile;
      tiles2.add(tmpTile);
    }
  }
}

void draw() {
  background(0);
  noStroke(); // jotta sisällä oltavan pallon piirtoviivat eivät näy

  //directionalLight(51, 102, 255, 0, 0, -100); // sininen yleisvalo
  directionalLight(0, 0, 0, 0, 0, -100); // musta yleisvalo
  //pointLight(200, 200, 255, width/2, height/2, 150); // r g b -  x y z
  spotLight(200, 200, 255, width/2, height/2, 150, 0, 0, -1, PI, 2); // taustaa varten pointlight (r g b -  x y z mistä - xyz mihin - kulma - intensiteetti)
  spotLight(50, 50, 50, width/2, height/2, 150, 0, 0, -1, PI, 1); // palikkaa varten pointlight
  spotLight(102, 153, 204, mouseX, mouseY, 600, 0, 0, -1, PI/2, 600);

  translate(width/2.0, height/2.0, -100);
  sphere(400); // pallo, jonka sisällä ollaan (jotta taustalle piirtyy valoa)
  rotateX(rotx);
  rotateY(roty);
  //println("RotX: " + rotx%PI + ", RotY: " + roty%PI);
  //println("MouseX: " + mouseX + ", MouseY: " + mouseY);
  //scale(90);
  picked = getPicked();
  stroke(255);
  strokeWeight(10);
  line(0, 0, 0, 400, 0, 0);
  line(0, 0, 0, 0, 400, 0);
  line(0, 0, 0, 0, 0, 400);
  strokeWeight(1);
  
  for (int i = 0; i < tiles2.size(); i++) {
    Tile t = (Tile)tiles2.get(i);
    t.isCurrentTile = false;
    if (i == picked) {
      fill(#ff8080);
      t.isCurrentTile = true;
    }
    else {
      fill(200);
    }
    t.display();
  }
  //frontTiles[0][0].updateLaser(0);
}

void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}

void mouseClicked() {
  //removeAllLasers();
  tmpCounter = 0;
  println("Picked: " + picked);
  if (picked != -1) {
    Tile tmpTile = tiles2.get(picked);
  }
}
int getPicked() {
  int picked = -1;
  if (mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height) {
    for (int i = 0; i < tiles2.size(); i++) {
      Tile t = (Tile)tiles2.get(i);
      t.project();
    }
    Collections.sort(tiles2);
    for (int i = 0; i < tiles2.size(); i++) {
      Tile t = (Tile)tiles2.get(i);
      if (t.mouseOver()) {
        picked = i;
        break;
      }
    }
  }
  //println(picked);
  return picked;
}




//TOP, RIGHT, LEFT, FRONT, BACK, BOTTOM
void moveToTileNeighbor(Tile prev, Side fromSide) {

  if (tmpCounter > 40) {
    return;
  }
  tmpCounter++;

  Tile neighbor = null;
  boolean overEdge = false;
  Side toSide = fromSide;
  if (prev.side == Side.FRONT) {
    if (prev.squareX == 0 && fromSide == Side.RIGHT) {
      overEdge = true;
    }

    if (prev.squareX == cubeSize - 1 && fromSide == Side.LEFT) {
      overEdge = true;
    }

    if (prev.squareY == 0 && fromSide == Side.BOTTOM) {
      overEdge = true;
    }

    if (prev.squareY == cubeSize -1 && fromSide == Side.TOP) {
      overEdge = true;
    }

    if (fromSide == Side.RIGHT) {
      if (!overEdge) {
        neighbor = frontTiles[prev.squareX-1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = leftTiles[cubeSize-1][prev.squareY];
      }
    }

    if (fromSide == Side.LEFT) {
      if (!overEdge) {
        neighbor = frontTiles[prev.squareX+1][prev.squareY];
      }
      else {
        println("OVEREDGE");
        toSide = prev.side;
        neighbor = rightTiles[cubeSize-1][prev.squareY];
      }
    }

    if (fromSide == Side.TOP) {
      if (!overEdge) {
        neighbor = frontTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = bottomTiles[prev.squareX][cubeSize-1];
      }
    }

    if (fromSide == Side.BOTTOM) {
      if (!overEdge) {
        neighbor = frontTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = topTiles[prev.squareX][cubeSize-1];
      }
    }
  }

  if (prev.side == Side.RIGHT) {

    if (prev.squareX == 0 && fromSide == Side.FRONT) {
      overEdge = true;
    }

    if (prev.squareX == cubeSize - 1 && fromSide == Side.BACK) {
      overEdge = true;
    }

    if (prev.squareY == 0 && fromSide == Side.BOTTOM) {
      overEdge = true;
    }

    if (prev.squareY == cubeSize -1 && fromSide == Side.TOP) {
      overEdge = true;
    }

    if (fromSide == Side.FRONT) {
      if (!overEdge) {
        neighbor = rightTiles[prev.squareX-1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = backTiles[cubeSize-1][prev.squareY];
      }
    }

    if (fromSide == Side.BACK) {
      if (!overEdge) {
        neighbor = rightTiles[prev.squareX+1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = frontTiles[cubeSize-1][prev.squareY];
      }
    }

    if (fromSide == Side.TOP) {
      if (!overEdge) {
        neighbor = rightTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = bottomTiles[cubeSize-1][prev.squareX];
      }
    }

    if (fromSide == Side.BOTTOM) {
      if (!overEdge) {
        neighbor = rightTiles[prev.squareX][prev.squareY-1];
      }
      else {
        toSide = prev.side;
        neighbor = topTiles[cubeSize-1][prev.squareX];
      }
    }
  }

  if (prev.side == Side.BACK) {

    if (prev.squareX == 0 && fromSide == Side.RIGHT) {
      overEdge = true;
    }

    if (prev.squareX == cubeSize - 1 && fromSide == Side.LEFT) {
      overEdge = true;
    }

    if (prev.squareY == 0 && fromSide == Side.BOTTOM) {
      overEdge = true;
    }

    if (prev.squareY == cubeSize -1 && fromSide == Side.TOP) {
      overEdge = true;
    }

    if (fromSide == Side.RIGHT) {
      if (!overEdge) {
        neighbor = backTiles[prev.squareX-1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = leftTiles[0][prev.squareY];
      }
    }

    if (fromSide == Side.LEFT) {
      if (!overEdge) {
        neighbor = backTiles[prev.squareX+1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = rightTiles[0][prev.squareY];
      }
    }

    if (fromSide == Side.TOP) {
      if (!overEdge) {
        neighbor = backTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = bottomTiles[prev.squareX][0];
      }
    }

    if (fromSide == Side.BOTTOM) {
      if (!overEdge) {
        neighbor = backTiles[prev.squareX][prev.squareY-1];
      }
      else {
        toSide = prev.side;
        neighbor = topTiles[prev.squareX][0];
      }
    }
  }

  if (prev.side == Side.LEFT) {

    if (prev.squareX == 0 && fromSide == Side.FRONT) {
      overEdge = true;
    }

    if (prev.squareX == cubeSize - 1 && fromSide == Side.BACK) {
      overEdge = true;
    }

    if (prev.squareY == 0 && fromSide == Side.BOTTOM) {
      overEdge = true;
    }

    if (prev.squareY == cubeSize -1 && fromSide == Side.TOP) {
      overEdge = true;
    }

    if (fromSide == Side.FRONT) {
      if (!overEdge) {
        neighbor = leftTiles[prev.squareX-1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = backTiles[0][prev.squareY];
      }
    }

    if (fromSide == Side.BACK) {
      if (!overEdge) {
        neighbor = leftTiles[prev.squareX+1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = frontTiles[0][prev.squareY];
      }
    }

    if (fromSide == Side.TOP) {
      if (!overEdge) {
        neighbor = leftTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = bottomTiles[0][prev.squareX];
      }
    }

    if (fromSide == Side.BOTTOM) {
      if (!overEdge) {
        neighbor = leftTiles[prev.squareX][prev.squareY-1];
      }
      else {
        toSide = prev.side;
        neighbor = topTiles[0][prev.squareX];
      }
    }
  }

  if (prev.side == Side.TOP) {

    if (prev.squareX == 0 && fromSide == Side.RIGHT) {
      overEdge = true;
    }

    if (prev.squareX == cubeSize - 1 && fromSide == Side.LEFT) {
      overEdge = true;
    }

    if (prev.squareY == 0 && fromSide == Side.FRONT) {
      overEdge = true;
    }

    if (prev.squareY == cubeSize -1 && fromSide == Side.BACK) {
      overEdge = true;
    }

    if (fromSide == Side.FRONT) {
      if (!overEdge) {
        neighbor = topTiles[prev.squareX][prev.squareY-1];
      }
      else {
        toSide = prev.side;
        neighbor = backTiles[prev.squareX][0];
      }
    }

    if (fromSide == Side.RIGHT) {
      if (!overEdge) {
        neighbor = topTiles[prev.squareX-1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = leftTiles[prev.squareY][0];
      }
    }

    if (fromSide == Side.BACK) {
      if (!overEdge) {
        neighbor = topTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = frontTiles[prev.squareX][0];
      }
    }

    if (fromSide == Side.LEFT) {
      if (!overEdge) {
        neighbor = topTiles[prev.squareX+1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = rightTiles[prev.squareY][0];
      }
    }
  }

  if (prev.side == Side.BOTTOM) {

    if (prev.squareX == 0 && fromSide == Side.RIGHT) {
      overEdge = true;
    }

    if (prev.squareX == cubeSize - 1 && fromSide == Side.LEFT) {
      overEdge = true;
    }

    if (prev.squareY == 0 && fromSide == Side.FRONT) {
      overEdge = true;
    }

    if (prev.squareY == cubeSize -1 && fromSide == Side.BACK) {
      overEdge = true;
    }

    if (fromSide == Side.FRONT) {
      if (!overEdge) {
        neighbor = bottomTiles[prev.squareX][prev.squareY-1];
      }
      else {
        toSide = prev.side;
        neighbor = backTiles[prev.squareX][cubeSize-1];
      }
    }

    if (fromSide == Side.RIGHT) {
      if (!overEdge) {
        neighbor = bottomTiles[prev.squareX-1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = leftTiles[prev.squareY][cubeSize-1];
      }
    }

    if (fromSide == Side.BACK) {
      if (!overEdge) {
        neighbor = bottomTiles[prev.squareX][prev.squareY+1];
      }
      else {
        toSide = prev.side;
        neighbor = frontTiles[prev.squareX][cubeSize-1];
      }
    }

    if (fromSide == Side.LEFT) {
      if (!overEdge) {
        neighbor = bottomTiles[prev.squareX+1][prev.squareY];
      }
      else {
        toSide = prev.side;
        neighbor = rightTiles[prev.squareY][cubeSize-1];
      }
    }
  }
  if (overEdge) {
  }
  if (prev.side == Side.FRONT && toSide == Side.RIGHT) {

  }
  moveToTileNeighbor(neighbor, toSide);
}

