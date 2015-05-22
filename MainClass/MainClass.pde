import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer player1;
AudioPlayer player2;
AudioMetaData meta;
BeatDetect beat;
int  r = 200;
float rad = 100;
enum ColorScheme{
  BLUE, GREEN, YELLOW, PINK
};

ColorScheme colorFlag = BLUE;

void setup()
{
  size(displayWidth, displayHeight);
  //size(600, 400);
  minim = new Minim(this);
  player1 = minim.loadFile("RobinSchulz-Headlights.mp3");
  player2 = minim.loadFile("MilkyChance-FlashedJunkMind.mp3");
  
  meta = player1.getMetaData();
  beat = new BeatDetect();
  //player1.loop();
  player1.play();
  background(-1);
  noCursor();
}
 
void draw()
{ 
  float t = map(mouseX, 0, width, 0, 1);
  beat.detect(player1.mix);
  if(colorFlag == GREEN){
    fill(#444444, 20);
  }
  else if(colorFlag == YELLOW){
    fill(#223300, 20);
  }
  else if(colorFlag == PINK){
    fill(#112210, 20);
  }
  else {
    fill(#7B9DFE, 20);
  }
  
  
  noStroke();
  rect(0, 0, width, height);
  translate(width/2, height/2);
  //noFill();
  fill(#FFFFFF, 30);
  if (beat.isOnset()) {
    rad = rad*0.9;
  }
  else {
    rad = 100;
  }
  ellipse(0, 0, 3*rad, 3*rad);
  stroke(#FFFFFF, 50);
  int bsize = player1.bufferSize();
  
  float x, y, x2, y2;
  for (int i = 0; i < bsize - 1; i+=5)
  {
    x = (r)*cos(i*2*PI/bsize);
    y = (r)*sin(i*2*PI/bsize);
    x2 = (r + player1.left.get(i)*100)*cos(i*2*PI/bsize);
    y2 = (r + player1.left.get(i)*100)*sin(i*2*PI/bsize);
    line(x, y, x2, y2);
  }
  beginShape();
  noFill();
  stroke(-1, 50);
  for (int i = 0; i < bsize; i+=30)
  {
    x2 = (r + player1.left.get(i)*100)*cos(i*2*PI/bsize);
    y2 = (r + player1.left.get(i)*100)*sin(i*2*PI/bsize);
    vertex(x2, y2);
    pushStyle();
    stroke(-1);
    strokeWeight(4);
    point(x2, y2);
    popStyle();
  }
  endShape();
   if (timeFlag) showTime();
   if (nameFlag) {
     fill(#FFFFFF, 50);
     showName();
   }
  
  
}
 
 
void showTime() {
  int time =  meta.length();
  textSize(50);
  textAlign(CENTER);
  text( (int)(time/1000-millis()/1000)/60 + ":"+ (time/1000-millis()/1000)%60, -7, 21);
}

void showName() {
  fill(#7B9DFE, 10);
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


 
boolean timeFlag =false;
boolean nameFlag =false;
void mousePressed() {
  if (dist(mouseX, mouseY, width/2, height/2)<150) {
    timeFlag =!timeFlag;
  }
  nameFlag = !nameFlag;
}
 
boolean sketchFullScreen() {
  return true;
}
 
void keyPressed() {
  if(key==' ')exit();
  if(key=='s')saveFrame("###.jpeg");
  if(key=='1')colorFlag = BLUE;
  if(key=='2')colorFlag = GREEN;
  if(key=='3')colorFlag = YELLOW;
  if(key=='4')colorFlag = PINK;
}
