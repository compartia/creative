

void setup() {   
 
  
  size(640, 640);
  PVector c = new PVector(width/2, height/2);
  makeDots(c);
  background(0);
  frameRate(60);
  smooth(2);
  //pixelDensity(2);
 

  background(0);

}
 
final static int N=18000;

Dot[] dots = new Dot[N];

 
void draw(){
  blendMode(ADD);
  background(0);
   
  
  drawDots(getGraphics());
   
 
 // if(frameCount<10000){
 //   //println(frameCount+" ");
 //   saveFrame("/Users/artem/work/creative-code/dark3/dark####.png");
 // }
   
  
}

void makeDots(PVector c){
  float da = 2.0 * PI /  (float)N;
  for(int i=0; i< N; i++){
    float a = da * i - PI*0.5;
    dots[i] = new Dot(a);
    dots[i].pos.x=c.x + randomGaussian()*0.001;
    dots[i].pos.y=c.y + randomGaussian()*0.001;
    
 
      dots[i].pos . add(dots[i].speed.copy().mult(0.01*randomGaussian()));
 
  }
}

void mouseReleased() {

  println(frameCount+" ");
  saveFrame("dark2a__####.png");
}

  

void drawDots(PGraphics g){
  noStroke();
  fill(255, 30);
  
  for (Dot dot : dots){
    dot.move();
    dot.draw(g, 8);
  }

}

 
  
 
