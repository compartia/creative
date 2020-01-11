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
  //noLoop();
   //background(0);
   fill(0,60);
   rect(0,0,width, height);
   float dx = (float)width/N; 
   float swidth = dx/shadSteps;
  
  //if (offset>dx*6)
  //   offset=0;
  //if (offset2>dx*6)
  //    offset2=0;
      
  //offset+=0.6+sin(PI*frameCount/30.0);
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
       //fill(c);
       drawShape(0, 0, dx);
     }
     fill(255);
     drawShape(0, 0, dx);
     popMatrix();
     
     //fill(255);
     //blendMode(BLEND);
     //drawShape(0, 0, dx);
      
  }
  popMatrix();
    //draw frame
  blendMode(BLEND);
  noFill();
  stroke(0);
  strokeWeight(dx*2);
  rect(0, 0, width, height);
  
  if (frameCount<1800)
    saveFrame("/Users/artem/work/creative-code/opart_14_render/opart__####.tif");
  else
    noLoop();
}



void drawShape(float x, float y, float size){
  int dirx=0;
  int diry=0;
  
  //for(int i=0; i<20; i++){
    
  //  pushMatrix();
  //  translate(size*dirx, size*diry);
  //  rect(x, y, size, size);
    
  //  if (i < 3)
  //    dirx++;
  //  if (i>=3 && i<6)
  //    diry++;
  //  if (i>6 && i<11)
  //    dirx--;
      
  //  if (i>10)
  //    diry--;
      
    
  //  popMatrix();
  //}
   
  for(int i=-14; i<16; i++){
    for(int j=-12; j<12; j++){
      pushMatrix();
      
      translate(i*size*3, (j)*size*6);
      translate(0, -(i%2)*size*3 + offset2*(i%2));
      //fill(255);
      //rect(x, y, size, size);
      //rect(x+size, y, size, size);
      //rect(x+size*2, y, size, size);
      
      //rect(x, y+size, size*4, size*1);
      //rect(x, y, size*3, size);
      //rect(x-size, y+size*3, size*3, size);
       
      rect(x, y, size*1, size*4);
       
      
      
      
      //rect(x+size*2, y+size, size, size);
      //rect(x+size*2, y+size*2, size, size);
      ////rect(x+size*1, y+size*2, size, size);
      //rect(x+size*0, y+size*2, size, size);
      //rect(x+size*-1, y+size*2, size, size);
      //rect(x+size*-2, y+size*2, size, size);
      //rect(x+size*-2, y+size*1, size, size);
      //rect(x+size*-2, y+size*0, size, size);
      //rect(x+size*-2, y+size*-1, size, size);
      //rect(x+size*-2, y+size*-2, size, size);
      //rect(x+size*-1, y+size*-2, size, size);
      //rect(x+size*-0, y+size*-2, size, size);
      //rect(x+size*1, y+size*-2, size, size);
      //rect(x+size*2, y+size*-2, size, size);
      
      //rect(x+size*2, y+size*-3, size, size);
      
      
      //rect(x+size*1, y+size*3, size, size);
      //rect(x+size*0, y+size*3, size, size);
      //rect(x+size*-1, y+size*3, size, size);
      //rect(x+size*-2, y+size*3, size, size);
      ////top branch
      ////fill(255,0,0);
      //rect(x+size*0, y+size*-1, size, size);
      //rect(x+size*0, y+size*-2, size, size);
      //rect(x+size*1, y+size*-2, size, size);
      //rect(x+size*2, y+size*-2, size, size);
      //rect(x+size*3, y+size*-2, size, size);
      //rect(x+size*4, y+size*-2, size, size);
      //rect(x+size*4, y+size*-1, size, size);
      ////rect(x+size*4, y+size*2, size, size);
      ////rect(x+size*4, y+size, size, size);
      ////rect(x+size*4, y+size, size, size);
      ////rect(x-size, y, size, size);
      ////rect(x, y+size, size, size);
      ////rect(x, y-size, size, size);
      popMatrix();
    }
  }
  
}

 
void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_14/opart__####.png");
}
