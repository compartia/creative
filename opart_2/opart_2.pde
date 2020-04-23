

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
int N=8;
float dotsD=12;
float dotsR=12;

float rott=0;
float divider = 4.0;
int segments=256;
float angle = (2.0 * PI)/segments;
float thiknes=4.5;
int alpha=220;

color c1=color(0);
color c2=color(255);  
//color c1=color(0,210,255,alpha);
//color c2=color(255,0,0,alpha);
void draw(){
  background(0);
  //fill(0, 20);
  //rect(0, 0, width, height);
  //fill(0);
  
  drawDots(getGraphics());
  
  pushMatrix();  
  rott=frameCount/1000.0;
  
  fill(c2);
  //stroke(c2);
  drawDots(getGraphics());
  
  translate(width/2, height/2);
  rotate(angle + rott);
  translate(-width/2, -height/2);
  fill(c1);
  noStroke();
  drawDots(getGraphics());
  
  
  popMatrix();
  
  if(frameCount<1000){
    println(frameCount+" ");
    saveFrame("/Users/artem/work/creative-code/opart_2/opart__####.png");
  }
  
  //divider+=0.01;
  
  //translate(width/2, height/2);
  
  
  //for (int r=0; r<width; r+=thiknes*3){
  //  for (int i=0; i<segments; i++){
  //    pushMatrix();
  //    rotate(angle*i + rott);
      
  //    stroke(c1);
  //    fill(c1);
  //    draw_segment(r);
      
  //    //stroke(0,10);      
  //    //draw_segment(r+thiknes);
      
  //    rotate(angle*(i+0.5)  + rott);
  //    stroke(c2);  
  //    fill(c2);
  //    draw_segment(r-thiknes/2);
      
  //    popMatrix();
  //  }
  //}
  //saveFrame("/Users/artem/work/creative-code/opart/opart__####.png");
  
  //for (int r=0; r<width; r+=thiknes*2){
  //  for (int i=0; i<segments; i++){
  //    pushMatrix();
  //    rotate(angle*i );
      
  //    stroke(255, 0,0,1);      
  //    draw_segment(r);
  //    //stroke(0);      
  //    //draw_segment(r+thiknes);
  //    popMatrix();
  //  }
  //}
  
  
  
}

void mouseReleased() {

  println(frameCount+" ");
  saveFrame("/Users/artem/work/creative-code/opart_2/opart__####.png");
}

void draw_segment(float r){
  
  //pushMatrix();
  //translate(0, -r );
  //float x = r * sin(angle/2);
  //float y = r * cos(angle/2);
   
   
  //strokeWeight(thiknes);
  //line(0,r*0.9,x,y);
  //strokeWeight(thiknes*0.9);
  //line(0,r*0.9,-x,y);
  
  noStroke();
  ellipse(0, r, thiknes, thiknes);
   
}





float base_radius=(side/N)/sin(radians(60))/2;

float dx = 2*base_radius * sin(radians(60));
float dy = base_radius/2 + 2*base_radius * cos(radians(60));
float dot_dx=dx/dotsD;
float dot_dy=dy/dotsD;

void drawDots(PGraphics g){
  
  g.pushMatrix();
  //g.image(mask,0,0);
  g.translate(g.width/2, g.height/2);
   
  //print(g.width);
  

  //g.fill(140,50,230);
  //g.ellipse(0,0,200,200);
  
  for(float y=-(N/2)*dotsD; y< (N/2)*dotsD; y+=1){
    float o = y%2 ==0? 0:dot_dx/2;
    
    for(float x=-(N/2)*dotsD; x<(N/2)*dotsD; x+=1){
      g.pushMatrix();
       
      float offx=0;//random(base_radius/12);
      float offy=0;//=random(base_radius/12);
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

//void draw_yo(int depth){
//  pushMatrix();
     
//  text("E", -tw/2, height/2);
   
//  if (depth<10){
  
//    {
//      pushMatrix();  
//      translate(-font_size*0.12, -font_size*0.28);      
//      scale(dot_scale);
//      draw_yo(depth+1);
        
//      popMatrix();
//    }
    
//    {
//      pushMatrix();   
//      translate(font_size*0.12, -font_size*0.28);      
//      scale(dot_scale);
//      draw_yo(depth+1);      
//      popMatrix();
//    }
//  }
  
//  popMatrix();
   
  
  
  
  
//}
