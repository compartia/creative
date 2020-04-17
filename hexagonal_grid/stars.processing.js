int radius = 40;
float angle = TWO_PI / 6;
float a_change = PI/12;
boolean looping = true; 


void setup() {
  size(640, 640);
  background(255);
  frameRate(60);
}

int base_r=100;
float phase = 0.333;
float sradius = base_r;
float time = 0;

void draw() {
  time += 0.005f;
  a_change += PI/400;
  phase = (sin(time)+1)/2f;
  sradius = base_r * cos(time/3.0);
   
  //background(0); 

  stroke(255, 140); 
  
  // vary the width - start just off the screen so we don't have black edges
  for (float centy = -50+6*radius/4; centy < width+100; centy += radius*3) { // offset three times to skip a row
    for (float centx = 0; centx < width+100; centx += sqrt(3)/2 * 2*radius) {
      draw_star(centx, centy, sradius, phase);
    };
  }

  for (float centy = -50; centy < height+100; centy+= radius*3) {
    for (float centx = sqrt(3)/2 * radius; centx < width+100; centx += sqrt(3)/2 * 2*radius) {
      draw_star(centx, centy, sradius, phase);
    }
  }
}

void draw_star(float x, float y, float radius, float phase){
  noFill(); 
  beginShape();
  fill(2, phase, 0, 1);
  float rsmall =  radius * phase;
  float  rot = a_change - angle/4;
  for (float a = PI/6; a < TWO_PI; a += angle) {
    float vx = x + cos(a + rot) * radius;
    float vy = y + sin(a + rot) * radius;
    vertex(vx, vy);
    
    vx = x + cos(a + rot + angle/2) * rsmall;
    vy = y + sin(a + rot + angle/2) * rsmall;
    vertex(vx, vy);
  };
  endShape(CLOSE);
}


void mouseReleased() {
  looping = !looping; 
  if (looping) {
    loop();
  } else {
    noLoop();
  }
}
