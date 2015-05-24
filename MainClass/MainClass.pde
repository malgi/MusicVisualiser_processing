import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer player1;
AudioPlayer player2;
AudioPlayer player3;
AudioPlayer player;
AudioMetaData meta;
BeatDetect beat;
int  r = 270;
int rDef = 270;
float rad = 100;
float radDef = 100;
PFont font1;
boolean pause = false;

int song = 0;
int colorFlag = 1;
int visualFlag = 0;

// visualization properties
int pointSize = 4;
int density = 5;
float thickness = 30;
int step = 10;

void setup()
{
  size(displayWidth, displayHeight);
  //size(600, 400);
  minim = new Minim(this);
  player1 = minim.loadFile("RobinSchulz-Headlights.mp3");
  player2 = minim.loadFile("MilkyChance-FlashedJunkMind.mp3");
  player3 = minim.loadFile("TheHangingTree-RebelRemix.mp3");
  
  player = player1;
  
  //loading and setting the font
  font1 = loadFont("ARBONNIE-150.vlw");
  textFont(font1);
  
  meta = player.getMetaData();
  beat = new BeatDetect();
  //player.loop();
  player.play();
  background(-1);
  noCursor();
}
 
void draw()
{ 
  //choosing music
  if (song == 2){
    song = 0;
    player.pause();
    player.rewind();
    player = player2;
    
    meta = player.getMetaData();
    beat = new BeatDetect();
    //player.loop();    
    player.play();   
  }
  else if (song == 3){
    song = 0;
    player.pause();
    player = player3;
    
    meta = player.getMetaData();
    beat = new BeatDetect();
    //player.loop();
    //player.rewind();
    player.play();  
  }
  else if (song == 1) {
    song = 0;
    player.pause();
    player = player1;
    
    meta = player.getMetaData();
    beat = new BeatDetect();
    //player.loop();
    //player.rewind();
    player.play();  
  }
  
  if (pause){
    player.pause();
  }
  
  if (!pause && !(player.isPlaying())){
    player.rewind();
    player.play();
  }
  
  //menu
  if (nameFlag){
    pushMatrix();
    fill(#FFFFFF, 30);
    textSize(50);
    textAlign(LEFT);
    noStroke();
    
    if(dist(mouseX, mouseY, 50, height/2 - 180)<100){
      fill(#FFFFFF);
    }
    translate(50, height/2 - 180);
    ellipse(0, 0, 30, 30);
      pushMatrix();
      translate(30, 15);
      text("Song 1", 0, 0);
      popMatrix();  
      fill(#FFFFFF, 30);
      
    if(dist(mouseX, mouseY, 50, height/2 - 80)<100){
      fill(#FFFFFF);
    }
    translate(0, 100);
    ellipse(0, 0, 30, 30);
       pushMatrix();
      translate(30, 15);
      text("Song 2", 0, 0);
      popMatrix();
      fill(#FFFFFF, 30);
      
    if(dist(mouseX, mouseY, 50, height/2 + 20)<100){
      fill(#FFFFFF);
    }
    translate(0, 100);
    ellipse(0, 0, 30, 30);
      pushMatrix();
      translate(30, 15);
      text("Song 3", 0, 0);
      popMatrix();
      fill(#FFFFFF, 30);
    popMatrix();
  }
  
  //choosing visualization style
  
  if (visualFlag == 0){
    pointSize = 4;
    density = 5;
    thickness = 30;
    step = 10;
    rDef = 270;
    radDef = 100;
    
  }else if(visualFlag == 1){
    pointSize = 13;
    density = 1;
    thickness = 30;
    step = 10;
    rDef = 270;
    radDef = 100;
  
  }else{
    pointSize = 4;
    density = 10;
    thickness = 500;
    step = 1;
    rDef = 270;
    radDef = 100;
  
  }
  
  
  pushMatrix();
  float t = map(mouseX, 0, width, 0, 1);
  beat.detect(player.mix);
  if(colorFlag == 2){
    fill(#AADD39, 20); //green
  }
  else if(colorFlag == 3){ //pink
    fill(#DA3C5E, 20);
  }
  else if(colorFlag == 4){ //yellow
    fill(#EAAF2E, 20);
  }
  else {
    fill(#1693A5, 20);  //blue
  }
  
  
  noStroke();
  rect(0, 0, width, height);
  translate(width/2, height/2);
  fill(#FFFFFF, 30);
  if (beat.isOnset()) {
    rad = rad*0.8;
    r = 310;
  }
  else {
    rad = radDef;
    r = rDef;
  }
  
  ellipse(0, 0, 3*rad, 3*rad);
  stroke(#FFFFFF, thickness);
  int bsize = player.bufferSize();
  
  float x, y, x2, y2;
  for (int i = 0; i < bsize - 1; i+= density)
  {
    x = (r)*cos(i*2*PI/bsize);
    y = (r)*sin(i*2*PI/bsize);
    x2 = (r + player.left.get(i)*100)*cos(i*2*PI/bsize);
    y2 = (r + player.left.get(i)*100)*sin(i*2*PI/bsize);
    line(x, y, x2, y2);
  }
  beginShape();
  noFill();
  stroke(-1, 50);
  for (int i = 0; i < bsize; i+= step)
  {
    x2 = (r + player.left.get(i)*100)*cos(i*2*PI/bsize);
    y2 = (r + player.left.get(i)*100)*sin(i*2*PI/bsize);
    vertex(x2, y2);
    pushStyle();
    stroke(-1);
    strokeWeight(pointSize);
    point(x2, y2);
    popStyle();
  }
  endShape();
  
  
   if (timeFlag) showTime();
   if (nameFlag) {
 
     translate(0, -400);
     showName();
     cursor();
   }
   else{
     noCursor();
   }
   popMatrix();
   showAuthor();   
}
 
 
void showTime() {
  int time =  meta.length();
  textSize(50);
  textAlign(CENTER);
  text( (int)(time/1000-millis()/1000)/60 + ":"+ (time/1000-millis()/1000)%60, -7, 21);
}

void showName() {
  fill(#FFFFFF, 30);
  String title =  meta.title();
  if (title == null){
      title = "Unknown title";
  }  
  String author =  meta.author();
  if (title == null){
      title = "Unknown interpret";
  }
  textSize(150);
  textAlign(CENTER);
  text(author + " - " + title, -7, 21 );
  //fill(#7B9DFE, 30);
}

void showAuthor(){
  fill(#FFFFFF, 30);
  textSize(50);
  textAlign(RIGHT);
  text("Created by Markéta Hanušová", width-20, height-20);
}
 
boolean timeFlag =false;
boolean nameFlag =false;
void mousePressed() {
  if (dist(mouseX, mouseY, width/2, height/2)<150) {
    timeFlag =!timeFlag;
  }
  if (!(dist(mouseX, mouseY, 50, height/2 - 180)<100) && !(dist(mouseX, mouseY, 50, height/2 - 80)<100) && !(dist(mouseX, mouseY, 50, height/2 + 20)<100) && !(dist(mouseX, mouseY, width/2, height/2)<150) ){
    nameFlag = !nameFlag;
  }
  if(dist(mouseX, mouseY, 50, height/2 - 180)<100){  //song1
        song = 1;
   }
  if(dist(mouseX, mouseY, 50, height/2 - 80)<100){
        song = 2;
   }
  if(dist(mouseX, mouseY, 50, height/2 + 20)<100){
        song = 3;
   }
}
 
boolean sketchFullScreen() {
  return true;
}
 
void keyPressed() {
  if(key==' ')exit();
  if(key=='p')pause = !pause;
  if(key=='1')colorFlag = 1; //blue
  if(key=='2')colorFlag = 2; //green
  if(key=='3')colorFlag = 3; //yellow
  if(key=='4')colorFlag = 4; //pink
  if (key == CODED) {
      if (keyCode == UP) {
        if (visualFlag < 2){
          visualFlag++;
        } 
         else{
           visualFlag = 0;
         }
      } 
  }
  if (key == CODED) {
      if (keyCode == DOWN){
        if (visualFlag > 0){
          visualFlag--;
        }
         else{
          visualFlag = 2;
        }
      }
  }
}

