 
void setup() {
    size(640, 640);
    background(0);
    frameRate(30);
    smooth(8);
    pixelDensity(2); //retina
    background(0);
}

 
float  anim=0;
void draw(){
  anim+=0.05;
  //noLoop();
   //background(0);
   
   //fill(255);
   //noStroke();
   //float ss=9.;
   //for(float x=0.001; x<width; x+=width/ss){
   //  rect(x,0,width/(ss*2.),height);     
   //}
   
    
   //noFill();
   //stroke(255);
   //strokeWeight(2);
   
   
   translate(width/2, height/2);
   rotate(anim);
   scale(0.4);
   rotate(PI/4);
   drawHyps();
   
   rotate(PI/2);
   drawHyps();
   
   rotate(PI);
   drawHyps();
   
   rotate(-PI/2);
   drawHyps();
   
   
}

void drawHyps(){
  pushMatrix();
  float step=width/320.;
  for(int x=0; x<3; x++){     
    drawHyp(x * 20000, step);
    }

    popMatrix();
 }
 
void drawHyp(int n, float step){
  blendMode(DIFFERENCE);
  //blendMode(ADD);
  int r  = (int)(127*sin(random(PI)/2+n/2000.) + 128);
  int g  = (int)(127*sin(random(PI)/2+n/3000.) + 100);
  int b  = (int)(127*sin(random(PI)/2+n/2900.) + 128);
  fill(r, g, b);
  noStroke();
  
  //noFill();
  // stroke(255);
   
   beginShape();
   for(float x=0.001; x<width*2; x+=step){
     float y=(n+400)/(x/4);
     vertex(x, y);
     
   }
   endShape();
}
void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_15/opart__####.png");
}
