color c1=color(0);
color c2=color(255, 180, 100, 20);
//color c2=color(218, 255, 54, 8);
color c3=color(3, 217, 255, 180);
color c4=color(3, 80, 255, 180);

color c5=color(30, 40, 100, 18);

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
   //blendMode(ADD);
  translate(width/2, height/2);
  
  drawCircleBlured(getGraphics());
}

float dots=2000;
void drawCircleBlured(PGraphics g){
   g.noFill();
   g.stroke(c2);
 
  float b=1;
  float a=b;
  float k=0.0001;
  for (float t=0; t<2*PI; t+=2*PI/dots){
    float r = randomGaussian();
    float d_cassini = r*r*r*r - 2*a*a * r*r * cos(2*t+PI) - b*b*b*b + a*a*a*a; 
    
   
    
    float x = 0.3*width* r * sin(t);// + r2 * sin(alpha2) ;
    float y = 0.3*width* r * cos(t);// + r2 * cos(alpha2) ;
    
     
    float lrp =0.1*randomGaussian() + (1+ cos(1.5* ( d_cassini+1)  *32))/2.0;
     
    if (lrp<0.9) lrp=0; 
    color cc = lerpColor(c5, c2, lrp );
    g.stroke(cc);
    
    if ( abs(d_cassini-k)<0.01)
      g.stroke(255,255,255,30);
    g.line(x, y, x+randomGaussian(), y+1);
  
  }
}

 

void mouseReleased() {
   
  println(frameCount+" ");
  saveFrame("/Users/artem/work/creative-code/lemniscata/gauss__####.png");
}
 



 
