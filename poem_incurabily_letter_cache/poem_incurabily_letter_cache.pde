import java.util.Comparator;
import java.util.Arrays;

boolean SAVE_IMAGES=true;
String poem_tmp=
  "Приплыли, Сеньорита!\n"+
  "Fondamenta degli Incurabili.\n"+
  "Ложитесь, загорайте, \n"+
  "ваш случай неизлечим.\n"+
  "Прикройте веки монетами \n"+ 
  "от ультрафиолета лучей --\n"+
  "тут уже не Венеция.\n"+
  "Не удивляйтесь, но\n"+
  "это конечная лодочная станция\n"+
  "-- Варанаси. Да,\n"+
  "я бы тоже подумал “нихуясе”,\n"+
  "но следует проверить гипотезу о\n"+ 
  "метемпсихозе.";




String poem = poem_tmp.toLowerCase().replaceAll("--","—").replaceAll(" "," ") ;
float ts=25;

PFont f;

Letter[] letters;
Glyph[] glyphs;
 
 
float lineHeight=1.62;
int minFramesStill = 50;
class Letter{
  PVector pos, def;
  String c;
  
  Letter(String c){
    this.c=c;
  }
  
  void animate(){   
    //if(def==null){
    //  def = pos.copy();
    //}
    
    //pos.x = def.x +  20.* sin ( (float)frameCount/200+ 5*pos.y/width) ;
    //pos.y = def.y +  20.* cos ( (float)frameCount/200+ 5*pos.x/width) ;
  }
  
  
}

class GComparator implements Comparator<Glyph> {
 int compare(Glyph a, Glyph b) {    
   return -a.stillFrames+b.stillFrames;
 }
}
GComparator aGComparator=new GComparator();

class Glyph extends Letter{
  int stillFrames=0;
  Letter target;
  float deg=0;
   
  float phase = 0;
  
  PVector speed = new PVector();
  
  Glyph(String c){
    super(c);
  }
  
  void draw(){
    
    PVector lastpos=pos.copy();
    float lastdeg=deg; 
    animate();
    
    ////if(stillFrames==0){
    ////  fill(255,0,0);
    ////}else{
    ////  fill(255);
    ////}
    ////if(canReuse()){
    ////   fill(100,255,0);
    ////}
    
    //if(stillFrames>0){
    //  fill(255);
    //}else{
    //  //float a = 190-10*speed.mag();
    //  fill(255,150);
    //}
    
    fill(255,20);
    blendMode(ADD);
    int SS=12;
    for (int k =0; k<SS; k++){
      float subframe=(float)k/(float)SS;
      PVector v = PVector.lerp(pos, lastpos, subframe);
      pushMatrix();
        
        float x =    10.* sin ( (float)frameCount/50.+ 5*pos.y/width) ;
        float y =   20.* cos ( (float)frameCount/30.+ 5*pos.x/width) ;
        translate( v.x+x, v.y +y);
        
        //float r =    PI * sin ( (float)frameCount/50.+ 5*pos.y/width) * sin ( (float)frameCount/50.+ 5*pos.x/width) ;
        //rotate( PI* sin(log(1+speed.mag())));
        rotate( radians( lerp(deg, lastdeg, subframe)));
        
        //float rnd=0;//sqrt(stillFrames)/20;
        text(c, 
          0, 
          0);
        //stillFrames++;
        
      popMatrix();
    }
  }
  
  void setNewTarget(Letter t){
    target = t;
  }
  
  void animate(){    

    
    if(target != null){
      PVector dspeed = PVector.sub(target.pos, pos).mult(0.02);
      float dist = pos.dist(target.pos);
      if (dspeed.mag()>20)
        dspeed.setMag(20);
      //dspeed.div(dist*dist);
      
      speed.add(dspeed);
      deg+=dist;
      
      if (dist<0.4){
        stillFrames++;
      }else{
        stillFrames=0;
      }
    }else{
      stillFrames--;
      float rnd=1;//sqrt(stillFrames)/20;
      speed.x+=randomGaussian()*rnd; 
      speed.y+=randomGaussian()*rnd;
    }
    
    deg*=0.75;
    speed.mult(0.72);
    pos = pos.add(speed);//PVector.lerp(pos, target.pos, 0.2);
    
   // phase+=speed;
    
  }
  
  boolean canReuse(){
    return target==null ||  stillFrames > minFramesStill;
  }
  
 
}

PVector bbox;
void setup(){

  size(864, 1080);//Instagramm best
  //size(600, 600); //testing FPS-optimal
  background(255);
  pixelDensity(2);
  frameRate(30);
  smooth(4);
  
  ts = height/32;
  f = createFont("Literata-VariableFont_wght.ttf",ts,true);
  
  
  textFont(f, ts);
  textSize(ts);
  
  bbox = makeLetters(poem);
  //
}

 
PVector makeLetters(String line){
  letters=new Letter[poem.length()];
  glyphs=new Glyph[poem.length()];
  
  float x=0;
  float y=0;
  
  float maxX=0;
  float maxY=0;
  
  for(int i=0; i<line.length(); i++){
    String cc = line.substring(i,i+1);
    float w = textWidth(cc);
   
     
    letters[i]=new Letter(cc);
    letters[i].pos = new PVector(x, y);
    
    
    glyphs[i] = new Glyph(cc);
    glyphs[i].pos =  letters[i].pos.copy();
    
    //glyphs[i].setNewTarget(letters[i]);
    
    if (x > maxX) maxX=x;
    if (y > maxY) maxY=y;
    
    x+=w;
    
    if("\n".equals(cc)){
      y += lineHeight*ts;
      x=0;
    }
  }
  
  
  for (Glyph g : glyphs){
    g.pos.x =  2* maxX * randomGaussian();
    g.pos.y = 100+ 4 * maxY * abs(randomGaussian());
  }
  return new PVector(maxX, maxY);
}

 
float speed = 1.0/180.0;

int motionblur_steps=24;

int currentLetter=0;
void drawPoem( ){
  
  for (Glyph l:glyphs){
    l.draw();
    //l.animate();
  }
  
  //for (Letter l:letters){    
  //  l.animate();
  //}
 
  if (frameCount%3==0){
    Letter cl = letters[currentLetter];
    Glyph cg = findFreeGlyph(cl);
    if(cg!=null){
      cg.setNewTarget(cl);
      currentLetter=(currentLetter+1) % letters.length;
    }
  }
}

Glyph findFreeGlyph(Letter l){
  for (Glyph g:glyphs){
    if(g.canReuse() && g.c.equals(l.c)){
      return g;
    }
  }
  return null;
}
 
void draw(){
  Arrays.sort(glyphs, aGComparator );
  translate((width-bbox.x)/2, (height-bbox.y)/2);//ceter text on screen
  
  background(0);
  fill(255, 140);
   
  drawPoem( );
  
  if(frameCount<3000 && SAVE_IMAGES)
    saveFrame("/Users/artem/work/creative-code/poem_letters_cache.out/poem__####.png");
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
