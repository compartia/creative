boolean SAVE_ANIMATION = false;

void setup() {

    size(640, 640);
    background(0);
    frameRate(30);
    smooth(4);
    pixelDensity(2);

    background(0);

}

static int side = 1080;
int N = 8;
float dotsD = 12;
float dotsR = 12;

float rott = 0;
float divider = 4.0;
int segments = 256;
float angle = (2.0 * PI) / segments;
float thiknes = 4.5;
int alpha = 220;

color c1 = color(0);
color c2 = color(255);

void draw() {
    background(0);

    drawDots(getGraphics());

    pushMatrix();
    rott = frameCount / 1000.0;

    fill(c2);

    drawDots(getGraphics());

    translate(width / 2, height / 2);
    rotate(angle + rott);
    translate(-width / 2, -height / 2);
    fill(c1);
    noStroke();
    drawDots(getGraphics());

    popMatrix();

    if (frameCount < 1000 && SAVE_ANIMATION) {
        println(frameCount + " ");
        saveFrame("opart__####.png");
    }

}

void draw_segment(float r) {

    noStroke();
    ellipse(0, r, thiknes, thiknes);

}

float base_radius = (side / N) / sin(radians(60)) / 2;

float dx = 2 * base_radius * sin(radians(60));
float dy = base_radius / 2 + 2 * base_radius * cos(radians(60));
float dot_dx = dx / dotsD;
float dot_dy = dy / dotsD;

void drawDots(PGraphics g) {

    g.pushMatrix();

    g.translate(g.width / 2, g.height / 2);

    for (float y = -(N / 2) * dotsD; y < (N / 2) * dotsD; y += 1) {
        float o = y % 2 == 0 ? 0 : dot_dx / 2;

        for (float x = -(N / 2) * dotsD; x < (N / 2) * dotsD; x += 1) {
            g.pushMatrix();

            float offx = 0;
            float offy = 0;
            g.translate(offx + x * dot_dx + o, offy + y * dot_dy);

            float rr = base_radius;
            draw_dot(g, rr);
            g.popMatrix();

        }
    }
    g.popMatrix();

}

void draw_dot(PGraphics g, float radius) {
    float r = radius / dotsR;
    g.ellipse(0, 0, r, r);

}

void mouseReleased() {

    println(frameCount + " ");
    saveFrame("opart__####.png");
}
