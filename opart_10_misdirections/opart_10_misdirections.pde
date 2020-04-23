void setup() {   
  size(640, 640);
  background(0);
  frameRate(30);
  smooth(4);
  pixelDensity(2);
  background(0);
  
  //noLoop();
}

 
float N = 28.;
void draw(){
  
  background(0);
  
  float spacer=width/N;
  float arrowSize=spacer*1.;
  translate(width/2, height/2);
  scale(0.9);
  
  translate(spacer/2., spacer/2);
  for (float x=-width/2; x<=width/2; x+=spacer){
    for (float y=-width/2; y<width/2; y+=spacer){
      pushMatrix();
      translate(x, y);
      rotate(3*PI*((x*2+y)/width));
      
 
 
      drawBox(arrowSize);
      fill(255);
      drawArrowSharp(arrowSize);
      rotate(PI);
      //fill(0,0,0);
      //drawArrowSharp(arrowSize);
      
      //fill(0);  
      //translate(-3, 0);
      //drawDot(arrowSize);
      popMatrix();
    }
  }
  
  //
}

void drawArrow(float size){
  line(0,0,size, size);
  line(0,0,size, -size);  
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

void drawBox(float size){
  pushMatrix();
  translate(-size/2,-size/2);
  
  noStroke();
  fill(180, 0, 50);
  rect(0,0, size, size);

  popMatrix();
}

void drawDot(float size){
  noStroke();
   
 
  
  //fill(0);
  ellipse(0,0, size, size);
}

void drawArrowDots(float size){
  line(0,0,size, size);
  line(0,0,size, -size);
  //noStroke();
  //fill(255);
  //float r=size*0.6;
  //float rs=r/1.2;
  //ellipse(0,0, r, r);
  //ellipse(0,size, rs, rs);
  //ellipse(size, 0, rs, rs);
    
}

 
void mouseReleased() {
  
  saveFrame("/Users/artem/work/creative-code/opart_10/opart__####.png");
}
