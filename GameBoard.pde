enum Marble {
  NONE,
  RED,
  GREEN,
  YELLOW,
  ORANGE,
  PURPLE,
  BLACK;
}

enum GameState {
  PLAYING,
  WON,
  LOST;
}

public class GameBoard {  
  Marble[][] game;
  Marble[] winCode;
  Marble[] currentCode;
  
  GameState gameState;
  
  int[] cows;
  int[] bulls;
  
  int iteration;
  
  boolean isIdiot;
  
  public GameBoard() {
    game = new Marble[4][10];
    
    for(int x = 0; x < game.length; x++) {
      for(int y = 0; y < game[x].length; y++) {
        game[x][y] = Marble.NONE;
      }
    }
    
    winCode = generateCode(); //<>//
    
    cows = new int[10];
    bulls = new int[10];
    for(int i = 0; i < 10; i++) {
      cows[i] = 0;
      bulls[i] = 0;
    }
    
    iteration = 0;
    
    currentCode = new Marble[4];
    getCurrentCode();
    
    gameState = GameState.PLAYING;
    isIdiot = false;
  }
  
  public void restart() {
    for(int x = 0; x < game.length; x++) {
      for(int y = 0; y < game[x].length; y++) {
        game[x][y] = Marble.NONE;
      }
    }
    
    winCode = generateCode();
    
    for(int i = 0; i < 10; i++) {
      cows[i] = 0;
      bulls[i] = 0;
    }
    
    iteration = 0;
    
    getCurrentCode();
    
    gameState = GameState.PLAYING;
  }
  
  public Marble[] generateCode() {
    Marble[] genCode = new Marble[4];
    Marble[] pickVals = Marble.values();
    
    int randPick;
    for(int i = 0; i < 4; i++) {
      randPick = (int) random(1, 7);
      genCode[i] = pickVals[randPick];
    }
    
    return genCode;
  }
  
  public void getCurrentCode() {    
    for(int i = 0; i < 4; i++) {
      currentCode[i] = game[i][iteration];
    }
  }
  
  public void addMarble(int x, int y, Marble m) {
    if(y >= 10 || x >= 4)
      return;
    
    if(y == iteration && game[x][y] == Marble.NONE) {
      game[x][y] = m;
      
      getCurrentCode();
      
      boolean canIterate = true;
      for(int i = 0; i < 4; i++) {
        if(currentCode[i] == Marble.NONE)
          canIterate = false;
      }
      if(canIterate)
        iterate();
    }
  }
  
  public void iterate() {
    updateCowsBulls();
    setIsIdiot();
    
    if(bulls[iteration] == 4) {
      win();
    }else {      
      if(iteration == 9)
        lose();
      else
        iteration++;
    }
  }
  
  public void setIsIdiot() {
    if(isIdiot || iteration == 0)
      return;
      
    getCurrentCode();
    
    for(int i = 0; i < iteration; i++) {
      isIdiot = true;
      for(int j = 0; j < 4; j++) {
        if(currentCode[j] != game[j][i])
          isIdiot = false;
      }
      if(isIdiot)
        return;
    }
  }
  
  public void win() {
    gameState = GameState.WON;
  }
  
  public void lose() {
    gameState = GameState.LOST;
  }
  
  public void updateCowsBulls() {
    getCurrentCode();
    Marble[] currentCodeWritable = currentCode.clone();
    Marble[] winCodeWritable = winCode.clone();
    
    for(int i = 0; i < 4; i++) {
      if(currentCodeWritable[i] == winCode[i]) {
        bulls[iteration]++;
        currentCodeWritable[i] = Marble.NONE;
        winCodeWritable[i] = Marble.NONE;
      }
    }
    
    for(int i = 0; i < 4; i++) {
      if(currentCodeWritable[i] != Marble.NONE) {
        for(int j = 0; j < 4; j++) {
          if(currentCodeWritable[i] != Marble.NONE && 
                  currentCodeWritable[i] == winCodeWritable[j]) {
            cows[iteration]++;
            currentCodeWritable[i] = Marble.NONE;
            winCodeWritable[j] = Marble.NONE;
          }
        }
      }
    }
  }
  
  public void render() {
    for(int x = 0; x < game.length; x++) {
      for(int y = 0; y < game[x].length; y++) {
        fill(color(4, 113, 186));
        stroke(color(100, 182, 237));
        strokeWeight(10);
        
        rect((x * 50) + 25, (y * 50) + 25, 50, 50);
        
        switch(game[x][y]) {
          case RED:
            fill(color(255, 0, 0));
            break;
          case GREEN:
            fill(color(0, 255, 0));
            break;
          case YELLOW:
            fill(color(255, 240, 0));
            break;
          case ORANGE:
            fill(color(255, 166, 0));
            break;
          case PURPLE:
            fill(color(214, 6, 186));
            break;
          case BLACK:
            fill(color(0, 0, 0));
            break;
          default:
            noFill();
            break;
        }
        
        noStroke();
        ellipse((x * 50) + 50, (y * 50) + 50, 35, 35);
      }
    }
    
    textSize(50);
    
    for(int i = 0; i < 10; i++) {
      fill(color(100, 182, 237));
      rect(245, (i * 50) + 25, 90, 45);
      
      fill(color(4, 113, 186));
      text(bulls[i] + " " + cows[i], 250, (i * 50) + 65.5);
    }
    
    for(int i = 0; i < 4; i++) {
      fill(color(4, 113, 186));
      stroke(color(100, 182, 237));
      strokeWeight(10);
      
      rect((i * 50) + 25, 550, 50, 50);
      
      if(gameState != GameState.PLAYING) {
        switch(winCode[i]) {
          case RED:
            fill(color(255, 0, 0));
            break;
          case GREEN:
            fill(color(0, 255, 0));
            break;
          case YELLOW:
            fill(color(255, 240, 0));
            break;
          case ORANGE:
            fill(color(255, 166, 0));
            break;
          case PURPLE:
            fill(color(214, 6, 186));
            break;
          case BLACK:
            fill(color(0, 0, 0));
            break;
          default:
            noFill();
            break;
        }
        
        noStroke();
        ellipse((i * 50) + 50, 575, 35, 35);
      }
    }
    
    if(isIdiot && frameCount % 50 < 25) {
      textSize(65);
      fill(color(255, 0, 0));
      
      text("YOU IDIOT", 10, 200);
    }
  }
}
