PGraphics alphaG;//=createGrapht
void setup() {   
  size(1500, 1500);
  background(0);
  frameRate(30);
  smooth(4);
  pixelDensity(2);
  background(0);
  
  //noLoop();
  
  alphaG=createGraphics(width, height);
}

 
float N = 38.;
float anim=0;
void draw(){
  anim+=0.01;
  //blendMode(DIFFERENCE);
  background(70, 0, 0);
  
  alphaG.beginDraw();
  alphaG.translate(width/2, height/2);
  alphaG.scale(1.9);
  
  alphaG.fill(255);  
  //drawGrid(2);
  
 
  float s= width ;
  for (int c=0; c<17; c++){
    alphaG.noStroke();
    //scale(0.8);
    //rotate(0.01);
    alphaG.scale(0.8);
    alphaG.fill(0);    
    //alphaG.rect(-s/2, -s/2, s, s);
    
    alphaG.fill(255, 80); 
    
    drawGrid(9, alphaG);
  }
  alphaG.endDraw();
   
  image(alphaG,0,0);
}

 
 
void drawGrid(float N, PGraphics alphaG){
  
  
  alphaG.pushMatrix();
  float spacer=width/N;
  float arrowSize=spacer*0.47;
  
  
  alphaG.translate(spacer/2., spacer/2);
  for (float x=-width/2, cx=0; x<width/2; x+=spacer, cx++){
    for (float y=-width/2, cy=0; y<width/2; y+=spacer, cy++){
      alphaG.pushMatrix();
      alphaG.translate(x, y);
      //alphaG.rotate(1*PI*((x+y)/width));
      //rotate(PI/19);
      int c=255;
      //if ( 1+(cx%3+cy%7) % 2==0)
      //    c=0;
          
      //if ( cx%2==0)
      //    c=0;
          
      if (x<=-width/2+0.1 || y<=-height/2+0.1 || y>=height/2-spacer || x>=width/2-spacer){
        alphaG.fill(c);
        drawBox(arrowSize, alphaG);
        //stroke(255);
        //strokeWeight(7);
        //drawArrow(arrowSize);       
      }
      alphaG.popMatrix();
    }
  }
  alphaG.popMatrix();
  
  //
}

void drawBox(float size, PGraphics alphaG){
  alphaG.noStroke();
  alphaG.pushMatrix();
  //translate(-size/2,-size/2);  
  //rect(0,0, size, size);
  alphaG.fill(255,0,0);
  alphaG.ellipse(0,-anim, size, size);
  
  alphaG.fill(0,255,255);
  alphaG.ellipse(0,anim, size, size);
  alphaG.fill(255);
  alphaG.ellipse(0,0, size, size);
  alphaG.popMatrix();
}
   

  

 
void mouseReleased() {
  println(anim);
  alphaG.save("/Users/artem/work/creative-code/opart_11_grid_alpha/opart_11_grid_alpha.png");
}
