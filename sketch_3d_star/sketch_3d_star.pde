 

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
  int mul=10;
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


void setup() {
  size(640, 640);
  noStroke();
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

float k=0;
int loop_time = 30;
int fps = 60;
int total_frames=loop_time*fps;
int segement = total_frames/8;
void draw(){
  k++;
  fill(0, 10);
  blendMode(BLEND);

  rect(0,0, width, height);
  

  //background(0, 10);
  blendMode(BLEND);
  translate(width/2, height/2);
  scale(2,2);
  java.util.Collections.sort(dots);
  float min_z = dots.get(0).z;
  for (Vec3 d:dots){   
    drawDot(d, min_z, 6);
  }
  translate(-width/2, -height/2);
  fill(0, 60);
  rect(0,0, width, height);
  translate(width/2, height/2);
  blendMode(ADD);
  for (Vec3 d:dots){   
    drawDot(d, min_z, 3);
  }
  
  
  //blendMode(ADD);
  translate(240, 0);
  java.util.Collections.sort(dots);
  for (Vec3 d:dots){   
    drawDot(d, min_z, 4);
  }
  
  translate(-480, 0);
  java.util.Collections.sort(dots);
  for (Vec3 d:dots){   
    drawDot(d,min_z, 4);
  }
  
  if (frameCount<total_frames)
    for (Vec3 d:dots){
      if (frameCount > segement && frameCount <= 4*segement)
        d.rotateX(2.0*PI/(segement*2));
        
      if (frameCount > segement*2)
        d.rotateY(2.0*PI/(segement*8));
        
      if (frameCount > segement*3)
        d.rotateZ(4.0*PI/(segement*4));
      //d.rotateZ(4.0*PI/total_frames);
      
    }
    //saveFrame("/Users/artem/work/creative-code/crystals2/stars__####.png");
}

void drawDot(Vec3 p, float min_z, float rad){
  noStroke();
   
  float depth = 2 * abs(min_z);
  float rddepth= abs((depth/2 + p.z  )/ depth);
  //float a = random(rddepth ) ;
  //print(a);
  fill( 255*rddepth, 255*rddepth, 255*rddepth, (200*rddepth)/2);
  //float rnd1 =-( (-p.z+150f )/12);
  //float rnd2 =-( (-p.z+150f )/12);
  //fill(255, 255*a);
  float r=rad+5*(1.-rddepth);
  //ellipse(p.x+random(rnd1/4.0), p.y+random(rnd2/.0) , r+rnd1, r+rnd2);
  ellipse(p.x +random(r-r/2)/4 , p.y+random(r-r/2)/4  , r , r );
}
