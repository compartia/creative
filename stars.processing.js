int radius = 40;
float angle = TWO_PI / 6;
float a_change = PI/12;
boolean looping = true; 


void setup() {
  size(640, 640);
  background(255);
  frameRate(20);
}

phase = 0;
sradius = 50
time = 0;
void draw() {
	time += 0.1
  a_change += PI/212.0;
	phase = (sin(time/300.0)+1)*2
	sradius = 50 * cos(time/200.0)
	 
  background(0); 

  noFill(); 
  stroke(255); 
	
  // vary the width - start just off the screen so we don't have black edges
  for (float centy = -50+6*radius/4; centy < width+100; centy += radius*3) { // offset three times to skip a row
    for (float centx = 0; centx < width+100; centx += sqrt(3)/2 * 2*radius) {
			draw_star(centx, centy, sradius, phase )
    };
  }

  for (float centy = -50; centy < height+100; centy+= radius*3) {
    for (float centx = sqrt(3)/2 * radius; centx < width+100; centx += sqrt(3)/2 * 2*radius) {
			draw_star(centx, centy, sradius, phase )
    }
  }
}

void draw_star(x, y, radius, phase){
	beginShape();
	// fill(0);
	rsmall =  radius*phase
	for (float a = PI/6; a < TWO_PI; a += angle) {
		float vx = x + cos(a + a_change) * radius;
		float vy = y + sin(a + a_change) * radius;
		vertex(vx, vy);
		
		vx = x + cos(a + a_change + angle/2) * rsmall;
		vy = y + sin(a + a_change + angle/2) * rsmall;
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
