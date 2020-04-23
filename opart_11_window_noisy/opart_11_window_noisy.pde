void setup() {   
  size(640, 640);
  background(0);
  frameRate(30);
  smooth(4);
  pixelDensity(2);
  background(0);
  
  //noLoop();
}

 
float N = 38.;
float anim=0;
void draw(){
  anim+=0.01;
  //blendMode(DIFFERENCE);
  background(0);
 
  translate(width/2, height/2);
  scale(1.9);
  
  fill(255);  
  //drawGrid(2);
  
 
  float s= width ;
  for (int c=0; c<17; c++){
    noStroke();
    //scale(0.8);
    //rotate(0.01);
    scale(0.8);
    fill(0);    
    rect(-s/2, -s/2, s, s);
    
    fill(255, 80); 
    
    drawGrid(9);
  }
   
}


//void drawWnd(){
//  pushMatrix();
  
//  fill(0);
//  float s= width/2.7;
//  rect(-s/2, -s/2, s, s);
//  scale(0.3);
//  drawGrid();
  
//  popMatrix();
//}
 
void drawGrid(float N){
  
  
  pushMatrix();
  float spacer=width/N;
  float arrowSize=spacer*0.47;
  
  
  
  translate(spacer/2., spacer/2);
  for (float x=-width/2, cx=0; x<width/2; x+=spacer, cx++){
    for (float y=-width/2, cy=0; y<width/2; y+=spacer, cy++){
      pushMatrix();
      translate(x, y);
      rotate(1*PI*((x+y)/width));
      //rotate(PI/19);
      int c=255;
      //if ( 1+(cx%3+cy%7) % 2==0)
      //    c=0;
          
      //if ( cx%2==0)
      //    c=0;
          
       
      fill(c);
      drawBox(arrowSize);
      //stroke(255);
      //strokeWeight(7);
      //drawArrow(arrowSize);
      popMatrix();
    }
  }
  popMatrix();
  
  //
}

void drawBox(float size){
  pushMatrix();
  //translate(-size/2,-size/2);  
  //rect(0,0, size, size);
  fill(255,0,0);
  ellipse(0,-anim, size, size);
  
  fill(0,255,255);
  ellipse(0,anim, size, size);
  fill(255);
  ellipse(0,0, size, size);
  popMatrix();
}

void drawBoxBox(float size){
  pushMatrix();
  translate(-size/2,-size/2);  
  noStroke();
  //rect(0,0, size, size);
  drawGrid(3);
  popMatrix();
  
  //pushMatrix();
  //scale(0.4);
  //float off = size/2;
  //translate(-off, -off);
  //drawBox(size);
  //translate(0, off*2);
  //drawBox(size);
  //translate(off*2,0);
  //drawBox(size);
  //translate(0,-off*2);
  //drawBox(size);
  
  //popMatrix();
}

void drawArrow(float size){
  pushMatrix();
  translate(-size/2,-size/2);
  line(0,0,size, size);
  line(0,0,size, -size);  
  popMatrix();
}

void drawArrowSharp(float size){
  pushMatrix();
  translate(-size/2,-size/2);
  
  //noStroke();
  //fill(180, 0, 50);
  //rect(0,0, size, size);

  float sm=size/5;
  noStroke();
  beginShape();
  
  vertex(0,0);
  vertex(size, 0);
  vertex(sm, sm);
  vertex(0, size);
  endShape();
  

  popMatrix();
  
}

  

 
void mouseReleased() {
  println(anim);
  saveFrame("/Users/artem/work/creative-code/opart_11/opart__####.png");
}
