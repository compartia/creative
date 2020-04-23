ArrayList <Triangle> triangles = new ArrayList<Triangle>();
ArrayList <Triangle> triangles2 = new ArrayList<Triangle>();
ArrayList <Triangle> triangles3 = new ArrayList<Triangle>();
//boolean dividing = false;
//boolean zooming = false;
//float divideStep = 0;
//int zoomStep = 0;
float strokeSize = 1.1;

void setup() {
  size(1080, 1080);
  pixelDensity(2);
  frameRate(60);
  smooth(4);
  noStroke();
  makeWheel();
  //redrawAll(triangles);
  textAlign(CENTER, CENTER);
  
  int N=5;
  for (int i=0; i<N; i++){
    triangles = subdivide(triangles, 1);
  }
  
  triangles2 = subdivide(triangles, 1);
  triangles3 = subdivide(triangles2, 1);
  triangles3 = subdivide(triangles3, 1);
  //triangles2 = subdivide(triangles2, 1);
  
}

int t=0;
float angle=0;
void draw() {
  //blendMode(ADD);
  t++;
  angle=radians(t/10.0);
  //float triangleSize = dist(triangles.get(0).vert[0].x, triangles.get(0).vert[0].y, triangles.get(0).vert[1].x, triangles.get(0).vert[1].y); 
   
  strokeSize = 1;
  //background(0);
  blendMode(MULTIPLY);
  fill(0, 0, 0, 120);
  
  rect(0,0,width,height );
  
  pushMatrix();
  translate(width/2.0, height/2.0);
  rotate(angle);
  scale(1.5);
  translate(-width/2.0, -height/2.0);
  redrawAll(triangles);
  popMatrix();
  
  pushMatrix();
  translate(width/2.0, height/2.0);
  rotate(-angle/2);
  scale(1.5);
  translate(-width/2.0, -height/2.0);  
  redrawAll(triangles2);
  popMatrix();
  
  
  
  pushMatrix();
  translate(width/2.0, height/2.0);
  //rotate(-angle/2);
  scale(1.5);
  translate(-width/2.0, -height/2.0);  
  redrawAll(triangles3);
  popMatrix();
  
  //redrawAll(triangles);
 
  saveFrame("/Users/artem/work/creative-code/output/penrose_####.png");
}

 

void makeWheel() {
  PVector origin = new PVector(width/2, height/2);
  float r = 0.5*width;
  for (int i = 0; i < 10; i++) {
    PVector b = new PVector(origin.x + r*cos((2*i-1)*PI/10), origin.y + r*sin((2*i-1)*PI/10));
    PVector c = new PVector(origin.x + r*cos((2*i+1)*PI/10), origin.y + r*sin((2*i+1)*PI/10));
    if (i%2 == 0) { //mirror every second triangle
      PVector temp = b;
      b = c;
      c = temp;
    }
    triangles.add(new Triangle(true, origin, b, c));
  }
}

ArrayList<Triangle> subdivide(ArrayList<Triangle> tList, float s) {
  ArrayList<Triangle> result = new ArrayList<Triangle>();
  float phi = (1 + sqrt(5))/2;
  for (int i = 0; i < tList.size (); i++) {
    Triangle t = tList.get(i);
    Triangle t1, t2, t3;
    if (t.red) {
      PVector p = new PVector(t.vert[0].x +s*(t.vert[1].x - t.vert[0].x)/phi, t.vert[0].y +s*(t.vert[1].y - t.vert[0].y)/phi);
      addToList(result, new Triangle(true, t.vert[2], p, t.vert[1]));
      addToList(result, new Triangle(false, p, t.vert[2], t.vert[0]));
    } else {
      PVector q = new PVector(t.vert[0].x - (1-1/phi)*s*(t.vert[0].x - t.vert[1].x), t.vert[0].y - (1-1/phi)*s*(t.vert[0].y - t.vert[1].y) );
      PVector r = new PVector(t.vert[1].x + (t.vert[2].x - t.vert[1].x)/phi, t.vert[1].y + (t.vert[2].y - t.vert[1].y)/phi );
      addToList(result, new Triangle(false, r, t.vert[2], t.vert[0]));
      addToList(result, new Triangle(false, q, r, t.vert[1]));
      addToList(result, new Triangle(true, r, q, t.vert[0]));
    }
  }
  return result;
}

void redrawAll(ArrayList<Triangle> tList) {
  for (int i = 0; i < tList.size (); i++) {
    tList.get(i).redraw();
  }
}

void addToList(ArrayList<Triangle> tList, Triangle t) {
  if ((t.vert[0].x >= 0 && t.vert[0].x <= width && t.vert[0].y >= 0 && t.vert[0].y <= height) || 
    (t.vert[1].x >= 0 && t.vert[1].x <= width && t.vert[1].y >= 0 && t.vert[1].y <= height) ||
    (t.vert[2].x >= 0 && t.vert[2].x <= width && t.vert[2].y >= 0 && t.vert[2].y <= height)) {
    tList.add(t);
  }
}
 

class Triangle {
  
  boolean red;
  PVector[] vert = new PVector[3];
  color c1 = color(0, 0, 0, 100);
  color c2 = color(160, 40, 80, 40);
  color c3 = color(255, 255, 255, 100);
  
  Triangle(boolean red, PVector a, PVector b, PVector c) {
    this.red = red;
    this.vert[0] = a;
    this.vert[1] = b;
    this.vert[2] = c;
  }
  
  void redraw() {
    blendMode(ADD);
    noStroke();
    if (red) {
      fill(c2);
      //stroke(c2);
    } else {
      noFill();
      //fill(c1);
      //stroke(c1);
    }
    //fill(c2);
    //noFill();
    stroke(c2);
      
    //strokeWeight(1);
    strokeWeight(strokeSize);
    triangle(vert[1].x, vert[1].y, vert[0].x, vert[0].y, vert[2].x, vert[2].y);
    //stroke(c3);

    line(vert[1].x, vert[1].y, vert[0].x, vert[0].y);
    line(vert[0].x, vert[0].y, vert[2].x, vert[2].y);
    noStroke();
  }

  
}
