int loops = 6;
int animationLen = 60 * 30;

float orbitr = 170;
float moon_r = 2.3;
int initialCount = 4900;
void setup() {
  size(540,540,P3D);
  //x = width/2;
  //y = height/2;
  //z = 0;
  frameRate(60);
  smooth(4);
  pixelDensity(2); //retina
  
 
  initGeo();
  //s2 = new Eye(new PVector(400,0,0));
}


ArrayList<Moon> moons=new ArrayList();

void initGeo(){
  for(int i=0; i<initialCount; i++){
    Moon v = new Moon();     
    moons.add(v);
  }
}


class Moon{
   
  PShape moon;
  PVector pos;
  PVector velocity;
 
  public Moon(){

    pos = PVector.random3D();
    velocity = PVector.random3D();
    pos.setMag(orbitr);
     
    translate(pos.x, pos.y, pos.z);
    noStroke();
    fill(255);
    
    moon = createShape(SPHERE,  moon_r);
    
  }
  
  public void show(int frame){
    //float angle = loops * TWO_PI * ( frame % (animationLen))/(float)animationLen;
    
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateZ(pos,  PI/30 );
    //rotate(0);
 
    //shape(sun);
    //pos.x+= sin(angle);
    //pos.z+= cos(angle);
    //directionalLight(255, 255, 255, moonpos.x, moonpos.y, moonpos.z);
    
    //translate(moonpos.x, moonpos.y, moonpos.z);
        
    pos.setMag(orbitr);
    shape(moon);
    
    popMatrix();
  }
}


void showMoons(){
  for (Moon moon: moons){
    moon.show(frameCount);
  }
}

void moveMoons(){
  for (Moon moon1: moons){
    for (Moon moon2: moons){
      if (moon1!=moon2){
        //PVector dir_rd =  PVector.random3D();//
        //dir_rd.setMag(0.2);
        PVector dir = PVector.sub(moon1.pos, moon2.pos);
        
        //dir.mult(0.1);
        float r = dir.mag();
        if (r<1) r=1;
        dir.setMag(10).mult(1.0/(r));
        //dir.add(dir_rd);
        
        dir.mult(random(1));
        moon1.velocity.add(dir);
        moon2.velocity.sub(dir);
      }
    }
  }
  
  //for (Moon moon: moons){
  //   PVector m2 = moon.pos.copy().setMag(orbitr);
  //   PVector dir = PVector.sub(moon.pos, m2);
  //   dir.setMag(1);
  //   moon.velocity.add(dir);
  //}
  
  for (Moon moon: moons){
    moon.velocity.mult(0.98);
    
    
    //if(moon.pos.x>0){
    //  moon.velocity.z-=10;
    //}
    
    moon.pos.add(moon.velocity);
    moon.pos.setMag( lerp(orbitr+5*sin( moon.velocity.mag()/10.) , moon.pos.mag(), 0.01));
    //print(moon.velocity);
  }
  
  
}
 

void draw() {
  ortho();
  //moon_r = random(2,20);//orbitr*orbitr / (60*moons.size());
  background(0);
  
   
  pushMatrix();
  translate(width/2, height/2, 0);
  
  //lights();
  //ambientLight(60, 60, 80);
  ambientLight(240, 240, 240);
  Moon moon0=moons.get(0);
  Moon moon1=moons.get(1);
  Moon moon2=moons.get(2);
  //pointLight(180, 180, 180, 100,-400,400);
  //pointLight(0, 0, 100, 0, 0, 0);
  //directionalLight(180, 180, 180, moon2.pos.x, moon2.pos.y, moon2.pos.z);
  moveMoons();
  showMoons();   
 
 
  popMatrix();
  
  if(frameCount>50){
    if(frameCount % 10 ==0){
      for(int f=0; f<1; f++){
        Moon v = new Moon();     
        moons.add(v);
      }
      println(frameCount, moons.size());
    }
  }
  
 
  
  if(frameCount<animationLen)
    saveFrame("/Users/artem/work/creative-code/orbital-n-b/opart__####.png");
}

 
 
 
void rotateZ(PVector v, float angle) {
  float cosa = cos(angle);
  float sina = sin(angle);
   
  float x = cosa * v.x - sina * v.z;
  float z = cosa * v.z + sina * v.x;
  
  v.x=x;
  v.z=z;
}

void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/orbital/opart__####.png");
    //if(looping){
    //  noLoop();
    //}else{
    //  loop();
    //}
    //looping=!looping;
}
