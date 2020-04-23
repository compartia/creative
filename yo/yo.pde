

float dot_scale = 0.2;
float font_size = 600;
PFont mono;
void setup() {   
  size(320, 320);
  
  //size(640, 640);
  background(0);
  frameRate(30);
  smooth(4);
  //pixelDensity(2);
  //strokeWeight(1);
  
  textSize(20);
  
  mono = createFont("Roboto-Black.ttf" , font_size);
  background(0);
  textFont(mono);
  
}


float tw;
void draw(){
  font_size = width*0.75;  
  fill(0, 20);
  rect(0,0,width, height);
  pushMatrix();
  
  
  translate(width/2, height*0.4);
  //rotate(PI*frameCount/200);
  float sc = 0.2 + 2*(frameCount % 80)/100.0;
  scale(sc);
  
  textSize(font_size);
  tw = textWidth("E");
  
  fill (255, 200);  
  
  draw_yo(1);
  //noStroke();
  //scale(sc*0.95);
   
  //fill (255, 200);  
  //draw_yo(1);
  popMatrix();
  
}



void draw_yo(int depth){
  pushMatrix();
     
  text("E", -tw/2, height/2);
   
  if (depth<10){
  
    {
      pushMatrix();  
      translate(-font_size*0.12, -font_size*0.28);      
      scale(dot_scale);
      draw_yo(depth+1);
        
      popMatrix();
    }
    
    {
      pushMatrix();   
      translate(font_size*0.12, -font_size*0.28);      
      scale(dot_scale);
      draw_yo(depth+1);      
      popMatrix();
    }
  }
  
  popMatrix();
   
  
  
  
  
}
