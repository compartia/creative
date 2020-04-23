color c1=color(0);
color c2=color(218, 255, 54, 12);
color c3=color(3, 217, 255, 12);

void setup() {   
 
  size(1080, 1080);
  background(0);
  frameRate(30);
  smooth(0);
  pixelDensity(2);   
  background(48, 44, 56);

}
 
int N=7;
 


 
void draw(){
  //background(0);
  //blendMode(ADD);
  
  noStroke();
  float off=height/(N+4.0);
  translate(0, off*2);
  for (int y=0; y<N; y++){
    pushMatrix();  
    translate(0, off*y);
    drawFigure(getGraphics());
    
    
    
    
    
  
    popMatrix();
  }
}


void drawFigure(PGraphics g){
   
   
  
  for (int x=0; x<width; x++){
    float xx=x;//+randomGaussian()*x;
    float k = 0.000312 *xx*xx*xx/width;//100.0 / log(width - x+1);
    //float k = sin(xx/100)*10;
    
    
    float y = k *   randomGaussian()/PI   ;
     
    
    color cc = lerpColor(c2, c3,   abs(randomGaussian()) * ((float)x/width));
    
    
    
    
    stroke(cc);
    float rx=xx;// + 20*randomGaussian();
    float ry=y + 70*randomGaussian();
    g.line(rx,ry, rx+1, ry);
    
    
    stroke(35,50,250,6);
    g.line(xx, y, xx+randomGaussian(), y);
    
    
    //g.line(xx, y, xx+randomGaussian(), y+randomGaussian());
    //xx+=randomGaussian()*x*x/5000.0;
    //g.line(x, 0, xx+randomGaussian(), y);
    
    
    //stroke(c3);
    //y=k * randomGaussian()/1.7 ;
    //g.line(x, y, x+1, y);
  }
}

 

void mouseReleased() {

  println(frameCount+" ");
  saveFrame("/Users/artem/work/creative-code/modern_1_gaussian/gauss__####.png");
}
 



 
