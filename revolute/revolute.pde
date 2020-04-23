import java.util.Comparator;
import java.util.Arrays;

boolean SAVE_IMAGES=true;
String poem_tmp=
  "révolutionnai";
   

String poem = poem_tmp.toUpperCase().replaceAll("--","—").replaceAll(" "," ") ;
float ts;

PFont f;
 
 
float lineHeight=1.62;
int minFramesStill = 50;


PVector bbox;
void setup(){

  size(864, 1080);//Instagramm best
  //size(600, 600); //testing FPS-optimal
  background(255);
  pixelDensity(2);
  frameRate(30);
  smooth(4);
  
  ts = height/18;
  f = createFont("Literata-VariableFont_wght.ttf",ts,true);
  
  
  textFont(f, ts);
  textSize(ts);
  background(0);
   
  //
}


float degdeg=0;
float framesPerRevolution=800;

void draw(){
  
  blendMode(MULTIPLY);
  fill(0,190);
  rect(0,0,width, height);
  
  pushMatrix();
  translate(width/2, height/2);
  
  
  String poem_tmp=
      "révolutionnai".toUpperCase();
  float degdeginc = -2*PI/framesPerRevolution;
  degdeg+=degdeginc;
  
  String p=""+poem_tmp;
  
  color clr=color(255, 180);
  //color clr_alt=color(255, 20);
  //if(random(3)<1){
  //  p= "rêve         ";
  //  clr_reve=color(255, 255,0, 180);
  //  clr_alt=color(255, 255,0, 180);
  //}
  
  float a_reve=(sin(frameCount/5.0)+2.0)*64;
  color clr_reve = color(255, 180, 255, a_reve*0.5);
  
  
  float a_naive=(sin(frameCount/7.0)+2.0)*64 ;
  color clr_naive = color(220, 255, 255, a_naive*0.5);
  
  float a_lutin=(sin(frameCount/4.0)+2.0)*64 ;
  color clr_lutin = color(255, 220, 220, a_lutin*0.5);
  
  
  float a_alt=(sin(frameCount/8.0)+2.0)*64 ;
  color clr_alt = color(255, a_alt);
  
  
  if(random(3)<1){
    //scale(0.99);
    p="f         naï";
    clr=color(0, 255,255, 180);
  }
  
  if(random(3)<1){
    //scale(0.99);
    p="    lutin    ";
    clr=color(255, 0, 255, 180);
  }
  
  p=p.toUpperCase();
 
  
  
  blendMode(ADD);
  float rot = 0.1*sin(frameCount/10.0);
  float rot2 = 0.1*sin(frameCount/8.0);
  float rot3 = 0.1*sin(frameCount/6.0);
   
  //scale(0.75);
  draw_c("rêve         ".toUpperCase(), degdeg+rot, clr_reve);
  //scale(0.84);
  draw_c("f         naï".toUpperCase(), degdeg+rot2, clr_naive);
 // scale(0.84);
  draw_c("    lutin    ".toUpperCase(), degdeg+rot3, clr_lutin);
   
  
  
  
  
  blendMode(ADD);
  draw_c(poem_tmp, degdeg, clr_alt);
  
  popMatrix();
  
  //blendMode(MULTIPLY);
  //fill(0,100);
  //rect(0,0,width, height);
  
  
  
  //pushMatrix();
  //translate(width/2, height/2);
  //scale(0.8);
  //draw_c("rêve         ".toUpperCase(), degdeg+0.1*sin(frameCount/10.0), 100);
  //popMatrix();
  
  //pushMatrix();
  //translate(width/2, height/2);
  //scale(0.6);
  //draw_c("f         naï".toUpperCase(), degdeg+0.1*sin(frameCount/12.0), 80);
  //popMatrix();
  
  //pushMatrix();
  //translate(width/2, height/2);
  //scale(0.8);
  ////draw_c("    lutin     ", degdeg*4, 70);
  //draw_c("    lutin    ".toUpperCase(), degdeg+0.1*sin(frameCount/8.0), 70);
  //popMatrix();
  
  if(frameCount<framesPerRevolution && SAVE_IMAGES)
    saveFrame("/Users/artem/work/creative-code/revolution2.out/poem__####.png");
}



void draw_c(String poem, float degdeg, color clr){
  
  //Arrays.sort(glyphs, aGComparator );
  //translate((width-bbox.x)/2, (height-bbox.y)/2);//ceter text on screen
  
  //background(0);
  //fill(0,10);
  //rect(0,0,width, height);
  
  //blendMode(ADD);
  for(int i=0; i<poem.length(); i++){
    pushMatrix();
      String cc = poem.substring(i,i+1);
      float w = textWidth(cc);
     // translate(width/2, height/2);
      float r = 2* PI * float(i)/(float)poem.length();
      rotate(r+degdeg);
      int gg=(int)((cos(r+50*degdeg)+1)*128.0);
      int bb=(int)((cos(r+22*degdeg)+1)*128.0);
      fill(255-bb/2,255-gg/3, 128+bb/2, alpha(clr));
      float y=-width/4.;//+ 10*sin(frameCount/20.0);
      //scale( ((i+frameCount)%12+1)*0.15);
      text(cc, 0-w/2, y);
      fill(clr);
      text(cc, 0-w/2, y );
      
      //noFill();
      //stroke(60);
      //arc(0, y-ts*0.26, 2.6*ts, 2.6*ts, 0+PI/4, PI+PI/4);
      //ellipse(w/2, y-ts/2, 2*ts, 2*ts);
      //arc(0,0,20,20, 30);
    popMatrix();
  }
   
  
}

void draw_old(){
  float degdeginc = -2*PI/framesPerRevolution;
  degdeg+=degdeginc;
  //Arrays.sort(glyphs, aGComparator );
  //translate((width-bbox.x)/2, (height-bbox.y)/2);//ceter text on screen
  
  
  //fill(0,10);
  //rect(0,0,width, height);
  
  //blendMode(ADD);
  for(int i=0; i<poem.length(); i++){
    pushMatrix();
      String cc = poem.substring(i,i+1);
      float w = textWidth(cc);
      //translate(width/2, height/2);
      float r = 2* PI * float(i)/(float)poem.length();
      rotate(r+degdeg);
      int gg=(int)((cos(r+50*degdeg)+1)*128.0);
      int bb=(int)((cos(r+22*degdeg)+1)*128.0);
      fill(255-bb/2,255-gg/3, 128+bb/2, 130);
      float y=-width/4.;//+ 10*sin(frameCount/20.0);
      //scale( ((i+frameCount)%12+1)*0.15);
      text(cc, 0-w/2, y);
      fill(255, 160);
      text(cc, 0-w/2, y );
      
      noFill();
      stroke(60);
      arc(0, y-ts*0.26, 2.6*ts, 2.6*ts, 0+PI/4, PI+PI/4);
      //ellipse(w/2, y-ts/2, 2*ts, 2*ts);
      //arc(0,0,20,20, 30);
    popMatrix();
  }
   
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
