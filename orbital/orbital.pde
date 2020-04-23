int loops = 6;
int animationLen = loops*8 * 30;

Eye s1;
//Eye s2;
void setup() {
  size(540,540,P3D);
  //x = width/2;
  //y = height/2;
  //z = 0;
  frameRate(30);
  smooth(4);
  pixelDensity(2); //retina
  
  s1 = new Eye(new PVector(0,0,0));
  //s2 = new Eye(new PVector(400,0,0));
}


class Eye{
  PShape sun;
  PShape moon;
  PVector pos;
  PVector moonpos;
  float orbitr = 100;
  float r = 120;
  float moon_r;
  public Eye(PVector pos){
    moon_r = r/3;
    orbitr = r+moon_r*1.2; 
    this.pos=pos;
    translate(pos.x, pos.y, pos.z);
    fill(255);
    noStroke();
    sun = createShape(SPHERE,  r/2);
    
    moonpos = new PVector(orbitr,0,0);
    
    fill(255);
    //translate(moonpos.x, moonpos.y, moonpos.z);
    moon = createShape(SPHERE,  moon_r/2);
    
   
    //fill(255, 0, 0);
    
    
    
  }
  
  public void show(int frame){
    float angle = loops * TWO_PI * ( frame % (animationLen))/(float)animationLen;
    
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    //PVector hplane = (1, 0, 1);
    //PVector rot = hplane.cross(this.moonpos); // perpendicular 
    //rotate(0,0,0.01);
    
    //pointLight(255, 0, 0, 0, 0, 1000);
    
    
    
    shape(sun);
    moonpos.x=orbitr * sin(angle);
    moonpos.z=orbitr * cos(angle);
    directionalLight(255, 255, 255, moonpos.x, moonpos.y, moonpos.z);
    
    translate(moonpos.x, moonpos.y, moonpos.z);
    //moon.resetMatrix();
    //moon.scale(random(1,2));
    
    shape(moon);
    
    popMatrix();
  }
}

void draw() {
  //scale(0.5);
  background(0);
  
  //rectMode(CENTER);
  //sphere(100);
  
  
  
  //fill(255, 40);
  
  
  
  pushMatrix();
  translate(width/2, height/2, 0);
  
  
  blendMode(BLEND);
  s1.show(frameCount);
  blendMode(ADD);
  fill(40);
   
  stroke(30);
  strokeWeight(2);
  ellipse(0,0, s1.r+s1.r/3, s1.r+ s1.r/3);
  
  //rectMode(CENTER);
  
  float str_w = s1.r/2.5;
  float str_t = s1.r;
  float str_b = height/2 - +s1.r/5;
  blendMode(BLEND);
  rect(0-str_w/2, str_t,
      str_w, str_b-str_t, str_w/2.1);
  //ellipse(0, str_t, str_w, str_w);
  //ellipse(0, str_b, str_w, str_w);
  
  
  //s2.show(frameCount);
  //lights();
  
  drawVeco(frameCount-10);
  
  popMatrix();
  
  fill(255);
  rect(0,140,3,20);
  
  if(frameCount<animationLen)
    saveFrame("/Users/artem/work/creative-code/orbital-render/opart__####.png");
}

public void drawVeco(int frame){
  int fragment_len = animationLen/loops;
    float phase =   ( frame % fragment_len)/(float)fragment_len;
    
    
    
    float a_start=0.96;
    float a_end=0.99;
    
    float sc = 0;
    if(phase>a_start && phase<a_end){
      sc =  (phase - a_start) / (a_end-a_start);
      println(sc);
      sc = cos(PI/2 - PI *sc);
      
    }
    
    pushMatrix();
    translate(0,0,300);
    noFill();
    fill(0,0,255);
    noStroke();
    //stroke(255, 0,0);
    //noStroke();
    //rectMode(CENTER);
    rect(-width/2, -50, width, sc*50 );
    rect(-width/2, 50-sc*50, width, sc*50 );
    popMatrix();
    
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
