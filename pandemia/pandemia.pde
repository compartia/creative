import java.util.Comparator;
import java.util.Arrays;

boolean SAVE_IMAGES= true;
String poem_tmp = "xxxx";




String poem = poem_tmp.toUpperCase().replaceAll("--","—").replaceAll(" "," ") ;
float ts=25;

PFont f;

Unit[] units;
 
   
float INF_D=5;
float motion_blur_steps=5;
 
void setup(){
  //motion_blur_steps=16;
  
  //size(1080, 1080);//Instagramm best
  size(540, 540); //testing FPS-optimal
  //2560x1440 1280 x 720
  //size(1280, 720);//Youtube 2K
  background(0,0,0);
  pixelDensity(2);
  frameRate(60);
  //smooth(4);
  
  float screen_side_len = sqrt(height*width);
  ts = screen_side_len/70;
  f = createFont("FiraSans-Regular.ttf",ts,true);
  
  
  textFont(f, ts);
  textSize(ts);
  
  dots = makeDots();
  makeUnits(dots.size());
  
  for (int l=0; l<units.length; l++){
     Unit u =units[l];
     PVector d=dots.get(l);
     u.home = d;
      
     u.pos.x = randomGaussian() * width *0.5;
     u.pos.y = randomGaussian() * height*0.5;
  }
  units[0].infected_cells=0.4;// = true;
  units[1].infected_cells=0.9;// = true;
  INF_D=screen_side_len/50;
  //
}

class MovingObject{
  PVector pos, v, home;
  boolean locked;
  float pathlen;
  float angle;
}

int KIND_DOC=0;
int KIND_CIVIL=1;

float minimal_infection = 0.001;
float critical_infection = 0.01;
float lethal_infection = 0.9;

class Unit extends MovingObject{
   
  
  String c;
  //float w;
  //boolean infected;
  
  //float illnesTime=0;
  float immune_power; //gaussain 0..1 and 1 is more probable; green channel
  
  int kind=KIND_CIVIL;
  float infected_cells=0;
  
  Unit( ){    
    immune_power = abs(randomGaussian());
    pos = new PVector();
    v = new PVector();
  }
  
  
  void updateImmune(){
    //if(infected){
      //illnesTime+=1;
      if(immune_power>infected_cells){
        infected_cells /=1.00001; 
        //immune_power/=1.00001;
      }
      
      if(immune_power<infected_cells){
        infected_cells *=1.0002; 
        //immune_power/=1.00001;
      }
      //immune_power=1-infected_cells;
      
      
      immune_power*=1.001;
      infected_cells *=1.00001;
      
      if (immune_power>1){
        immune_power=1;
      }
      
      if (infected_cells>1){
        infected_cells=1;
      }
    //}
  }
  
  boolean infected(){
    return infected_cells>0.001;
  }
  
  void updateVelocity(Unit[] all){
    
    //if(!isAlive() )
    //  return;
      
    if(immune_power<0.01 )
      return;
    updateImmune();
    
      
    //if(illnesTime>850){
    //  infected=false;
    //  locked = false;
    //  illnesTime=0;
    //}
    //if(this.locked)
    //  return;
    
    //float minmag=height+width;
     
    for(Unit l:all){
      if(l!=this && l.isAlive() ){
        PVector d = PVector.sub(l.pos, pos);
        float mag = d.mag();
       
        
        if(mag < INF_D  ){
          l.infected_cells +=  random(1) * infected_cells *0.8;
           
        }
      }
    }
    
     
    
    //EACH OTHER mean stream
    for(Unit l:all){
      if(l!=this  ){
        float d=pos.dist(l.pos);
        
        float k = 20.9* 1.0/(1.0+d*d*d);
        //if (l.infected()){
        //  k*=0.36;
        //}
         
         //if(d<width/10)
           v.add (l.v.copy().mult(k) );
       }
      
    }
    
    // to GRID
    if(frameCount>0){
      PVector d = PVector.sub(home, pos);
      if(d.mag()<1){
        this.locked=true;
      }else{
        this.locked=false;
      }
      d.mult(0.007);
      //if(infected())
      //  d.mult(1.5);
      v.add(d);  
    }
    
    if(v.mag()>10){
      v.setMag(10);
    }
  }
  
  void move(float al){
    //if(!isAlive() )
    //  return;
    float dempfer=1;
    if(this.locked)
      dempfer=0.1;
      
    PVector addon = PVector.mult(v, 0.3*(immune_power+0.1) * al * dempfer);
    pos.add( addon);
    pathlen+=addon.mag();
    //if(infected){
    //  v.mult(0.85); //innertia
    //}else
   
  }
  
  boolean isAlive(){
    return immune_power>0.1;
  }
  
  void decay(){
     v.mult(0.883); //innertia
  }
  
  void draw(float al){
    float g = immune_power*255;
    float r =1. - 1.0/(1.+(float)infected_cells);// infetiousnes
    r*=255;
    float b=128;
    pushStyle();
     fill(r, g, b, al*170);
    pushMatrix();
    translate( pos.x ,  pos.y);
    
    float angle_2 = atan2(this.v.y, this.v.x);
    angle = lerp( angle, angle_2, 0.1);
    //angle*=0.9;
    //rotate(PI+angle); 
    
    //rotate(radians(10));
    noStroke();
    ellipse( 0,0, width/280., width/280.0);
    popMatrix();
    popStyle();
  }
 
  
}
 
 

PVector bbox;
ArrayList<PVector> dots;

 
void makeUnits(int amount){
  units=new Unit[amount];
   
  
  float x=0;
  float y=0;
  
  //float maxX=0;
  //float maxY=0;
  
  for(int i=0; i<amount; i++){
    //String cc = line.substring(i,i+1);
    //float w = textWidth(cc);
   
     
    units[i]=new Unit();
    units[i].pos = new PVector(x, y);
    //units[i].w=w;
    
 
    //if (x > maxX) maxX=x;
    //if (y > maxY) maxY=y;
    
    //x+=w;
    
    //if("\n".equals(cc)){
    //  y += lineHeight*ts;
    //  x=0;
    //}
  }
  
 
  //return new PVector(maxX, maxY);
}

 
float speed = 1.0/180.0;



int currentLetter=0;
 

int k=0;
float rotation_offset=40;
float rotation_speed=10;
float rotation_wave=10;
void draw(){
  if(frameCount%2==0){
    fill(10,10,50, 8);
    rect(0,0,width, height);
  }
  //background(10,10,50);
  //k++;
  //background(0);
  //fill(255, 140);
  
 // if (rotation_offset>0)
   rotation_offset *= .994;
   
   rotation_speed*=0.995;
   rotation_wave*=0.95;
  //drawPoem( );
  
  
  
  fill(255, 3);
  translate(width /2,  height /2);//ceter text on screen
    //scale(1.3);
   
  noStroke();
  //for (int l=0; l<dots.size(); l++){
  //  PVector dot = dots.get(l); 
  //  ellipse(dot.x, dot.y, 3, 3);    
  //}
  
  for (Unit u:units){
    u.updateVelocity(units);    
  }
  
  for (Unit u:units){
    
    for (int al=0; al<motion_blur_steps; al++){
      u.move(1./motion_blur_steps);
      u.draw(1./motion_blur_steps);
    }    
    
    u.decay( );
  }

 
  if(frameCount<60*30 && SAVE_IMAGES)
    saveFrame("/Users/artem/work/creative-code/twirl2/poem__####.png");
}




ArrayList<PVector> makeDots( ){
  int N=4;
  float offset =  min(width, height)/10.0;
  float dist  = min(width, height)/(float)N;
  
  float base_radius=N*dist;//(width/N)/sin(radians(60))/2;
  print(base_radius);
  float dotsX=dist;//width/dist;
  float dotsY=dist;//height/dist;
  float dx = 2*base_radius * sin(radians(60));
  float dy = base_radius/2 + 2*base_radius * cos(radians(60));

  float dot_dx=dx/dotsX;
  float dot_dy=dy/dotsY;
  
  //float dotsR=12;
   
  ArrayList<PVector> list = new ArrayList();
 
  
  int yc=0;
  for(float y=-height/2+offset; y< height/2-offset; y+=dot_dy){
    float o = yc%2 ==0? 0 : dot_dx/2;
    
    for(float x=-width/2+offset; x< width/2-offset; x+=dot_dx){    
       
      PVector pv = new PVector(  x+o,   y);       
      list.add(pv);
                    
    }
    yc++;
  }
  
  return list;
   
  
}

void mouseReleased() {
  looping = !looping; 
  if (looping) {
    loop();
  } else {
    noLoop();
  }
  println(frameCount );
  saveFrame("/Users/artem/work/creative-code/poem_letters_cache.snaps/poem__####.png");
}
