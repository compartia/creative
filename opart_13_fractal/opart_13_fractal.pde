void setup() {   
  size(640, 640);
  background(0);
  frameRate(30);
  smooth(4);
  pixelDensity(2);
  //strokeWeight(1);
  
  //textSize(20);

  background(0);
}
 
float anim=0;
void draw(){
  background(0);
  anim+=0.01;

  if (frameCount<30*60){
    //saveFrame("/Users/artem/work/creative-code/opart_12_wave/opart__####.tif");
    println(frameCount);
  }
  else noLoop();  
}


void mouseReleased() {
  println(frameCount+" ");
  saveFrame("/Users/artem/work/creative-code/opart_13_hex/opart__####.png");
}
 



 
