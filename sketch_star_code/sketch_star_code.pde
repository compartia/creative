//settings
boolean fillStar=false;
boolean drawHex=false;
boolean drawBoxSides=false;

static int side=640;

color base_color = color(170,50,230);
color bg = color(255);

int N=5;
//float base_radius=((float)side)/(N*2.0);
float base_radius=(side/N)/sin(radians(60))/2;

float dx = 2*base_radius * sin(radians(60));
float dy = base_radius/2 + 2*base_radius * cos(radians(60));

int time=0;
float dotsD=12;
float dotsR=12;

PGraphics maskImage;
PGraphics dotsImage;

float dot_dx=dx/dotsD;
float dot_dy=dy/dotsD;
  
static int side_x=1080;
static int side_y=1080;
//--
void setup() {
  size(640, 640);
  side_x=width;
  side_y=height;
   
  //size(640, 640);
  background(bg);
  frameRate(30);
  smooth(2);
  pixelDensity(1);
  strokeWeight(1);
  noLoop();
  
  maskImage = createGraphics(side_x, side_y);
  maskImage.beginDraw();
  //maskImage.translate(dx*N/2, dot_dy*16);
  
  maskImage.pushMatrix();
  maskImage.background(bg);
  fill(255);
  //maskImage.translate(dx*N/2, dot_dy*16);
  maskImage.translate(maskImage.width/2, maskImage.height/2);
  maskImage.rotate(PI/2);
  
  draw_star_mask(maskImage, base_radius*2);
  maskImage.popMatrix();
  maskImage.endDraw();
  
  
  dotsImage = createGraphics(side_x,side_y);
  dotsImage.beginDraw();
  dotsImage.background(bg);
  drawDots(dotsImage, maskImage);
  dotsImage.endDraw();
  //dotsImage.mask(maskImage);
  
}

void draw() {
  time++;
  if(time==1000) time=0;
  //background(255);
  //background(128);
 
  
  //image(maskImage, 0, 0);
  //image(dotsImage, 0, 0);
  
  image(dotsImage, 0, 0); 
  
  //saveFrame("/Users/artem/work/creative-code/output3/stars__####.png");

}

void drawDots(PGraphics g, PGraphics mask){
  
  g.pushMatrix();
  //g.image(mask,0,0);
  g.translate(g.width/2, g.height/2);
   
  print(g.width);
  

  //g.fill(140,50,230);
  //g.ellipse(0,0,200,200);
  
  for(float y=-(N/2)*dotsD; y< (N/2)*dotsD; y+=1){
    float o = y%2 ==0? 0:dot_dx/2;
    
    for(float x=-(N/2)*dotsD; x<(N/2)*dotsD; x+=1){
      g.pushMatrix();
      mask.pushMatrix();
      float offx=0;//random(base_radius/12);
      float offy=0;//=random(base_radius/12);
      g.translate(offx + x*dot_dx+o, offy + y*dot_dy);
      mask.translate(offx + x*dot_dx+o, offy + y*dot_dy);
      //mask.translate(x*dot_dx+o, y*dot_dy);
      //color c = mask.get(0,0);      
      
      //g.fill(140,50,230);
      color c = mask.get( (int)(x*dot_dx+o)+g.width/2, g.height/2+ (int)(y*dot_dy));
      g.fill(c);
      //rr=base_radius*(0.2+random(1));
      float rr=base_radius;
      draw_dot(g, rr);
      g.popMatrix();
      mask.popMatrix();
       
    }
  }
  g.popMatrix();
  
}

 
void draw_dot(PGraphics g, float radius){
  g.noStroke();
  //g.fill(255);
  float r=radius/dotsR;
  g.ellipse(0,0,r,r);
  //draw_star_mask (g, r/2);
}

  

void draw_star_mask (PGraphics g, float radius){
  
  g.stroke(base_color);
  g.fill(base_color);
  draw_star_segment(g, radius);
  g.pushMatrix();
  g.scale(-1,1);
  g.stroke(base_color);
  //g.fill(255);
  draw_star_segment(g, radius);
  g.popMatrix();
}

void draw_star_segment(PGraphics g, float radius){
  
  float angle = PI/3;  
  float rx=radius * sin(radians(45))* sin(radians(15)) ;//sin(radians(-30)) * radius/3;
  float ry=rx/tan(radians(30));//cos(radians(-30)) * radius/3;
  
  for (float a = 0; a < TWO_PI; a += angle) {
    g.pushMatrix();
    g.rotate(a);
    g.beginShape();
    g.vertex(0, 0);
    g.vertex(0, radius);
    g.vertex(-rx, ry);
    g.endShape(CLOSE);
    g.popMatrix();
  }
}


void draw_face( float radius ){ 
  beginShape();
  {
    vertex(0,0);
    vertex(cos(radians(-30)) * radius, sin(radians(-30)) * radius);
    vertex(cos(radians(30)) * radius, sin(radians(30)) * radius);
    vertex(0, radius);
  }
  endShape(CLOSE);  
}


void mouseReleased() {
  looping = !looping; 
  if (looping) {
    loop();
  } else {
    noLoop();
  }
}
