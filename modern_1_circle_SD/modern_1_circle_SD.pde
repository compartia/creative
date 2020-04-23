color c1=color(0);
color c2=color(255, 200, 54, 8);
//color c2=color(218, 255, 54, 8);
color c3=color(3, 217, 255, 8);
color c4=color(3, 80, 255, 8);

void setup() {   
 
  size(1080, 1080);
  background(0);
  frameRate(30);
  //smooth(0);
  pixelDensity(2);   
  background(48, 44, 56);

}
 
int N=7;
 

void draw(){
 
  translate(width/2, height/2);
  
  drawCircleBlured(getGraphics());
}

float dots=2000;
void drawCircleBlured(PGraphics g){
   g.noFill();
   g.stroke(c2);
   //g.line(0,0,100,100);
   
  
  for (float t=0; t<2*PI; t+=2*PI/dots){
    float alpha = t + randomGaussian()/100.0;
    float r = width*0.25 -  abs( 15*randomGaussian()*(alpha-PI)*(alpha-PI)*(alpha-PI));
    
    float x = r * sin(alpha);
    float y = r * cos(alpha);
    
    float p=-(sin(r)+1)/3;
    color cc = lerpColor(c4, c2, p+  4*r/width+randomGaussian()/7.0);
    g.stroke(cc);
    g.line(x, y, x+randomGaussian(), y+1);
  
  }
}

 

void mouseReleased() {
  noLoop();
  println(frameCount+" ");
  saveFrame("/Users/artem/work/creative-code/modern_1_gaussian_circle/gauss__####.png");
}
 



 
