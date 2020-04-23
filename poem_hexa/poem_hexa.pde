import java.util.Comparator;
import java.util.Arrays;

boolean SAVE_IMAGES=true;
String poem_tmp=  
  "                         мы некогда были газом,\n"+
"заполняя собой пространство,\n"+
"гоняли бизонов в саванне,\n"+
"спорадически создавали\n"+
"слабые детородные связи,\n"+
"открывая тем самым переход фазовый, и\n"+
"мы превратились в воду.\n"+
"в течения, тренды и людовороты,\n"+
"в рококо турбульона, в завитки моды.\n"+
"поплатились, видимо, за фертильность.\n"+
"в реках дорог плотины, тромбы\n"+
"в трубах метро,\n"+
"И вот новый фазовый переход.\n"+
"Теперь мы в решетке кристалла,\n"+
"в кубиках комнат, в отелях капсульных,\n"+ 
"миллиарды уединений замерших,\n"+
"полное оледенение глобуса\n"+

"в принципе, жизнь -- это структура\n"+
"с маленькой энтропией,\n"+
"призванная лишь рассеивать\n"+ 
"градиент энергии";




String poem = poem_tmp.toUpperCase().replaceAll("--","—").replaceAll(" "," ") ;
float ts=25;

PFont f;

Letter[] letters;
 
 
 
float lineHeight=1.62;
int minFramesStill = 50;

float INF_D=4;
void setup(){
  
  //size(864, 1080);//Instagramm best
  size(600, 600); //testing FPS-optimal
  background(200,0,0);
  //pixelDensity(2);
  frameRate(30);
  //smooth(4);
  
  ts = height/82;
  f = createFont("FiraSans-Regular.ttf",ts,true);
  
  
  textFont(f, ts);
  textSize(ts);
  
  dots = makeDots();
  bbox = makeLetters(poem);
  
  for (int l=0; l<letters.length; l++){
     PVector d=dots.get(l);
     letters[l].target=d;
    if(random(1)<0.01)
      letters[l].infected = true;
      
     letters[l].pos.x = randomGaussian() * width *0.5;
     letters[l].pos.y = randomGaussian() * height*0.5;
  }
  
  INF_D=20;//width/500.0;
  //
}


class Letter{
  PVector pos, target, v;
  
  String c;
  float w;
  boolean infected;
  boolean locked;
  float illnesTime=0;
  Letter focus=this;
  
  float angle;
  
  Letter(String c){
    this.c=c;
    pos = new PVector();
    //target=new PVector();
    v = new PVector();
  }
  
  void updateVelocity(Letter[] letters){
    if(infected)
      illnesTime+=1;
      
    if(illnesTime>850){
      infected=false;
      locked = false;
    }
    if(this.locked)
      return;
    
    float minmag=height+width;
     
    for(Letter l:letters){
      if(l!=this ){
        PVector d = PVector.sub(l.pos, pos);
        float mag = d.mag();
        if(mag<minmag && mag > INF_D && l.focus!=this){
          minmag=mag;
          focus = l;
        }
        
        if(mag<INF_D  ){
          if(random(illnesTime+1)<0.001){
            l.infected=infected ||  l.infected;
            infected=infected ||  l.infected;
          }
        }
      }
    }
    
     
    //PURSUE FOCUS
    if(focus!=null ){
      PVector d = PVector.sub(focus.pos, pos);
      float mag = d.mag();
      //if(!infected){
       if(mag < width/2){
        d.mult(0.07);
        if(infected){
          d.mult(1/(illnesTime+1));
        }
        //if(mag < 1.99*INF_D)
        //  d.mult(-1);
        v.add(d);
      }
    }
     
    
    
    //EACH OTHER mean stream
    for(Letter l:letters){
      if(l!=this  ){
        float d=pos.dist(l.pos);
        float k = 0.4* 1.0/(1.0+d*d);
        if (l.infected){
          k*=0.5;
        }
         v.add (l.v.copy().mult(k) );
       }
      
    }
    
    // to GRID
    if(frameCount>0){
      PVector d = PVector.sub(target, pos);
      if(d.mag()<0.1){
        this.locked=true;
      }
      d.mult(0.007);
      if(infected)
        d.mult(1.5);
      v.add(d);  
    }
    
    if(v.mag()>10){
      v.setMag(10);
    }
  }
  
  void move(){
    if(this.locked)
      return;
      
    pos.add( PVector.mult(v, 0.17));
    //if(infected){
    //  v.mult(0.85); //innertia
    //}else
    v.mult(0.89); //innertia
  }
  
  void draw(){
    pushStyle();
    if(infected){
      fill(0);
    }else{
      fill(255);
    }
    pushMatrix();
    translate( pos.x -  w/2,  pos.y+ts/2);
    
    float angle_2 = atan2(this.v.y, this.v.x);
    angle = lerp( angle, angle_2, 0.1);
    //angle*=0.9;
    rotate(PI+angle); 
    
    //rotate(radians(10));
    text( c, 0,0);
    popMatrix();
    popStyle();
  }
 
  
}
 
 

PVector bbox;
ArrayList<PVector> dots;

 
PVector makeLetters(String line){
  letters=new Letter[poem.length()];
   
  
  float x=0;
  float y=0;
  
  float maxX=0;
  float maxY=0;
  
  for(int i=0; i<line.length(); i++){
    String cc = line.substring(i,i+1);
    float w = textWidth(cc);
   
     
    letters[i]=new Letter(cc);
    letters[i].pos = new PVector(x, y);
    letters[i].w=w;
    
 
    if (x > maxX) maxX=x;
    if (y > maxY) maxY=y;
    
    x+=w;
    
    if("\n".equals(cc)){
      y += lineHeight*ts;
      x=0;
    }
  }
  
 
  return new PVector(maxX, maxY);
}

 
float speed = 1.0/180.0;

int motionblur_steps=24;

int currentLetter=0;
 

int k=0;
float rotation_offset=40;
float rotation_speed=10;
float rotation_wave=10;
void draw(){
  background(200,30,0);
  //k++;
  //background(0);
  //fill(255, 140);
  
 // if (rotation_offset>0)
   rotation_offset *= .994;
   
   rotation_speed*=0.995;
   rotation_wave*=0.95;
  //drawPoem( );
  
  //if(frameCount<3000 && SAVE_IMAGES)
  //  saveFrame("/Users/artem/work/creative-code/poem_letters_cache.out/poem__####.png");
  
  fill(255, 190);
  translate(width /2, ts*2 + height /2);//ceter text on screen
    scale(1.3);
  for (int l=0; l<letters.length; l++){
    letters[l].updateVelocity(letters);
  }
  for (int l=0; l<letters.length; l++){
    letters[l].move();
    letters[l].draw();
   
  }

  //int l=0;
  //for (int l=0; l<letters.length; l++){
  //   PVector d=dots.get(l);
  //   pushMatrix();
  //    translate(d.x, d.y);
  //    //scale(1,0.9);
  //    rotate(radians(15));
  //    //rotate(radians(15. + (float)frameCount*rotation_speed) + (sin (d.x/20) + cos (d.y/30))* rotation_wave );
  //    text(letters[l].c, -letters[l].w/2 + rotation_offset, ts/2);
  //    //ellipse(15, 0, 5,5);
  //    //l=(l+1) % letters.length;
  //    popMatrix();
  //}
  //for (PVector d :dots){
    
  //}
}




ArrayList<PVector> makeDots( ){
  int N=3;
  float base_radius=(width/N)/sin(radians(60))/2;
  float dotsD=13;
  float dx = 2*base_radius * sin(radians(60));
  float dy = base_radius/2 + 2*base_radius * cos(radians(60));

  float dot_dx=dx/dotsD;
  float dot_dy=dy/dotsD;
  
  //float dotsR=12;
   
  ArrayList<PVector> list = new ArrayList();
 
   
  
  for(float y=-(N/2)*dotsD; y< (N/2)*dotsD; y+=1){
    float o = y%2 ==0? 0:dot_dx/2;
    
    for(float x=-(N/2)*dotsD; x<(N/2)*dotsD; x+=1){       
       
      PVector pv = new PVector(  x*dot_dx+o,   y*dot_dy);       
      list.add(pv);
                    
    }
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
