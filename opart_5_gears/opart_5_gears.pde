color c1 = color(100);

color c2 = color(00);

void setup() {

    size(640, 640);
    background(0);
    frameRate(30);
    smooth(4);
    pixelDensity(2);

    background(0);

}

int circles = 20;
int N = 90;
float da = PI * 2 / N;

void draw() {

    background(0);

    float rlen = width / circles;
    float inner = rlen * 0.0;
    translate(width / 2, height / 2);
    rotate(da / 6);

    float twistM = 6 * da;

    for (int c = 0; c < circles; c++) {
        if (c % 3 == 0) {

            drawTube(inner + rlen * c, inner + rlen * (c + 1), 5);
        } else {
            stroke(255);
            fill(255);
            drawGear(inner + rlen * c, inner + rlen * (c + 1), twistM * (2 - c % 3), N);
        }
    }

}

void drawTube(float innerR, float outerR, int n) {
    float w = outerR - innerR;
    float dr = w / n;
    strokeWeight(dr / 2);
    noFill();
    stroke(255);
    for (float r = innerR; r <= outerR; r += dr) {
        ellipse(0, 0, r * 2, r * 2);
    }
}

void drawGear(float innerR, float outerR, float twist, int dents) {

    float da = PI * 2 / dents;

    noStroke();
    for (float a = 0; a < PI * 2; a += da) {

        beginShape();
        vertex(innerR * cos(a), innerR * sin(a));
        vertex(innerR * cos(a + da / 2), innerR * sin(a + da / 2));
        vertex(outerR * cos(a + da / 2 + twist), outerR * sin(a + da / 2 + twist));
        vertex(outerR * cos(a + twist), outerR * sin(a + twist));

        endShape();
    }

}

void mouseReleased() {
    println(frameCount + " ");
    saveFrame("opart__####.png");
}
