

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
static int side=1080;
int N=4;
float dotsD=12;
float dotsR=12;

 
float divider = 4.0;
//int segments=128;
//float angle = (2.0 * PI)/segments;
float thiknes=4.5;
int alpha=220;

color c1=color(0);
color c2=color(255);  
color c4=color(0,210,255,alpha);
color c3=color(255,0,0,alpha);
void draw(){
  background(0);
  
  noStroke();
  //drawDots(getGraphics());
  
  pushMatrix();  
  
  fill(c3);
  drawDots(getGraphics(), true);
  
  fill(c4);
  //stroke(c2);
  drawDots(getGraphics(), false);
  

  popMatrix();
  

}

void mouseReleased() {

  println(frameCount+" ");
  saveFrame("/Users/artem/work/creative-code/opart_7_hex/opart__####.png");
}
 





float base_radius=(side/N)/sin(radians(60))/2;

float dx = 2*base_radius * sin(radians(60));
float dy = base_radius/2 + 2*base_radius * cos(radians(60));
float dot_dx=dx/dotsD;
float dot_dy=dy/dotsD;

void drawDots(PGraphics g, boolean distort){
  
  g.pushMatrix();
  //g.image(mask,0,0);
  g.translate(g.width/2, g.height/2);
   
  //print(g.width);
  

  //g.fill(140,50,230);
  //g.ellipse(0,0,200,200);
  float offb=base_radius/60;
  
  for(float y=-(N/2)*dotsD; y< (N/2)*dotsD; y+=1){
    float o = y%2 ==0? 0:dot_dx/2;
    
    for(float x=-(N/2)*dotsD; x<(N/2)*dotsD; x+=1){
      g.pushMatrix();
       
      float offx=0;//random(base_radius/12);
      float offy=0;//=random(base_radius/12);
      if (distort){
        offx=offb*sin(x/2.0);//random(base_radius/12);
        offy=offb*cos(y/2.0);//random(base_radius/12);
      }
      g.translate(offx + x*dot_dx+o, offy + y*dot_dy);
       
      //mask.translate(x*dot_dx+o, y*dot_dy);
      //color c = mask.get(0,0);      
      
      
      //rr=base_radius*(0.2+random(1));
      float rr=base_radius;
      draw_dot(g, rr);
      g.popMatrix();
      
       
    }
  }
  g.popMatrix();
  
}

void draw_dot(PGraphics g, float radius){
  //g.noStroke();
  //g.fill(255);
  float r=radius/dotsR;
  g.ellipse(0,0,r,r);
  //draw_star_mask (g, r/2);
}
 
