int CENTERS=300;
Dot[] centers = new Dot[CENTERS];
PVector center;
void setup() {   
 
  
  size(640, 640);
  center= new PVector(width/2, height/2);
  
  background(0);
  frameRate(60);
  smooth(1);
  pixelDensity(1);
 

  background(0);
  
  for (int i=0; i<CENTERS; i++){
    
    float a = 2*PI*random(1); 
    centers[i] = new Dot(a);
    centers[i].pos.x=center.x; 
    centers[i].pos.y=center.y; 
    centers[i].speed.mult(0.7+random(1.0)*0.4);
 
  }

}

int n_dots=0;
final static int N=180000;
int dot_cursor = 0;
Dot[] dots = new Dot[N];


 
void draw(){
  blendMode(ADD);
  background(0);
   
  if (n_dots<N-100){
    for (int i=0; i<CENTERS; i++){
       emit(centers[i].pos, N/12000);
    }
  }

  drawDots(getGraphics());
   
   if( frameCount%100 == 0){
     println(n_dots);
   }
   
   if( frameCount>100 && frameCount<720 ){
     center.x += SPEED*.8 * sin(frameCount*0.264);
     center.y -= SPEED*.8 * cos(frameCount*0.264);
   }
  if(frameCount<10000){
    saveFrame("dark####.png");
  }
   
  
}

float da = 2.0 * PI /  (float)N;
float initialR = 0;
void emit(PVector c, int count){
    
   
  for (int j=0; j<count; j++){
    int i = dot_cursor;
    float a = 2*PI*random(1);  
    dots[i] = new Dot(a);
    dots[i].pos.x=c.x; 
    dots[i].pos.y=c.y; 
 
    dots[i].pos . add(dots[i].speed.copy().mult(initialR));
    
    n_dots = max(i, n_dots);
    dot_cursor++;
    dot_cursor = dot_cursor % N;
  }
 
}

void mouseReleased() {

  println(frameCount+" ");
  saveFrame("dark2a__####.png");
}

  

void drawDots(PGraphics g){
  noStroke();
  fill(255, 9);
  
  
  for (int i=0; i<CENTERS; i++){        
    centers[i].move();
    centers[i].speed.mult(0.999-abs(randomGaussian()*0.01));
  }
  
  for (int j=0; j<n_dots; j++){
    Dot dot=dots[j];
    dot.move();
    dot.draw(g, 2.5);
  }

}

 
  
 
