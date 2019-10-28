PImage rawBg;
PImage bgTop;
PImage bgBottom;
float cycle;
GameBoard gb;

void setup() {
  size(350, 625);
  
  rawBg = loadImage("computer.jpg");
  
  gb = new GameBoard();
}

void draw() {
  bgTop = rawBg.get(0, (int) cycle, width, height);
  bgBottom = rawBg.get(0, (int) cycle - rawBg.height, width, height);
  image(bgTop, 0, 0);
  image(bgBottom, 0, 0);
  
  switch(gb.gameState) {
    case WON:
      tint(0, 255, 0);
      break;
    case LOST:
      tint(255, 0, 0);
      break;
    case PLAYING:
      tint(255, 255, 255);
      break;
  }
  
  gb.render();
  
  cycle++;
  cycle %= rawBg.height;
}

void keyPressed() {
  int x = (mouseX - 25) / 50;
  int y = (mouseY - 25) / 50;
  
  Marble m;
  
  switch(key) {
    case 'r':
      m = Marble.RED;
      break;
    case 'g':
      m = Marble.GREEN;
      break;
    case 'y':
      m = Marble.YELLOW;
      break;
    case 'o':
      m = Marble.ORANGE;
      break;
    case 'p':
      m = Marble.PURPLE;
      break;
    case 'b':
      m = Marble.BLACK;
      break;
    case '1':
      gb.restart();
      return;
    default:
      m = Marble.NONE;
      break;
  }
  
  gb.addMarble(x, y, m);
}
