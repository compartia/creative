color bg = color(0);
color c1 = color(255, 200, 54, 50);
color c2 = color(3, 217, 255, 200);
color c3 = color(3, 80, 255, 8);


ArrayList<PVector> datapoints;
Hull hull;
void setup() {   
 
  size(540, 540);
  background(0);
  frameRate(30);
  
  pixelDensity(1);   
  background(bg);
  
  datapoints = make_bubbles(17);

  hull = new Hull(datapoints);
  
}
 

void draw(){
  background(bg);
  //datapoints = make_bubbles(3);
  translate(width/2, height/2);
  int r = 4;
  
  fill(c1);
  noStroke();
  for (PVector p: datapoints){
    ellipse(p.x, p.y, r, r);
  }
  
  hull.draw();
  hull.move(datapoints);
  //drawCircleBlured(getGraphics());
}


 
 
 

void mouseReleased() {
  noLoop();
  println(frameCount+" ");
  saveFrame("clustering_####.png");
}
 



 
