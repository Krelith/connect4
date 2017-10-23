// Classes

class Slot {
  int state; // 0 = empty, 1 = red, 2 = yellow  
  int x;
  int y;
  int slotID;
}

class Token {
  boolean colourRed; // true for red, false for yellow
  boolean nextToken; // true when the token in question is about to be called up to active
  int state; // 0 = stored (in the stack), 1 = active (controlled above the board), 2 = used (settled in the board)
  int tokenID;
  int x;
  float y;
}

class nextRedClass {
  int x;
  int y;
  boolean occupied;
}

class nextYelClass {
  int x;
  int y;
  boolean occupied;
}

// Arrays & Objects

Slot[] slots = new Slot[42]; // Array of slot objects, accessible through slots[i]
Token[] tokens = new Token[42]; // Array of Token objects
int[] slotCentresX = new int[42]; 
int[] slotCentresY = new int [42]; 
int[] tokenCentresX = new int[42];
int[] tokenCentresY = new int [42];
int[] xs = { 250, 350, 450, 550, 650, 750, 850 }; // Possible X values within the game board
int[] rowOne = { 0, 1, 2, 3, 4, 5, 6 }; // Slot numbers arranged by rows
int[] rowTwo = { 7, 8, 9, 10, 11, 12, 13 };
int[] rowThree = { 14, 15, 16, 17, 18, 19, 20 };
int[] rowFour = { 21, 22, 23, 24, 25, 26, 27 };
int[] rowFive = { 28, 29, 30, 31, 32, 33, 34 };
int[] rowSix = { 35, 36, 37, 38, 39, 40, 41 };
int[] possibleHoriWins = { 0, 1, 2, 3, 7, 8, 9, 10, 14, 15, 16, 17, 21, 22, 23, 24, 28, 29, 30, 31, 35, 36, 37, 38 }; // Slot numbers as 'i' that can result in win state
int[] possibleDiagTLWins = { 0, 1, 2, 3, 7, 8, 9, 10, 14, 15, 16, 17 };
int[] possibleDiagBLWins = { 21, 22, 23, 24, 28, 29, 30, 31, 35, 36, 37, 38 };

nextRedClass nextRed = new nextRedClass();
nextYelClass nextYel = new nextYelClass();



// Global Variables

int activeX;
int activeY;
PFont startFont;
PFont idFont;
PFont playerFont;
PFont winFont;
PImage logo;
PImage board;
boolean gameStart;
int lastDropped;
int dd;
boolean noDrop;
boolean redWin;
boolean yelWin;
boolean noWin;
boolean autoPlay;
int screen;
int load;

// Object Initiators

void nextRedInit() {
  nextRed.x = 100;
  nextRed.y = 750;
  nextRed.occupied = true;
}

void nextYelInit() {
  nextYel.x = 1000;
  nextYel.y = 750;
  nextYel.occupied = true;
}

void slotInit() {  
  for (int i = 0; i < 42; i++) { // 'For' loop to automate the creation of the slots occupying the grid, each slot defaults to empty state (0)
    slots[i] = new Slot();
    slots[i].state = 0;
    slots[i].x = slotCentresX[i]; 
    slots[i].y = slotCentresY[i]; 
    slots[i].slotID = i;
  }
}

void tokenInit() {
  for (int i = 0; i < 42; i++) { // loop to create tokens. Evens are red, odds are yellow. 21 of each colour.
    if (i % 2 == 0) {
      tokens[i] = new Token();
      tokens[i].colourRed = true;
      tokens[i].state = 0;
      tokens[i].tokenID = i;
      tokens[i].x = tokenCentresX[i];
      tokens[i].y = tokenCentresY[i];
    } else {
      tokens[i] = new Token();
      tokens[i].colourRed = false;
      tokens[i].state = 0;
      tokens[i].tokenID = i;
      tokens[i].x = tokenCentresX[i];
      tokens[i].y = tokenCentresY[i];
    }
  }
}

void checkNextRed() { // function to check if the next token in the stack has dropped yet, dropping it if false.
  if (nextRed.occupied == false) {
    for (int i = 0; i < 42; i++) {
      if (i % 2 == 0 && tokens[i].state == 0) {
        tokens[i].y = tokens[i].y + 2;   
        if (tokens[i].y >= 750) nextRed.occupied = true;
      }
    }
  }
}

void checkNextYel() {
  if (nextYel.occupied == false) {
    for (int i = 0; i < 42; i++) {
      if (i % 2 == 1 && tokens[i].state == 0) {
        tokens[i].y = tokens[i].y + 2;
        if (tokens[i].y >= 750) nextYel.occupied = true;
      }
    }
  }
}

void playerTurn() { // Displays text indicator of which player's turn it is
  for (int i = 0; i < 42; i++) {
    if (tokens[i].state == 1 && tokens[i].colourRed == true) {
      textFont(playerFont);
      fill(255, 255, 255);

      text("Player 1's turn...", 300, 50);
    } else 
    if (tokens[i].state == 1 && tokens[i].colourRed == false) {
      textFont(playerFont);
      fill(255, 255, 255);
      text("Player 2's turn...", 800, 50);
    }
  }
}

void controlDisplay() { // text to instruct keyboard controls
  textFont(startFont);
  fill(255, 255, 255);
  textAlign(CENTER);
  text("Left = Move Left | Down = Drop Token | Right = Move Right", width/2, 850);
}

// Primary Functions

void setup() {
  size (1100, 900);
  startFont = createFont("Century Gothic", 30, true);
  idFont = createFont("Arial", 10, true);
  playerFont = createFont("Century Gothic", 20, true);
  winFont = createFont("Century Gothic", 40, true);
  slotXYArray();
  tokenXYArray();
  slotInit();
  tokenInit();
  nextYelInit();
  nextRedInit();
  redWin = false;
  yelWin = false;
  noWin = false;
  activeX = 550;
  activeY = 150;
  gameStart = false;
  lastDropped = 0;
  dd = 0;
  noDrop = false;
  autoPlay = false;
  screen = 0;
  load = 0;
  logo = loadImage("connect4.png");
  board = loadImage("c4board.png");
}

void draw() {
  if (screen == 0 && load < 400){
    loadingScreen();
  }
  else if (screen == 1){
    background(0,0,0);
    noFill();
    stroke(255,255,255);
    strokeWeight(2);
    rectMode(CENTER);
    rect(width/2, height/2, 400, 100);
    imageMode(CENTER);
    image(logo, width/2, height/2);
    textAlign(CENTER);
    text("Press Enter to start", width/2, 600);
  }
  else {
    image(board, width/2, height/2);
    //background(0,0,200);
    controlDisplay();
    playerTurn();
    translate(5,-5);
    drawGrid();
    translate(-5,5);
    drawGrid();
    translate(5,-5);
    drawTokensDeep();
    translate(-5,5);
    drawTokens();
    checkNextRed();
    checkNextYel();
    updateSlotStates();
    dropDistance();
    winDetect();
    startGame();
    auto();
  }
}

void keyPressed() {
  if (key == ENTER && screen == 1) screen = 2;
  if (keyCode == RIGHT && getActiveX() != 850) setActiveX(getActiveX() + 100);  
  if (keyCode == LEFT && getActiveX() != 250) setActiveX(getActiveX() - 100);
  if (keyCode == DOWN && gameStart == true) theDrop();
  if (key == 'n' && gameStart == false) { 
    gameStart = true; 
    tokens[0].state = 1; 
    nextRed.occupied = false;
  }
}

void loadingScreen(){
  background(0,0,0);
  rectMode(CORNER);
  noFill();
  stroke(255,255,255);
  strokeWeight(2);
  rect(350, 425, 400, 50); 
  fill(255,255,255);
  strokeWeight(1);
  rect(350, 425, load, 50);
  load = load + 1;
  textAlign(CENTER);
  text("Loading...", width/2, 400);
  if (screen == 0 && load == 400) screen = 1;  
}

void auto() { // function to allow the game to play itself, poorly, but quickly for testing purposes.
  if (autoPlay == true) {
    //frameRate(); // set speed of autoplay
    int randX = int(random(7));
    setActiveX(xs[randX]);
    theDrop();
  }
}

void winDetect() {
  for (int i = 0; i < 39; i++) { // horizontal red win
    if (slots[i].state == 1 && slots[i+1].state == 1 && slots[i+2].state == 1 && slots[i+3].state == 1) {
      for (int j = 0; j < 24; j++) {
        if (slots[i].slotID == possibleHoriWins[j]) {  
          redWin = true;
          strokeWeight(5);
          line(slots[i].x, slots[i].y, slots[i+3].x, slots[i+3].y);
          endGame();
        }
      }
    }
  }
  for (int i = 0; i < 21; i++) { // vertical red win
    if (slots[i].state == 1 && slots[i+7].state == 1 && slots[i+14].state == 1 && slots[i+21].state == 1) {
      redWin = true; 
      strokeWeight(5);
      line(slots[i].x, slots[i].y, slots[i+21].x, slots[i+21].y);
      endGame();
    }
  }
  for (int i = 0; i < 39; i++) { // horizontal yellow win
    if (slots[i].state == 2 && slots[i+1].state == 2 && slots[i+2].state == 2 && slots[i+3].state == 2) {
      for (int j = 0; j < 24; j++) {
        if (slots[i].slotID == possibleHoriWins[j]) {  
          yelWin = true;
          strokeWeight(5);
          line(slots[i].x, slots[i].y, slots[i+3].x, slots[i+3].y);
          endGame();
        }
      }
    }
  }
  for (int i = 0; i < 21; i++) { // vertical yellow win
    if (slots[i].state == 2 && slots[i+7].state == 2 && slots[i+14].state == 2 && slots[i+21].state == 2) {
      yelWin = true; 
      strokeWeight(5);
      line(slots[i].x, slots[i].y, slots[i+21].x, slots[i+21].y);
      endGame();
    }
  }
  for (int i = 21; i > 20 && i < 39; i++) { // diagonal red win bottom left to top right
    if (slots[i].state == 1 && slots[i-6].state == 1 && slots[i-12].state == 1 && slots[i-18].state == 1) {
      for (int j = 0; j < 12; j++) {
        if (slots[i].slotID == possibleDiagBLWins[j]) {
          redWin = true;
          strokeWeight(5);
          line(slots[i].x, slots[i].y, slots[i-18].x, slots[i-18].y);
          endGame();
        }
      }
    }
  }
  for (int i = 21; i > 20 && i < 39; i++) { // diagonal yellow win bottom left to top right
    if (slots[i].state == 2 && slots[i-6].state == 2 && slots[i-12].state == 2 && slots[i-18].state == 2) {
      for (int j = 0; j < 12; j++) {
        if (slots[i].slotID == possibleDiagBLWins[j]) {
          yelWin = true;
          strokeWeight(5);
          line(slots[i].x, slots[i].y, slots[i-18].x, slots[i-18].y);
          endGame();
        }
      }
    }
  }
  for (int i = 0; i >= 0 && i < 18; i++) { // diagonal red win top left to bottom right
    if (slots[i].state == 1 && slots[i+8].state == 1 && slots[i+16].state == 1 && slots[i+24].state == 1) {
      for (int j = 0; j < 12; j++) {
        if (slots[i].slotID == possibleDiagTLWins[j]) {
          redWin = true;
          strokeWeight(5);
          line(slots[i].x, slots[i].y, slots[i+24].x, slots[i+24].y);
          endGame();
        }
      }
    }
  }
  for (int i = 0; i >= 0 && i < 18; i++) { // diagonal yellow win top left to bottom right
    if (slots[i].state == 2 && slots[i+8].state == 2 && slots[i+16].state == 2 && slots[i+24].state == 2) {
      for (int j = 0; j < 12; j++) {
        if (slots[i].slotID == possibleDiagTLWins[j]) {
          yelWin = true;
          strokeWeight(5);
          line(slots[i].x, slots[i].y, slots[i+24].x, slots[i+24].y);
          endGame();
        }
      }
    }
  }
  if (slots[0].state != 0){
    for (int i = 1 ; i < 41 ; i++){
      if (slots[0+i].state != 0){
        noWin = true;
      }
    }
  }
}

void startGame() {  
  if (gameStart == false) {
    textAlign(CENTER, CENTER);
    textFont(startFont);
    fill(255, 255, 255);
    text("Press 'N' to start a new game!", width/2, 100);
  }
}

void endGame() {
  rectMode(CORNER);
  fill(0, 255, 0);
  stroke(255, 255, 255);
  strokeWeight(10);
  rect(width/3, 100, width/3, 70);
  textFont(winFont);
  textAlign(CENTER);
  if (redWin == true) {
    fill(255, 0, 0);
    text("Player 1 Wins!!!", width/2, 150);
  } else
    if (yelWin == true) {
      fill(255, 255, 0);  
      text("Player 2 Wins!!!", width/2, 150);
    } else
      if (noWin == true){
        fill(0,0,0);
        text("Gosh! A draw!", width/2, 150);
      }
  stop();
}

void theDrop() {

  for (int i = 0; i < 42; i++) {
    if (tokens[i].state == 1 && noDrop == false) {

      tokens[i].y = tokens[i].y + dd;

      tokens[i].state = 2;
      lastDropped = i;
      if (tokens[i].colourRed == true) {
        nextYel.occupied = false;
      } else nextRed.occupied = false;
    }
  }
  for (int i = 0; i < 42; i++) {
    if (tokens[i].state == 0 && tokens[i].tokenID == lastDropped + 1) {
      tokens[i].state = 1;
    }
  }
}

void dropDistance() { // calculates the correct slot (y coordinate) for the active token to occupy. If the top slot is occupied, noDrop = true and the token does not drop.
  noDrop = false;
  for (int i = 0; i < 7; i++) {
    if (activeX == xs[i] && slots[rowSix[i]].state == 0) { 
      dd = 600;
    } else
      if (activeX == xs[i] && slots[rowFive[i]].state == 0) { 
        dd = 500;
    } else
      if (activeX == xs[i] && slots[rowFour[i]].state == 0) { 
        dd = 400;
    } else
      if (activeX == xs[i] && slots[rowThree[i]].state == 0) { 
        dd = 300;
    } else
      if (activeX == xs[i] && slots[rowTwo[i]].state == 0) { 
        dd = 200;
    } else
      if (activeX == xs[i] && slots[rowOne[i]].state == 0) { 
        dd = 100;
    } else
      if (activeX == xs[i] && slots[rowOne[i]].state != 0) { 
        noDrop = true;
    }
  }
}

void updateSlotStates() { // checks the board status at the end of each turn (after move has been made)
  for (int i = 0; i < 42; i++) {
    if (slots[i].x == tokens[lastDropped].x && slots[i].y == tokens[lastDropped].y) {
      if (tokens[lastDropped].colourRed == true) {
        slots[i].state = 1;
      } else slots[i].state = 2;
    }
  }
}

int getActiveX() {
  return activeX;
}

void setActiveX(int x) {
  this.activeX = x;
}

void drawGrid() { //draw the game board using slot object methods
  for (int i = 0; i < 42; i++) {
    if (slots[i].state == 2) { // yellow occupancy
      fill(255, 255, 0);
    } else
      if (slots[i].state == 1) { // red occupancy
        fill(255, 0, 0);
      } else {
        fill(255, 255, 255); // empty slot
      }
    stroke(0, 0, 0);
    strokeWeight(1);
    ellipseMode(CENTER);
    ellipse(slots[i].x, slots[i].y, 100, 100);

    textFont(idFont);    
    fill(0, 0, 0);
    //text(slots[i].slotID, slots[i].x, slots[i].y); // slot ID labels (for test/build purposes)
  }
} 

void drawTokens() {
  for (int i = 0; i < 42; i++) {
    if (tokens[i].colourRed == true) {
      fill(255, 0, 0);
    } else {
      fill(255, 255, 0);
    }
    ellipseMode(CENTER);
    stroke(0, 0, 0);
    strokeWeight(1);
    ellipse(tokens[i].x, tokens[i].y, 100, 100); 
    
    if (tokens[i].state == 1) {
      tokens[i].x = activeX;
      tokens[i].y = activeY;
    }
    textFont(idFont);
    fill(0, 0, 0);
    //text(tokens[i].tokenID, tokens[i].x, tokens[i].y);
  }
}

void drawTokensDeep() {
  for (int i = 0; i < 42; i++) {
    if (tokens[i].colourRed == true) {
      fill(230, 0, 0);
    } else {
      fill(230, 230, 0);
    }
    ellipseMode(CENTER);
    stroke(0, 0, 0);
    strokeWeight(1);
    ellipse(tokens[i].x, tokens[i].y, 100, 100); 
    
    if (tokens[i].state == 1) {
      tokens[i].x = activeX;
      tokens[i].y = activeY;
    }
    textFont(idFont);
    fill(0, 0, 0);
    //text(tokens[i].tokenID, tokens[i].x, tokens[i].y);
  }
}

void slotXYArray() { 

  slotCentresX[0] = 250;
  slotCentresX[1] = 350;
  slotCentresX[2] = 450;
  slotCentresX[3] = 550;
  slotCentresX[4] = 650;
  slotCentresX[5] = 750;
  slotCentresX[6] = 850;
  slotCentresX[7] = 250;
  slotCentresX[8] = 350;
  slotCentresX[9] = 450;
  slotCentresX[10] = 550;
  slotCentresX[11] = 650;
  slotCentresX[12] = 750;
  slotCentresX[13] = 850;
  slotCentresX[14] = 250;
  slotCentresX[15] = 350;
  slotCentresX[16] = 450;
  slotCentresX[17] = 550;
  slotCentresX[18] = 650;
  slotCentresX[19] = 750;
  slotCentresX[20] = 850;
  slotCentresX[21] = 250;
  slotCentresX[22] = 350;
  slotCentresX[23] = 450;
  slotCentresX[24] = 550;
  slotCentresX[25] = 650;
  slotCentresX[26] = 750;
  slotCentresX[27] = 850;
  slotCentresX[28] = 250;
  slotCentresX[29] = 350;
  slotCentresX[30] = 450;
  slotCentresX[31] = 550;
  slotCentresX[32] = 650;
  slotCentresX[33] = 750;
  slotCentresX[34] = 850;
  slotCentresX[35] = 250;
  slotCentresX[36] = 350;
  slotCentresX[37] = 450;
  slotCentresX[38] = 550;
  slotCentresX[39] = 650;
  slotCentresX[40] = 750;
  slotCentresX[41] = 850;

  slotCentresY[0] = 250;
  slotCentresY[1] = 250;
  slotCentresY[2] = 250;
  slotCentresY[3] = 250;
  slotCentresY[4] = 250;
  slotCentresY[5] = 250;
  slotCentresY[6] = 250;
  slotCentresY[7] = 350;
  slotCentresY[8] = 350;
  slotCentresY[9] = 350;
  slotCentresY[10] = 350;
  slotCentresY[11] = 350;
  slotCentresY[12] = 350;
  slotCentresY[13] = 350;
  slotCentresY[14] = 450;
  slotCentresY[15] = 450;
  slotCentresY[16] = 450;
  slotCentresY[17] = 450;
  slotCentresY[18] = 450;
  slotCentresY[19] = 450;
  slotCentresY[20] = 450;
  slotCentresY[21] = 550;
  slotCentresY[22] = 550;
  slotCentresY[23] = 550;
  slotCentresY[24] = 550;
  slotCentresY[25] = 550;
  slotCentresY[26] = 550;
  slotCentresY[27] = 550;
  slotCentresY[28] = 650;
  slotCentresY[29] = 650;
  slotCentresY[30] = 650;
  slotCentresY[31] = 650;
  slotCentresY[32] = 650;
  slotCentresY[33] = 650;
  slotCentresY[34] = 650;
  slotCentresY[35] = 750;
  slotCentresY[36] = 750;
  slotCentresY[37] = 750;
  slotCentresY[38] = 750;
  slotCentresY[39] = 750;
  slotCentresY[40] = 750;
  slotCentresY[41] = 750;
}

void tokenXYArray() {
  for (int i = 0; i < 42; i++) {
    if (i % 2 == 0 || i == 0) {
      tokenCentresX[i] = 100;
    } else {
      tokenCentresX[i] = 1000;
    }
  }

  tokenCentresY[0] = 750;
  tokenCentresY[1] = 750;
  tokenCentresY[2] = 650;
  tokenCentresY[3] = 650;
  tokenCentresY[4] = 550;
  tokenCentresY[5] = 550;
  tokenCentresY[6] = 450;
  tokenCentresY[7] = 450;
  tokenCentresY[8] = 350;
  tokenCentresY[9] = 350;
  tokenCentresY[10] = 250;
  tokenCentresY[11] = 250;
  tokenCentresY[12] = 150;
  tokenCentresY[13] = 150;
  tokenCentresY[14] = 50;
  tokenCentresY[15] = 50;
  tokenCentresY[16] = -50;
  tokenCentresY[17] = -50;
  tokenCentresY[18] = -150;
  tokenCentresY[19] = -150;
  tokenCentresY[20] = -250;
  tokenCentresY[21] = -250;
  tokenCentresY[22] = -350;
  tokenCentresY[23] = -350;
  tokenCentresY[24] = -450;
  tokenCentresY[25] = -450;
  tokenCentresY[26] = -550;
  tokenCentresY[27] = -550;
  tokenCentresY[28] = -650;
  tokenCentresY[29] = -650;
  tokenCentresY[30] = -750;
  tokenCentresY[31] = -750;
  tokenCentresY[32] = -850;
  tokenCentresY[33] = -850;
  tokenCentresY[34] = -950;
  tokenCentresY[35] = -950;
  tokenCentresY[36] = -1050;
  tokenCentresY[37] = -1050;
  tokenCentresY[38] = -1050;
  tokenCentresY[39] = -1050;
  tokenCentresY[40] = -1150;
  tokenCentresY[41] = -1150;
}