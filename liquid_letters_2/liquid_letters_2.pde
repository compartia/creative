//settings
static String textstr="Тошное равенство сегодня и завтра "+
"выветрен смысл пространства "+
"площади шаркают — шёпот хоронит "+
"под камнем остывшее мыло оперы "+
"скользкое зеркало лужи надвое "+
"режет велосипеда шина, туча "+
"пляжное полотенце выкручивает "+
"мысли прячутся жалкие беженцы "+
"берега линия не может тоже "+
"найти себе места под ветром "+
"Приведи, Мефистофель, Елену. Мне "+
"Срочно необходимо влюбиться. Две "+
"единицы создают между ними напряжение поля "+
"ржи население стрекочет сплетнями "+
"ловят сами себя отпевают птицы "+
"искажают метео- информацию. "+
"Нужно срочно влюбиться. Мефисто, "+
"приведи Гретхен мне, плиз, "+
"хотя бы на время, рыхлое "+
"дешевое время, иначе нет смысла. "+
"Нет. "+
"Все же — Елену.";



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

float topspeed=10;

float dot_dx=dx/dotsD;
float dot_dy=dy/dotsD;
  
static int side_x=1080;
static int side_y=1080;

ArrayList<Animal> animals=new ArrayList();
int al=240;
color[] colors = {
  //color(255, al),
  color(255, 0,0,  al),
  color(0,   al),
   
  color(0, 30, 65, al),
  color(220, 160, 0, al),
  
  
  color(200, 20, 128, al), 
  //color(10, 190, 180, al), 
  ////color(0, 128, 255, 100), 
  ////color(128, 128, 255, al), 
  color(240, 80, 200, al), 
  ////color(0, 180, 40, al/2),
  
  //color(200, 180, 40, al)
  };
float psize=5;

//--
PVector center = new PVector(640, 640);
int added_letters=0;
void setup() {
  //textstr =  textstr+textstr+textstr+textstr;
  size(1080, 1080);
  side_x = width;
  side_y = height;
   
  //size(640, 640);
  background(0);
  frameRate(90);
  smooth(4);
  pixelDensity(2);
  strokeWeight(1);
  //noLoop();
  textSize(20);
 
  //for (int t=0; t<2; t++)
  for (int f=0; f<3 ; f++){
      add_letter();
    }
  
}

void add_letter(){
  float _x = side_x/2 ;
  float _y = side_y/2;
  if(animals.size()>0){
    _x = animals.get(animals.size()-1).pos.x+ random(2) -1;
    _y = animals.get(animals.size()-1).pos.y+ random(2) -1;
  }
   //_x = side_x/2 + side_x/2*sin (animals.size() * 2*PI / 700 );
  //float _y = side_y/2 + side_x/2*cos (animals.size() * 2*PI / 700 );
  //float _y= random(3 )+100 ;
  //_x= random(width ) ;
  //_y= random(width ) ;
  Animal a = new Animal(
      _x, 
      _y, 
      (int)random(colors.length), 
      textstr.charAt(animals.size()));
  a.pos.z=random(10);
  //a.letter = textstr.charAt(f);
  if (animals.size()>0){
    a.target =  animals.get(0);
    animals.get(animals.size()-1).target = a;
    //a.target=null;
  }
  
  animals.add(a);
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
    this.w = textWidth(letter)+3;
    print(this.w);
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
  
  void draw__(boolean shad){
    pushMatrix();
    float angle = 0;
    if (target!=null){
      PVector direction = PVector.sub(pos, target.pos);        
      angle = atan2(direction.y, direction.x);            
    }
    
    translate(pos.x, pos.y);
    rotate(PI+angle); 
    
    stroke(0, 50);
    fill(255, pos.z*20, 0);    
    rect(-3, -13, w*1.2, 16, 4);
    popMatrix();
  }
  
  void draw(boolean shad){
    if(letter==' ' || letter=='\n'){
      return;
    }
    pushMatrix();
    float angle = 0;
    if (target!=null){
      PVector direction = PVector.sub(pos, target.pos);        
      //float angle = atan2(this.v.y, this.v.x);
      angle = atan2(direction.y, direction.x);            
    }
    
    translate(pos.x, pos.y);
    rotate(PI+angle); 
      
    if (shad){
      
           
    }
    
    else{
      fill(colors[this.c], 2);   
      stroke(colors[this.c], 40);
      strokeWeight(5);
      //rect(-4, -14, 2+w*1.2, 30, 5);
      rect(-3, -16, w*1.2, 20, 5);
      
      
     
      //fill(255, pos.z*20, 0);
      fill(255);
      noStroke();
      rect(-3, -16, w*1.2, 20, 5);
      
      
      //fill(colors[this.c]);
      fill(0);
      //ellipse(0+random(1), 0+random(1), w, w/4);
      text(this.letter, 0, 0);
    }      
      
      //ellipse(0, 0, psize*3, psize);
   
    popMatrix();
    
    //if(this.target!=null){
    //  if (shad){
    //    stroke(0, 3, 30, 2);
    //    line(pos.x+1, pos.y+1, this.target.pos.x+1, this.target.pos.y+1 );
    //  }else{
    //    stroke(colors[this.c] );
    //    line(pos.x, pos.y, this.target.pos.x, this.target.pos.y );
    //  }
    //}
    
    
    
  }
  
  void move(){
    pos.add(v);
  }
}


void draw() {
  if (frameCount % 15 == 0 && animals.size() < textstr.length() ){
    add_letter();
  }
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
  
  //if (frameCount>1000 && frameCount<10000 && frameCount%4==0 )
  //  saveFrame("/Users/artem/work/creative-code/life_letters_sfr/lettersr__####.png");
}
 

float MDIST=20;
//float bDIST=50;
void calcforces(){
  float center_force=(1+sin(frameCount/250.0))/25.0;
  //repulsion
  for (Animal a:animals){
       
    for (Animal b:animals){
      if (a!=b  ){     
        PVector direction = PVector.sub(a.pos, b.pos);        
        float distanceSq = direction.magSq();
        float force =  (a.w-10)/(0.001 + distanceSq);
        
        
        direction.setMag(2).mult(force);
        a.v.add(direction);
        b.v.sub(direction);
        
        //force=0;
        
      }
    }
    //a.v.limit(topspeed);
  }
  
  for (Animal a:animals){
  
    PVector directionc = PVector.sub(a.pos, center);
    directionc.setMag(center_force);
    a.v.sub(directionc);
    
    Animal b = a.target;
    //for (Animal b:animals){
    if(  b!=null){
      
      PVector direction = PVector.sub(a.pos, b.pos);
      
      float distanceSq = direction.magSq();
      //float force = 1/(0.0001 + direction.magSq());
      float dis =  a.w;//(a.w + b.w)/2;
      dis*=dis;
      //float dis = 150;
      float force = -dis  + distanceSq;//1/(0.0001 + distanceSq);
      //if (distanceSq < dis + 3 && distanceSq > dis-3){
      //  force=0;
      //}
        
      direction.setMag(0.01).mult(-force);
   
      
      b.v.sub(direction.mult(2));
      a.v.add(direction.mult(0.9));
         
      //a.v.add(b.v);
      //a.v.mult(0.5);
    }      
    //}
    
    
  }
  
  for (Animal a:animals){
    
    a.v.mult(0.99);//innertia
    if(a.pos.x<0) a.pos.x=0;
    if(a.pos.y<0) a.pos.y=0;
    if(a.pos.x>width) a.pos.x=width;
    if(a.pos.y>height) a.pos.y=height;
    
    if(a.pos.z>10) a.pos.z=10;
    if(a.pos.z<0) a.pos.z=0;
     
    
    
    a.v.limit(1);
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
