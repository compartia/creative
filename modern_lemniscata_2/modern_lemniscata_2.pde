float al=30;
color gold1 = color(217, 204, 158, al);
color gold2 = color(252, 166, 68, al);
//color gold1 = color(0, 216, 40, 10);
//color gold2 = color(224, 0, 0, 50);
color gold3 = color(166, 227, 215, al/2);

color bg1 = color(14, 16, 33, al);
color bg2 = color(48, 39, 37, al);
color bg3 = color(0, 0, 0, al);

color c1=color(0);
color c2=color(255, 200, 150, 20);

color c3=color(3, 217, 255, 180);
color c4=color(3, 80, 255, 180);

color c5=color(30, 40, 50, 18);

color c6=color(218, 255, 54, 8);
color c7=color(48, 44, 56, 28);
void setup() {   
 
  size(1080, 1080);
  background(0);
  frameRate(30);
  //smooth(0);
  pixelDensity(2);   
  background(48, 44, 56);

}
 
 

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
  float a=b*0.994085;
  float k=0.000019;
  for (float t=0; t<2*PI; t+=2*PI/dots){
    
    color bg = lerpColor(bg1, bg3, sin(t*144));
    bg = lerpColor(bg, bg2, cos(t*144));
    
    
    
    float r = randomGaussian()*0.75;
    float d_cassini = r*r*r*r - 2*a*a * r*r * cos(2*t+PI) - b*b*b*b + a*a*a*a; 
    
    color gold = lerpColor(gold3, gold2, 0.5*(sin(d_cassini*12*12 * randomGaussian())+1) );
    gold = lerpColor(gold, gold1, 0.5*(sin(12*6*d_cassini)+1));
   
    
    float x = 0.3*width* r * sin(t);// + r2 * sin(alpha2) ;
    float y = 0.3*width* r * cos(t);// + r2 * cos(alpha2) ;
    
     
    //float lrp =0.1*randomGaussian() + (1+ cos(1.5* ( d_cassini+1)  *32))/2.0;
    
    float lrp = d_cassini/2;
     
    //if (d_cassini>k+0.01) {
      lrp=  (1+ sin(1.5* (sqrt(sqrt(d_cassini+1))+1)  *100))/2.0;
      if (lrp<0.9) lrp=0;
      //if (lrp>0.8 ){
      //  lrp=random(1);
      //}else{
      //  lrp=1;
      //}
    
    //if (d_cassini<k+0.01)
    //  lrp=1-lrp;
    //}else{
    //  lrp = d_cassini*10;
    //}
    //lrp+=0.5*randomGaussian();
    color cc = lerpColor(bg, gold, lrp );
    //cc = lerpColor(cc, c7, random(1) );
    g.stroke(cc);
    
    //if (  d_cassini<k+0.01){
    ////if ( abs(d_cassini-k)<0.01)
    //  g.stroke(lerpColor(gold, c7, cos(d_cassini*100 )) );
    //}
    g.line(x, y, x, y);
  
  }
}

 

void mouseReleased() {
   
  println(frameCount+" ");
  saveFrame("/Users/artem/work/creative-code/lemniscata/gauss__####.png");
}
 



 
