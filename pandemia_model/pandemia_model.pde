import java.util.Comparator;
import java.util.Arrays;

boolean SAVE_IMAGES= true;
 
float ts=25;

PFont f;


 
   
//float INF_D=5;
float motion_blur_steps=10;

Pandemia model; 
void setup(){
  motion_blur_steps=16;
  
  //size(1080, 1080);//Instagramm best
  size(540, 540); //testing FPS-optimal
  //2560x1440 1280 x 720
  //size(1280, 720);//Youtube 2K
  background(0,0,0);
  pixelDensity(2);
  frameRate(60);
  smooth(4);
  
  float screen_side_len = sqrt(height*width);
  ts = screen_side_len/70;
  f = createFont("FiraSans-Regular.ttf",ts,true);
  
  
  textFont(f, ts);
  textSize(ts);
  
  model =new Pandemia(new PVector(width-ts*2, height-ts*2));
  

  //INF_D=screen_side_len/50;
  //
  
  
}

 


float minimal_infection = 0.001;
float critical_infection = 0.01;
float lethal_infection = 0.9;


 
 
 
void draw(){
 if(frameCount%3==0){
    fill(10,10,50, 7);
    rect(0,0,width, height);
  }
  //background(10,10,50);
 

  translate(width /2,  height /2);
  
  model.draw();

 
  if(frameCount<60*30 && SAVE_IMAGES)
    saveFrame("/Users/artem/work/creative-code/twirl7/poem__####.png");
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
