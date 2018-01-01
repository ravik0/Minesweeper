import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
void setup () {
  size(400, 400);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }
  bombs = new ArrayList<MSButton>();
  for (int i = 0; i < 50; i++) {
    setBombs();
  }
}
public void setBombs() {
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  if (bombs.contains(buttons[row][col])) {
    setBombs();
  } 
  else {
    bombs.add(buttons[row][col]);
  }
}

public void draw () {
  background( 0 );
  if (isWon())
    displayWinningMessage();
}
public boolean isWon() {
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      if (!bombs.contains(buttons[i][j]) && buttons[i][j].isClicked() == false) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage() {
  noLoop();
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("O");
  buttons[9][8].setLabel("U");
  buttons[9][9].setLabel(" ");
  buttons[9][10].setLabel("L");
  buttons[9][11].setLabel("O");
  buttons[9][12].setLabel("S");
  buttons[9][13].setLabel("E");
  for (int i = 6; i < 14; i++) {
    buttons[9][i].setColor(#64F774);
  }
}
public void displayWinningMessage() {
  noLoop();
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("O");
  buttons[9][8].setLabel("U");
  buttons[9][9].setLabel(" ");
  buttons[9][10].setLabel("W");
  buttons[9][11].setLabel("I");
  buttons[9][12].setLabel("N");
  buttons[9][13].setLabel("!");
  for (int i = 6; i < 14; i++) {
    buttons[9][i].setColor(#64F774);
  }
}

public class MSButton {
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;
  private color textColor = 0;
  public MSButton ( int rr, int cc ) {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked() {
    return marked;
  }
  public boolean isClicked() {
    return clicked;
  }
  public void setColor(color tc) {
    textColor = tc;
  }
  // called by manager

  public void mousePressed () {
    clicked = true;
    if (keyPressed == true) {
      marked = !marked;
      if (!marked) {
        clicked = false;
      }
    }
    if (bombs.contains(this)) {
      displayLosingMessage();
      for (int i = 0; i < bombs.size(); i++) {
        if (!bombs.get(i).isClicked()) {
          bombs.get(i).mousePressed();
        }
      }
    } 
    else if (countBombs(r, c) > 0) {
      setLabel(str(countBombs(r, c)));
    } 
    else {
      for (int row = r-1; row < r+2; row++) {
        for (int col = c-1; col < c+2; col++) {
          if (isValid(row, col) && !buttons[row][col].isClicked()) {
            buttons[row][col].mousePressed();
          }
        }
      }
    }
  }

  public void draw () {  
    if (marked)
      fill(0);
    else if (clicked && bombs.contains(this)) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill(100);
    rect(x, y, width, height);
    fill(textColor);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel) {
    label = newLabel;
  }
  public boolean isValid(int r, int c) {
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
      return true;
    } 
    else {
      return false;
    }
  }
  public int countBombs(int row, int col) {
    int numBombs = 0;
    for (int i = row-1; i < row+2; i++) {
      for (int j = col-1; j < col+2; j++) {
        if (isValid(i, j) && bombs.contains(buttons[i][j])) {
          numBombs+=1;
        }
      }
    }
    return numBombs;
  }
}