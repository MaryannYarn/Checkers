
color boxes;
color red;
color black;
int[][] pieces; // 0 is no piece, 1 is black piece, 2 is red piece
int move; //0 if it's red's turn but the player hasn't moved yet, 1 if red has picked, 2 if black move
int[][] blackPieces;
int selectedx;
int selectedy;
color highlight;
int[][] pMoves;
boolean updatedmv;
int redPieces; 
int boxSize;

void setup() {
  size(800, 800);
  redPieces=12;
  boxes = color(140, 100, 70);
  red= color(255, 0, 0);
  black= color(0, 0, 0);
  background(99, 69, 45);
  highlight = color(154, 224, 237);
  boxSize = 10;
  fill(boxes);
  squares();
  move =0;
  pieces=new int[8][8];
  for (int x =0; x<8; x++) {
    if (x%2==0) {
      for (int y =0; y<3; y++) {
        if (y%2==0) {
          fill(black);
          ellipse((100*x)+50, (100*y)+50, 90, 90);
          pieces[x][y]=1;
        } else {
          pieces[x][y]=0;
        }
      }
      for (int y =5; y<8; y++) {
        if (y%2==0) {
          fill(red);
          ellipse((100*x)+50, (100*y)+50, 90, 90);
          pieces[x][y]=2;
        } else {
          pieces[x][y]=0;
        }
      }
    }
    if (x%2==1) {
      for (int y =0; y<3; y++) {
        if (y%2==1) {
          fill(black);
          ellipse((x*100)+50, (y*100)+50, 90, 90);
          pieces[x][y]=1;
        } else {
          pieces[x][y]=0;
        }
      }
      for (int y =5; y<8; y++) {
        if (y%2==1) {
          fill(red);
          ellipse((x*100)+50, (y*100)+50, 90, 90);
          pieces[x][y]=2;
        } else {
          pieces[x][y]=0;
        }
      }
    }
  }
  blackPieces = new int[12][2];
  int counter = 0;
  for (int r=0; r<7; r++) {
    for (int c=0; c<7; c++) {
      if (pieces[r][c]==1) {
        blackPieces[counter][0] = r;
        blackPieces[counter][1] = c;
        counter+=1;
      }
    }
  }
}

void draw() {
  delay(50);
  clear();
  if (move==3) {
    delay(5000);
    exit();
  }
  if (blackPieces.length == 0) {
    background(0, 255, 45);
    move=3;
    return;
  }
  if (redPieces == 0) {
    background(255, 0, 60);
    move=3;
    return;
  }
  clear();
  background(99, 69, 45);
  squares();
  circles();
  if (move == 1) {
    if (!updatedmv) {
      pMoves=possibleMoves(1);
    } else {
      if (pMoves.length==0) {
        move =0;
        return;
      }
      fill(highlight);
      for (int[] coords : pMoves) {
        rect(coords[0]*100, coords[1]*100, 100, 100);
      }
    }
  }
  if (move==2) {
    delay(50);
    int counter = 0;
    for (int r=0; r<=7; r++) {
      for (int c=0; c<=7; c++) {
        if (pieces[r][c]==1) {
          blackPieces[counter][0] = r;
          blackPieces[counter][1] = c;
          counter+=1;
        }
      }
    }
    int randomint=(int)(random(blackPieces.length));
    int[] coords = blackPieces[randomint];
    selectedx=coords[0];
    selectedy=coords[1];
    int[][] blackMoves=possibleMoves(2);
    //delay(200);
    if (blackMoves.length != 0) {
      int[] chosenMove=blackMoves[(int)(random(blackMoves.length))];
      pieces[coords[0]][coords[1]]=0;
      pieces[chosenMove[0]][chosenMove[1]]=1;
      if (abs(selectedx-chosenMove[0])==2) {
        int distx=chosenMove[0]-selectedx;
        int disty=chosenMove[1]-selectedy;
        pieces[(selectedx+(distx/2))][(selectedy+(disty/2))]=0;
        redPieces--;
      }
      blackPieces[randomint][0]=chosenMove[0];
      blackPieces[randomint][1]=chosenMove[1];
      move = 0;
    }
  }
}

void mouseClicked() {
  if (move == 0) {
    println(mouseX+","+mouseY);
    int tempx=(mouseX-mouseX%100)/100;
    int tempy=(mouseY-mouseY%100)/100;
    if (pieces[tempx][tempy]==2) {
      selectedx=tempx;
      selectedy=tempy;
      move=1;
      updatedmv=false;
    }
  } else if (move == 1) {
    println(mouseX+","+mouseY);
    int tempx=(mouseX-mouseX%100)/100;
    int tempy=(mouseY-mouseY%100)/100;
    for (int[] coords : pMoves) {
      if (coords[0]==tempx&&coords[1]==tempy) {
        if (abs(selectedx-tempx)==2) {
          int distx=tempx-selectedx;
          int disty=tempy-selectedy;
          pieces[(selectedx+(distx/2))][(selectedy+(disty/2))]=0;
          blackPieces=removePair((selectedx+(distx/2)), (selectedy+(disty/2)), blackPieces);
        }
        pieces[selectedx][selectedy]=0;
        pieces[tempx][tempy]=2;
        move =2;
        delay(200);
      }
    }
  }
}

void circles() {
  for (int row=0; row<8; row++) {
    for (int col=0; col<8; col++) {
      if (pieces[row][col] == 1) {
        fill(black);
        ellipse((row*100)+50, (col*100)+50, 90, 90);
      } else if (pieces[row][col] == 2) {
        fill(red);
        ellipse((row*100)+50, (col*100)+50, 90, 90);
      }
    }
  }
}


void squares() {
  fill(boxes);
  for (int x =0; x<8; x++) {
    if (x%2==0) {
      for (int y =0; y<8; y++)
        if (y%2==0) {
          rect(x*100, y*100, 100, 100);
        }
    }
    if (x%2==1) {
      for (int y =0; y<8; y++)
        if (y%2==1) {
          rect(x*100, y*100, 100, 100);
        }
    }
  }
}

int[][] possibleMoves(int oppColor) {
  fill(highlight);
  int[][] returnList = new int[4][2];
  for (int[] ahh : returnList) {
    ahh[0]=10;
    ahh[1]=10;
  }
  int x=selectedx;
  int y=selectedy;
  println("Input:"+x+","+y);

  for (int i =0; i <4; i++) {
    if (i == 0) {
      if (inBounds(x, y, 1, 1)) {
        if (pieces[x+1][y+1] == oppColor) {
          if (inBounds(x, y, 2, 2)) {
            if (pieces[x+2][y+2] == 0) {
              if (x <=5 && y<=5) {
                returnList[i][0]=x+2;
                returnList[i][1]=y+2;
              }
            }
          }
        } else if (pieces[x+1][y+1] == 0) {
          returnList[i][0]=x+1;
          returnList[i][1]=y+1;
        }
      }
    } else if (i == 1) {
      if (inBounds(x, y, -1, 1)) {
        if (pieces[x-1][y+1] == oppColor) {
          if (inBounds(x, y, -2, 2)) {
            if (pieces[x-2][y+2] == 0) {
              returnList[i][0]=x-2;
              returnList[i][1]=y+2;
            }
          }
        } else if (pieces[x-1][y+1] == 0) {
          returnList[i][0]=x-1;
          returnList[i][1]=y+1;
        }
      }
    } else if (i == 2) {
      if (inBounds(x, y, -1, -1)) {
        if (pieces[x-1][y-1] == oppColor) {
          if (inBounds(x, y, -2, -2)) {
            if (pieces[x-2][y-2] == 0) {
              returnList[i][0]=x-2; 
              returnList[i][1]=y-2;
            }
          }
        } else if (pieces[x-1][y-1] == 0) {
          returnList[i][0]=x-1;
          returnList[i][1]=y-1;
        }
      }
    } else if (i == 3) {
      if (inBounds(x, y, 1, -1)) {
        if (pieces[x+1][y-1] == oppColor) {
          if (inBounds(x, y, 2, -2)) {
            if (pieces[x+2][y-2] == 0) {
              returnList[i][0]=x+2; 
              returnList[i][1]=y-2;
            }
          }
        } else if (pieces[x+1][y-1] == 0) {
          returnList[i][0]=x+1;
          returnList[i][1]=y-1;
        }
      }
    }
  }
  for (int num = 0; num<4; num++) {
    for (int i=0; i<returnList.length; i++) {
      if (returnList[i][0]>7 ||returnList[i][1]>7||returnList[i][0]<0||returnList[i][1]<0) {
        returnList=removePair(i, returnList);
      }
    }
  }
  if (move!=2) {
    for (int[] coords : returnList) {
      println("Coords:"+coords[0]+","+coords[1]);
      rect(coords[0]*100, coords[1]*100, 100, 100);
    }
  }
  updatedmv=true;
  return returnList;
}


boolean inBounds(int currx, int curry, int modx, int mody) {
  return ((currx+modx >= 0) && (currx+modx <=7) && (curry+mody >= 0) && (curry+mody <=7));
}

int[][] removePair(int index, int[][] input) {
  int[][] toReturn = new int[input.length-1][2];
  for (int i =0; i<index; i++) {
    toReturn[i]=input[i];
  }
  for (int i =index; i<input.length -1; i++) {
    toReturn[i]=input[i+1];
  }
  return toReturn;
}
int[][] removePair(int x, int y, int[][] input) {
  if (input.length == 1) {
    return (new int[0][0]);
  }
  int[][] toReturn = new int[input.length-1][2];
  int index = 0;
  for (int i=0; i<input.length; i++) {
    if (input[i][0]==x && input[i][1]==y)
      index = i;
  }
  //index-=1;
  if (input.length == 2) {
    if (index==0) {
      toReturn[0]=input[1];
    } else {
      toReturn[0]=input[0];
    }
    return(toReturn);
  }
  for (int i =0; i<index; i++) {
    toReturn[i]=input[i];
  }
  for (int i =index; i<input.length -1; i++) {
    toReturn[i]=input[i+1];
  }
  return toReturn;
}
