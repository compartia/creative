
void setup() {
    size(640, 640);
    background(0);
    frameRate(30);
    smooth(8);
    pixelDensity(2); //retina
    background(0);
}


float  anim = 0;
void draw(){
    anim += 0.05;
    //noLoop();
    background(0);

    translate(width / 2, height / 2);

    scale(0.4);
   // rotate(PI / 4);
    drawHyps();

    rotate(PI / 2);
    drawHyps();

    rotate(PI);
    drawHyps();

    rotate(-PI / 2);
    drawHyps();


}
void drawHyperbola(float x, float time){
  
  beginShape();
  for (float velocity = 0; velocity < 1.0; velocity+=0.05) { //percent of speed of light        
    PVector l=lorentz(x, time, velocity ) ;
    vertex(l.x, l.y);
  }
  
  noFill();
  strokeWeight(5);
  stroke(255,100);
  endShape();
  
  
  noStroke();
  fill(255);
  PVector l=lorentz(x, time, 0.4*(sin(anim)+1.0)) ;
  ellipse(l.x, l.y, 15, 15);
}

void drawHyps(){
  boolean hyps=false;
  if (hyps){
    pushMatrix();
    float step = width / 160.;
    for (int n = 0; n < 30; n++) {
        drawHyp(n * 3000, step);
    }
    popMatrix();
  }
  
  //for (int n = 1; n < 20; n++)
    for (int time = 0; time < 50; time++)
      drawHyperbola(0, time*40);
     
    
    
    //pushMatrix();
    //rotate(PI/4);
    //fill(255, 20);
    
    //for (int m = 2; m < 20; m++) {
        
    //  for (int n = 2; n < 20; n++) {
    //    float x = random( 20 * 50);
    //    float y = random( 20 * 50);
    //    //float y = n * 50;
    //    strokeWeight(4);
    //    stroke(255,3);
    //    PVector l=lorentz(x,y, 0.8*(sin(anim)+0.9)/2. ) ;
        
    //    line(x, y, l.x, l.y);
    //    //ellipse(l.x, l.y, 5, 5);
    //    //vertex(x, y);
    //  }
    //  // stroke(255, 0,0,120);
    //  //strokeWeight(4);
    //  //endShape();
    //}
    //popMatrix();
    
    
    //for (int m = 1; m < 10; m++) {
    //   beginShape();
    //  for (int n = 1; n < 10; n++) {
    //    float x =  funcR(n * 3000, 10*m*sin(anim/3));   ;//pow(n, m) * 30  +(sin(anim)-2.)*width/4;
    //    float y = func(n * 3000, x);
    //    ellipse(x, y, 10, 10);
    //    vertex(x, y);
    //  }
    //   stroke(255, 0,0,120);
    //  strokeWeight(4);
    //  endShape();
    //}
}
PVector lorentz(float r, float t, float v){
  float c = 1; //speed of light
  //float v = r;
  float gamma = 1 / sqrt (1 - v*v/c*c);
  
  float t1=gamma*(t - v*r/c*c);
  float r1=gamma*(r - v*t);
  return new PVector(r1, t1);
}
float func(float n, float x){
  return (4 * n) / x ;
}

float funcR(float n, float y){
  return (0.25 * n) / y;
}

void drawHyp(int n, float step){
    //blendMode(DIFFERENCE);
    blendMode(ADD);

    noFill();
    stroke(255, 1);
    strokeWeight(4);
    beginShape();
    for (float x = 0.001; x < width * 2; x += step) {
        float y =func(n, x);
        vertex(x, y);
    }
    endShape();
}
void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_16/opart__####.png");
}
