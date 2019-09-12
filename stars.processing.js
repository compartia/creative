int radius = 40;
float angle = TWO_PI / 6;
float a_change = PI/12;
boolean looping = true; 


void setup() {
  size(640, 640);
  background(255);
  frameRate(30);
}

void draw() {
  a_change += PI/112.0;

  background(0); 

  fill(255); 
  stroke(255); 
	
  // vary the width - start just off the screen so we don't have black edges
  for (float centy = -50+6*radius/4; centy < width+100; centy += radius*3) { // offset three times to skip a row
    for (float centx = 0; centx < width+100; centx += sqrt(3)/2 * 2*radius) {
			draw_star(centx, centy, radius, 0 )
     //  beginShape();
     //  //fill(0);
     //  for (float a = PI/6; a < TWO_PI; a += angle) {
     //    float vx = centx + cos(a + a_change) * radius;
     //    float vy = centy + sin(a + a_change) * radius;
     //    vertex(vx, vy);
     // };
     // endShape(CLOSE);
    };
  }

  for (float centy = -50; centy < height+100; centy+= radius*3) {
    for (float centx = sqrt(3)/2 * radius; centx < width+100; centx += sqrt(3)/2 * 2*radius) {
     //  beginShape();
     //  //fill(0);
     //  for (float a = PI/6; a < TWO_PI; a += angle) {
     //    float vx = centx + cos(a + a_change) * radius;
     //    float vy = centy + sin(a + a_change) * radius;
     //    vertex(vx, vy);
     // };
     //  endShape(CLOSE);
			draw_star(centx, centy, radius, 0 )
    }
  }
}

void draw_star(x, y, radius, phase){
	beginShape();
	fill(0);
	rsmall =  radius/3.0
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
