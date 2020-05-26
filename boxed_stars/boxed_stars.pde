//settings

boolean fillStar = false;
boolean drawHex = false;
boolean drawBoxSides = false;

static int side = 640;

void setup() {
  size(640, 640);
  background(0);
  frameRate(30);
  smooth(2);
  pixelDensity(2);
  strokeWeight(1);
  noLoop();
}

int N = 5;

float base_radius = (side / N) / sin(radians(60)) / 2;

float dx = 2 * base_radius * sin(radians(60));
float dy = base_radius / 2 + 2 * base_radius * cos(radians(60));

int time = 0;

void draw() {
  time++;
  if (time == 1000)
    time = 0;
  background(0);

  for (int y = 0; y < N + 3; y++) {
    float o = y % 2 == 0 ? 0 : dx / 2;

    for (int x = 0; x < N + 2; x++) {
      pushMatrix();
      translate(x * dx + o, y * dy);
      draw_box(base_radius);
      popMatrix();
    }
  }

  // saveFrame("/Users/artem/work/creative-code/output3/stars__####.png");

}

void draw_box(float radius) {
  float angle = PI / 3;
  stroke(250, 250, 250);

  if (drawHex) {
    fill(200, 210, 200, 100);

    beginShape();

    float rot = angle / 2;

    for (float a = 0; a < TWO_PI; a += angle) {
      float vx = cos(a + rot) * radius;
      float vy = sin(a + rot) * radius;
      vertex(vx, vy);
    }
    ;
    endShape(CLOSE);
  }

  if (drawBoxSides) {
    fill(255, 255, 255, 100);
    draw_face(radius);
    pushMatrix();
    rotate(radians(120));
    fill(80, 80, 250, 100);
    draw_face(radius);
    popMatrix();
  }

  float k = 4 * sin(time / 50f);

  rotate(radians(time));

  draw_star(radius);

}

void draw_star(float radius) {

  if (fillStar) {
    fill(100, 0, 50, 160);
  } else {
    noFill();
  }

  draw_star_segment(radius);
  pushMatrix();
  scale(-1, 1);

  if (fillStar) {
    fill(255, 0, 100, 160);
  } else {
    noFill();
  }

  draw_star_segment(radius);
  popMatrix();
}

void draw_star_segment(float radius) {

  float angle = PI / 3;
  float rx = radius * sin(radians(45)) * sin(radians(15));
  float ry = rx / tan(radians(30));

  for (float a = 0; a < TWO_PI; a += angle) {
    pushMatrix();
    rotate(a);
    beginShape();
    vertex(0, 0);
    vertex(0, radius);
    vertex(-rx, ry);
    endShape(CLOSE);
    popMatrix();
  }
}

void draw_face(float radius) {
  beginShape();
  {
    vertex(0, 0);
    vertex(cos(radians(-30)) * radius, sin(radians(-30)) * radius);
    vertex(cos(radians(30)) * radius, sin(radians(30)) * radius);
    vertex(0, radius);
  }
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
