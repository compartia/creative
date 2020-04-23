//settings


boolean fillStar=false;
boolean drawHex=false;
boolean drawBoxSides=false;

static int side=640;

color base_color = color(170,50,230);
color bg = color(5, 30, 40, 120);

int N=5;
//float base_radius=((float)side)/(N*2.0);
float base_radius=(side/N)/sin(radians(60))/2;

float dx = 2*base_radius * sin(radians(60));
float dy = base_radius/2 + 2*base_radius * cos(radians(60));

int time=0;
float dotsD=12;
float dotsR=12;

float topspeed=3;

float dot_dx=dx/dotsD;
float dot_dy=dy/dotsD;
  
static int side_x=640;
static int side_y=640;

ArrayList<Animal> animals=new ArrayList();

color[] colors = {
  color(255, 0, 128, 100), 
  color(0, 180, 180, 100), 
  color(0, 128, 255, 100), 
  color(128, 128, 255, 100), 
  color(40, 0, 200, 100), 
  color(0, 180, 40, 100),
  color(200, 160, 0, 200),
  color(200, 0, 40, 100)};
  
float psize=5;

class Animal{
  int c;
  Vec3 pos;
  Vec3 v;
  
  Animal(float x, float y, int clr){
    this.v=new Vec3(random(1)-0.5,random(1)-0.5);
    this.pos=new Vec3(x,y);
    this.c=clr;
  }
  
  void draw(){
    noStroke();
    fill(colors[this.c]);
    ellipse(pos.x, pos.y, psize, psize);
  }
  
  void move(){
    pos.add(v);
  }
}


//--
void setup() {
  size(640, 640);
  side_x=width;
  side_y=height;
   
  //size(640, 640);
  background(bg);
  frameRate(60);
  smooth(2);
  pixelDensity(1);
  strokeWeight(1);
  //noLoop();
  
  setupcubes();
  for (int f=0; f< dots.size(); f++){
    animals.add(new Animal(random(side_x), random(side_y), (int)random(colors.length)));
  }
}

void setupcubes() {
   
  int l1=5;
  int lh1=6;
  
  int l2=3;
  int lh2=6;
  
  create_cube(l1, l1, lh1, 0, 0, 0);
  create_cube(l2, l2, 6, 0, lh1, 0);
  create_cube(1, 1, 6, 0, 12, 0);
  
  create_cube(l1, l1, lh1, -90, 0, 0);
  create_cube(l2, l2, 6, -90, lh1, 0);
  create_cube(1, 1, 6, -90, 12, 0);
  
  create_cube(l1, l1, lh1, 90, 0, 0);
  create_cube(l2, l2, 6, 90, lh1, 0);
  create_cube(1, 1, 6, 90, 12, 0);
  
  create_cube(l1, l1, lh1, 180, 0, 0);
  create_cube(l2, l2, 6, 180, lh1, 0);
  create_cube(1, 1, 6, 180, 12, 0);
  
   
  
  create_cube(l1, l1, lh1, 180, 0, 90);
  create_cube(l2, l2, 6, 180, lh1, 90);
  create_cube(1, 1, 6, 180, 12, 90);
  
  create_cube(l1, l1, lh1, 180, 0, -90);
  create_cube(l2, l2, 6, 180, lh1, -90);
  create_cube(1, 1, 6, 180, 12, -90);
  
}



void draw() {
  //background(bg);
  time++;
  if(time==1000) time=0;
  fill(bg);
  rect(0,0,width, height);
  noStroke();
  //fill(0);
  //ellipse(10,10,5,5);
  calcforces();
  for (Animal a:animals){
    a.move();
    a.draw();
  }
  
  for (Vec3 d:dots){     
    d.rotateX(2.0*PI/(200));         
    d.rotateY(2.0*PI/(300));          
    d.rotateZ(4.0*PI/(600));        
  }
  
  for (int i=0; i<dots.size(); i++){
    PVector mid =new PVector(width/2, height/2);
    mid.add(dots.get(i));
    animals.get(i).pos.lerp( mid, 0.01 );
  }
  
  //saveFrame("/Users/artem/work/creative-code/life_rot/lifebig__####.png");
}
 
void calcforces(){
   
  for (Animal a:animals){
    
    for (Animal b:animals){
      if(a != b){
        
        PVector direction = PVector.sub(b.pos, a.pos);        
        float distanceSq = direction.magSq();
        float force = (a.c-2.5)*(b.c-3.3)/(0.0001 + distanceSq);
        if(distanceSq < (a.c - b.c) * (a.c - b.c+2) * psize){
          //force=-abs(force)/2;
          force=-force;
        }
        if(distanceSq<150){
          force=-abs(force);
        }
        
        if(distanceSq>700*(a.c+2)){
          force=-force;
        }
        //float mag = dir.magSq() - a.c * a.c;
        //if m
          
        
        direction.setMag(1).mult(force);
        //if (force>10) force=10;
        
        //PVector forceV = dir.normalize().mult(force);
        //forceV.mult(k*(a.c-2.5)*(b.c-3.3));
        
        a.v.add(direction);
        //b.v.sub( forceV );
        //a.v.mult(0.5);//innertia
        //a.v.lerp(b.v, 0.1);
        
        
      }      
    }
    a.v.limit(topspeed);
  }
  
  for (Animal a:animals){
    a.v.mult(0.99);//innertia
    if(a.pos.x<0) a.pos.x=0;
    if(a.pos.y<0) a.pos.y=0;
    if(a.pos.x>width) a.pos.x=width;
    if(a.pos.y>height) a.pos.y=height;
      
  }
}

void mouseReleased() {
  looping = !looping; 
  if (looping) {
    loop();
  } else {
    noLoop();
  }
}




class Vec3 extends PVector implements Comparable< Vec3 >{
  
  @Override
  public int compareTo(Vec3 o) {
    if (this == o ) return 0;
    if (this.z==o.z) return 0;
    return this.z-o.z >0? 1:-1;
  }
    
  Vec3() { super(); }
  Vec3(float x, float y) { super(x, y); }
  Vec3(float x, float y, float z) { super(x, y, z); }
  Vec3(PVector v) { super(); set(v); }

  String toString() {
    return String.format("[ %+.2f, %+.2f, %+.2f ]",
      x, y, z);
  }

  PVector rotate(float angle) {
    return rotateZ(angle);
  }
  
  boolean nearlySame(Vec3 o){
    float eps =0.001;
    return 
         Math.abs (this.x - o.x) < eps 
      && Math.abs (this.y - o.y) <eps
      && Math.abs (this.z - o.z) <eps;
  }

  PVector rotateX(float angle) {
    float cosa = cos(angle);
    float sina = sin(angle);
    float tempy = y;
    y = cosa * y - sina * z;
    z = cosa * z + sina * tempy;
    return this;
  }

  PVector rotateY(float angle) {
    float cosa = cos(angle);
    float sina = sin(angle);
    float tempz = z;
    z = cosa * z - sina * x;
    x = cosa * x + sina * tempz;
    return this;
  }

  PVector rotateZ(float angle) {
    float cosa = cos(angle);
    float sina = sin(angle);
    float tempx = x;
    x = cosa * x - sina * y;
    y = cosa * y + sina * tempx;
    return this;
  }
} 



ArrayList<Vec3> dots = new ArrayList();

boolean exists(Vec3 p){
  for (Vec3 dd : dots){
    if (dd.nearlySame(p)) return true;
  }
  return false;
}

void create_cube(int w, int h, int d,  int rot, int offset_z, int rot2) {
  int mul=30;
  for (int x = 0; x < w; x++){
    for (int y = 0; y < h; y++){
      for (int z =0; z < d; z++){
        //float ccc=45+k/20.;
        Vec3 p = new Vec3( (x-w/2) * mul, (y - h/2) * mul,  (z ) * mul + offset_z*mul );
        
        p.rotateX(radians(rot2));
        p.rotateY(radians(45 + rot ));
        //p.rotateX(radians(144.25));
        p.rotateX(radians(145));
        
        //p.rotateY(radians(random(2)-1));
        //p.rotateX(radians(random(2)-1));
        //drawDot(p);
        //if (x==y)
        if(!exists(p))
           dots.add(p);
        //print(ccc+" - ");
      }
    }
  }
}
