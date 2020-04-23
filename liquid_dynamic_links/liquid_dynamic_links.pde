//settings
static String textstr="Форма нуля в слове чучело-вечность — "+ 
"лого собой увлеченности. "+

"Форма "+
"чело-увечности тишиной "+
"тесной и кол- "+
"бой со спиртом и с "+

"форма- "+
"лином. "+

"Травит змея-альбинос "+
"свой парафиновый хвост — "+

"форма "+
"браслета часовой бомбы "+
"у пса по имени Кербер на горле, "+
"у пса, приуроченного "+
"к открытию коробки Пандоры. "+
"Упс. А надежду оставили.";



boolean fillStar=false;
boolean drawHex=false;
boolean drawBoxSides=false;

static int side=640*2;

color base_color = color(170,50,230);
color bg = color(5, 30, 40, 1);

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
  
static int side_x=1080;
static int side_y=1080;

ArrayList<Animal> animals=new ArrayList();
int al=40;
color[] colors = {
  color(255,   al),
  color(255, 0,0,  al),
  color(0,   al),
   
  color(0, 30, 65, al),
  color(200, 160, 0, al),
  
  
  //color(255, 0, 128, al), 
  color(10, 190, 180, al), 
  ////color(0, 128, 255, 100), 
  ////color(128, 128, 255, al), 
  ////color(40, 0, 200, 100), 
  //color(0, 180, 40, al/2),
  
  //color(200, 0, 40, al)
  };
float psize=5;

//--
void setup() {
  textstr =  textstr+textstr+textstr+textstr;
  size(1080, 1080);
  side_x=width;
  side_y=height;
   
  //size(640, 640);
  background(0);
  frameRate(90);
  smooth(4);
  pixelDensity(1);
  strokeWeight(1);
  //noLoop();
  textSize(20);
  Animal prev=null;
  
  float spread = 200;
  //for (int t=0; t<2; t++)
    for (int f=textstr.length()-1; f>=0 ; f--){
      
      Animal a = new Animal(
        width/2 +  random(side_x/20) - side_x/10, 
        height/2 + random(side_y/20) - side_y/10, 
        (int)random(colors.length), 
        textstr.charAt(f));
        
      //a.letter = textstr.charAt(f);
      a.target = prev;
      animals.add(a);
      
      prev=a;
    }
  animals.get(0).target = prev;
  
}


class Animal{
  int c;
  PVector pos;
  PVector v;
  char letter;
  Animal target, child;
  float w;
  float mass;
  
  Animal(float x, float y, int clr, char letter){
    this.v=new PVector(random(1)-0.5,random(1)-0.5);
    this.pos=new PVector(x,y);
    this.c=clr;
    this.letter=letter;
    this.w=textWidth(letter);
    this.mass=0.1+random(2.0);
  }
  
  void setTarget(Animal t){
    if (this.target!=null){
      this.target.child=null;
    }
    this.target = t;
    if (t!=null){
      if(t.child!=null)
        t.child.target = null; //unlink old child
      t.child = this;
    }
  }
  
  void draw(boolean shad){
    pushMatrix();
    float angle = atan2(this.v.y, this.v.x);
    
    translate(pos.x, pos.y);
    rotate(PI+angle); 
    if (shad){
      noStroke();
      
      //fill(0, 2);
      fill(50, 2, 20, 3);
      ellipse(2, 2, 2.0*psize, w/3);
    }
    
    else{
      noStroke();
      fill(colors[this.c]);    
      ellipse(0+random(1), 0+random(1), w, w/4);
    }
      
      
      //ellipse(0, 0, psize*3, psize);
      
      //text(this.letter, 0, 0);
   
    popMatrix();
    
    if(this.target!=null){
      if (shad){
        stroke(0, 3, 30, 2);
        line(pos.x+1, pos.y+1, this.target.pos.x+1, this.target.pos.y+1 );
      }else{
        stroke(colors[this.c] );
        line(pos.x, pos.y, this.target.pos.x, this.target.pos.y );
      }
    }
    
    
    
  }
  
  void move(){
    pos.add(v);
  }
}


void draw() {
  //background(0);
  noStroke();
  
  calcforces();
  
  for (Animal a:animals){
    
    a.draw(true);
  }
  
  for (Animal a:animals){
    a.move();
    a.draw(false);
  }
  
  //if (frameCount>1000 && frameCount<10000 && frameCount%500==0 )
  //  saveFrame("/Users/artem/work/creative-code/life_letters_sf/letters__####.png");
}
 
PVector center = new PVector(640, 640);
float MDIST=20;
float bDIST=50;
void calcforces(){
  
  
  ////relink
  //for (Animal a:animals){
    
  //  if (a.target!=null){
  //    if (a.target.target==a){
  //      a.setTarget(null);
  //    }
  //  }
    
  //  float distanceSq_t=0;
  //  if (a.target!=null){
  //    PVector direction = PVector.sub(a.pos, a.target.pos);        
  //    distanceSq_t = direction.magSq();
  //    if (distanceSq_t > bDIST*bDIST && a.c!=a.target.c){
  //      a.setTarget(null);
  //    } 
      
  //    if (distanceSq_t > 8*bDIST*bDIST  ){
  //      a.setTarget(null);
  //    } 
  //  }
    
  //  for (Animal b:animals){
  //    if (a!=b ){     
  //      PVector direction = PVector.sub(a.pos, b.pos);        
  //      float distanceSq = direction.magSq();
               
  //      if (distanceSq < MDIST*MDIST && distanceSq_t < distanceSq){   
  //        if (b.target==null) b.setTarget(a);
  //      }
        
  //      //if (distanceSq < MDIST*MDIST && distanceSq_t < distanceSq){   
  //      //  if (a.c == b.c && random (1000)<1)
  //      //    b.setTarget(a);
  //      //}
  //    }
  //  }
  //  //a.v.limit(topspeed);
  //}
  
  //repulsion
  for (Animal a:animals){
       
    for (Animal b:animals){
      if (a!=b ){     
        PVector direction = PVector.sub(a.pos, b.pos);        
        float distanceSq = direction.magSq();
        float force = 30/(0.0001 + distanceSq);
        
       if (a.target!=null || a.child!=null){
         force/=3.0;
       }
       
       if (a.c != b.c){
         force*=3;
       }
        
        direction.setMag(1).mult(force);
        a.v.add(direction);
        
        //force=0;
        
      }
    }
    //a.v.limit(topspeed);
  }
  
  for (Animal a:animals){
    
    //color ccc = get( (int)a.pos.x, (int)a.pos.y);
    ////float cx = red(ccc-128)/255.0f;
    //float cy = (red(colors[a.c]) - red(ccc)) /155.0f;
     
    //float cx = (green(colors[a.c]) - green(ccc)) /155.0f;
    //cx+= (blue(colors[a.c]) - blue(ccc)) /155.0f;
     
    //PVector direction_color = new PVector(cx , cy);
   
    //a.v.sub(direction_color);
    
    PVector directionc = PVector.sub(a.pos, center);
    directionc.setMag(0.5);
    a.v.sub(directionc);
    
    Animal b = a.target;
    //for (Animal b:animals){
      if(  b!=null){
        
        PVector direction = PVector.sub(a.pos, b.pos);
        
         
        float distanceSq = direction.mag();
        //float force = 1/(0.0001 + direction.magSq());
        float force = (MDIST)  - 0.5/(0.0001 + distanceSq);
     //force-=random(1);
         //if (distanceSq<MDIST){
         //   force =0;
         // }
        direction.setMag(0.8).mult(-force);
 
        
        b.v.sub(direction);
         
      //}      
    }
    
  }
  
  for (Animal a:animals){
    
    a.v.mult(1.0/a.mass);//innertia
    if(a.pos.x<0) a.pos.x=0;
    if(a.pos.y<0) a.pos.y=0;
    if(a.pos.x>width) a.pos.x=width;
    if(a.pos.y>height) a.pos.y=height;
      
    //PVector direction = PVector.sub(a.pos, a.target.pos);        
    //float distanceSq = direction.mag();
    //if(distanceSq<10){
    //  a.c = 2;
    //  a.target.c =2;
    //}else{
    //   a.c = (int)random(colors.length);
    //  a.target.c =(int)random(colors.length);
    //}
    a.v.limit(topspeed/3);
  }
}

void mouseReleased() {
  looping = !looping; 
  if (looping) {
    loop();
  } else {
    noLoop();
  }
  println(frameCount);
  saveFrame("/Users/artem/work/creative-code/life_letters_snaps/letters__####.png");
}
