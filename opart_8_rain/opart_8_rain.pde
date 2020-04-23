

void setup() {   
  //size(320, 320);
  
  size(640, 640);
  background(0);
  frameRate(30);
  smooth(4);
  pixelDensity(2);
  //strokeWeight(1);
  
  //textSize(20);

  background(0);

}
 
 
int alpha=220;

color c1=color(0);
color c2=color(255);  
color c4=color(0,210,255,alpha);
color c3=color(255,0,0,alpha);
 
int threads=118;
void draw_(){
   
  float droplets=100;
  //droplets=(int)k;
  
  float dt=width/threads;
  background(0);
  noStroke();
  
  float segmentLen = width*2 /droplets;
  pushMatrix();  
  //rotate(PI/2.5);
  rotate(PI/2);
 
  
  translate(0, width);
  for (float x=0, n=0; x<width*2; x+=dt, n++){
    pushMatrix();  
    float dv=  -((int)n % 4) * segmentLen;
    dv -=  segmentLen * sin(radians(n))/2;
    translate(dv, -x);
     
   
    //fill(255);
    //drawThread(width*2, droplets, dt);
     
    if (n%2==1){
      fill(255);
      drawThread(width*2, 1, dt);
    }
    
    //if (n%4==0 || n%4==2){
    //  fill(0);
    //  drawThread(width*2, 1, dt);
    //}
    popMatrix();
  }
  

  //rotate(PI/2);
  
  popMatrix();
  
  pushMatrix();  
  //rotate(PI/20);
  drawClouds(dt);
  
  
  popMatrix();
  
  noFill();
  strokeWeight(width/20);
  rect(0,0,width, height);

}

void draw(){
  pushMatrix(); 
  background(0);
  noStroke();
  float dt=width/threads;
  translate(width/2, height/1.2);
  rotate(-PI/2.4);
  drawCloudsRange(dt, -600, height+200, 40);
  rotate(PI/2.4);
  translate(-width/2, -height/2);
  drawCloudsRange(dt, -400, 52, 25);
  popMatrix();
  
  noFill();
  stroke(255);
  strokeWeight(width/20);
  rect(0,0,width, height);
}

void drawCloudsRange(float thikness, float from, float to, float ampl){
   
  boolean black=false;
  for (float y=from,  c=0; y<to; y+=thikness, c++){      
    color clr=color(255);
    if(black) clr=color(0);
    drawCloudLine(thikness, clr, y, ampl);
    black = !black;    
  }

}

 
float anim=7;
void drawClouds(float thikness){
  anim+=0.1;
  boolean black=false;
  for (float y=-200,  c=0; y<height*1.5; y+=thikness, c++){
    if (y<height/2.86){
      blendMode(BLEND);
      drawCloudLine(thikness, color(0), y, 20);
    }
     blendMode(DIFFERENCE);
     
    //translate(y/40.,0);
    //if (y>height/2.86){
    //  if(c%2==0){
    //    //
    //    drawCloudLine(thikness, color(255), y);
    //  }
    //}
    //else{
    //  blendMode(BLEND);
      color clr=color(200);
      if(black) clr=color(0);
      drawCloudLine(thikness, clr, y, 20);
      black = !black;
    //}
  }
  blendMode(BLEND);
  //blendMode(EXCLUSION);
  //for (float y=height/2.66; y<height; y+=thikness*2){
  //  color c=color(255);
  //  //if(black) c=color(0);
  //  drawCloudLine(thikness, c, y);
  //  //black = !black;
  //}
  // blendMode(BLEND);
  noFill();
  
   
}

void drawCloudLine(float thikness, color c, float off, float ampl){
  strokeWeight(thikness);
  stroke(c);
  beginShape();
  noFill();
  for(int k=-200; k<width+200; k+=width/40.){
    curveVertex(k, off + ampl * sin( radians(k*2.)));
  }
  endShape();
}



void drawThread(float len, float snaps, float thikness){
  float d = len/snaps;  
  for (float x=0; x<len; x+=d*2){
    rect(x, -thikness/2, d, thikness);
  }

}

void mouseReleased() {
   
  println(anim+" ");
  saveFrame("/Users/artem/work/creative-code/opart_8_rain/opart__####.png");
}
 

 
