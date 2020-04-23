

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
//static int side=1080;
int N=4;
float dotsD=12;
float dotsR=12;

 
//float divider = 4.0;
//int segments=128;
//float angle = (2.0 * PI)/segments;
//float thiknes=4.5;
int alpha=220;

color c1=color(0);
color c2=color(255);  
color c4=color(0,210,255,alpha);
color c3=color(255,0,0,alpha);
float anim=0;
void draw(){
  background(0);
  //fill(0,10);
  //rect(0,0, width, height);
  anim+=0.1;
  noStroke();
  //drawDots(getGraphics());
  rotate(sin(anim)/60);
  pushMatrix();  
  
  fill(c3);
  anim-=0.2;
  drawDots(getGraphics(), true);
  
  fill(c4);
  anim+=0.4;
  drawDots(getGraphics(), true);
  
  
  anim-=0.2;
  fill(c2);
  //stroke(c2);
  drawDots(getGraphics(), true);
  
  //anim+=0.3;
  popMatrix();
  

  if (frameCount<30*60){
    //saveFrame("/Users/artem/work/creative-code/opart_12_wave/opart__####.tif");
    println(frameCount);
  }
  else noLoop();  
}

void mouseReleased() {

  println(frameCount+" ");
  saveFrame("/Users/artem/work/creative-code/opart_7_hex/opart__####.png");
}
 





float base_radius=(1080/N)/sin(radians(60))/2;

float dx = 2*base_radius * sin(radians(60));
float dy = base_radius/2 + 2*base_radius * cos(radians(60));
float dot_dx=dx/dotsD;
float dot_dy=dy/dotsD;


PVector wave(float x, float y){
  float r = sqrt( x*x + y*y ); 
  float r2 = sqrt( (x-30)*(x-30) + y*y );
  float r3 = sqrt( (y-300)*(y-300) + (x-30)*(x-30) );
  float ox = sin(  r+anim*3 );
  float oy = cos(  r+anim*3 );
  
  ox += sin( r2+anim*2 ); 
  oy += cos( r2+anim*2 ); 
  
  ox += sin( r3+anim*3.5 ); 
  oy += cos( r3+anim*3.5 ); 
  
  ox += sin(anim*4.5 + x/2);
  oy += cos(anim*4.5 + y/2);
  return new PVector(ox, oy);
}
void drawDots(PGraphics g, boolean distort){
  
  g.pushMatrix();
  //g.image(mask,0,0);
  g.translate(g.width/2, g.height/2);
   
  //print(g.width);
  

  //g.fill(140,50,230);
  //g.ellipse(0,0,200,200);
  float offb=base_radius/140;
  PVector w = new PVector(0,0);
  for(float y=-(N/2)*dotsD; y< (N/2)*dotsD; y+=1){
    float o = y%2 ==0? 0:dot_dx/2;
    
    for(float x=-(N/2)*dotsD; x<(N/2)*dotsD; x+=1){
      g.pushMatrix();
       
      float offx=0;//random(base_radius/12);
      float offy=0;//=random(base_radius/12);
      
      if (distort){
        w=wave(x, y);
        offx=offb*w.x;
        offy=offb*w.y;
      }
      
      g.translate(offx + x*dot_dx+o, offy + y*dot_dy);
       
      //mask.translate(x*dot_dx+o, y*dot_dy);
      //color c = mask.get(0,0);      
      
      
      //rr=base_radius*(0.2+random(1));
      float rr=base_radius;
      draw_dot(g, rr*0.8);
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
 
