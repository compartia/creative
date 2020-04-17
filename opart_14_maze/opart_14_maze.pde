float N = 47.;
float shadSteps=6.;
int depth=2;

void setup() {
    size(640, 640);
    background(0);
    frameRate(30);
    smooth(8);
    pixelDensity(2); //retina
    background(0);
}

float offset=0;
float offset2=0;

void draw(){
 
   fill(0, 60);
   rect(0, 0,width, height);
   float dx = (float)width/N; 
   float swidth = dx/shadSteps;
  
 
  offset2 = dx*6*sin(PI*frameCount/60.0);
  offset = dx*3*cos(PI*frameCount/120.0);
  
  pushMatrix();
  translate(width/2, height/2);
  scale(0.7+ (sin(frameCount/60.0)+2)/4 );
  rotate(PI/4+sin(offset/0.12)/160);
  {
     translate(-dx*6- offset, -dx*10 + offset);
     
     pushMatrix();
     scale(0.5+ (cos(frameCount/60.0)+2)/4 );
     blendMode(BLEND);
    
     noStroke();
     
     translate(dx*depth, dx*depth);
     
     for (float d=0; d<shadSteps*depth; d++){
       translate(-swidth, swidth);
       int c = (int)(255 * ((d)%2));
       fill(255-c,c,c);
 
       drawShape(0, 0, dx);
     }
     fill(255);
     drawShape(0, 0, dx);
     popMatrix();
     
 
      
  }
  popMatrix();
 
  blendMode(BLEND);
  noFill();
  stroke(0);
  strokeWeight(dx*2);
  rect(0, 0, width, height);
  
  //if (frameCount<1800)
  //  saveFrame("/Users/artem/work/creative-code/opart_14_render/opart__####.tif");
  //else
  //  noLoop();
}



void drawShape(float x, float y, float size){
 
   
  for(int i=-14; i<16; i++){
    for(int j=-12; j<12; j++){
      pushMatrix();
      
      translate(i*size*3, (j)*size*6);
      translate(0, -(i%2)*size*3 + offset2*(i%2));
      
      rect(x, y, size*1, size*4);
       
      
      
      popMatrix();
    }
  }
  
}

 
void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_14/opart__####.png");
}
