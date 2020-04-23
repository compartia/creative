

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
float rott=0;
float divider = 4.0;
int segments=14;
float angle = (2.0 * PI)/segments;
float thiknes=5.0;
void draw(){
   //background(250,40,0);
  //fill(0, 20);
  //rect(0, 0, width, height);
  pushMatrix();
  divider+=0.01;
  
  translate(width/2, height/2);
  rott+=0.01;
  
  for (int r=0; r<width; r+=thiknes*2){
    for (int i=0; i<segments; i++){
      pushMatrix();
      rotate(angle*i );
      
      stroke(0,210,255,10);      
      draw_segment(r);
      
      //stroke(0,10);      
      //draw_segment(r+thiknes);
      
      stroke(255,0,0,10);      
      draw_segment(r-thiknes);
      
      popMatrix();
    }
  }
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
  
  popMatrix();
  
}

void mouseReleased() {

  println(frameCount);
  saveFrame("/Users/artem/work/creative-code/opart/opart__####.png");
}

void draw_segment(float r){
  
  //pushMatrix();
  //translate(0, -r );
  float x = r * sin(angle/2);
  float y = r * cos(angle/2);
   
  //line(0,-l/divider,l,0);
  //line(0,-l/divider,-l,0);
  strokeWeight(thiknes);
  line(0,r*0.9,x,y);
  strokeWeight(thiknes*0.9);
  line(0,r*0.9,-x,y);
  //line(0,0,-x,y);
  //line(0,0,-l,0);
   
  //popMatrix();
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
