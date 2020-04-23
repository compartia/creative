color c1 = color(0, 150, 255);
color c2 = color(255, 100, 0);

void setup() {

    size(640, 640);
    background(0);
    frameRate(30);
    smooth(4);
    pixelDensity(2);

    background(0);

}

int circles = 60;
int N = 90;
float da = PI * 2 / N;

void draw() {
    background(0);

    float rlen = width / circles;
    float inner = rlen * 0.0;
    translate(width / 2, height / 2);
    rotate(da / 6);

    float twistM = da;

    stroke(c2);
    fill(c2);
    for (int c = 1; c < circles; c++) {

        drawGear(inner + rlen * c, inner + rlen * (c + 1), twistM * (c % 2), N);

    }
    rotate(da / 3);
    stroke(c1);
    fill(c1);
    for (int c = 1; c < circles; c++)
        drawGear(inner + rlen * c, inner + rlen * (c + 1), twistM * (c % 2), N);

    rotate(-da / 6);
    stroke(255);
    fill(255);
    for (int c = 1; c < circles; c++) {

        drawGear(inner + rlen * c, inner + rlen * (c + 1), 2 * twistM * (c % 2), N);

    }

}

void drawGear(float innerR, float outerR, float twist, int dents) {

    float da = PI * 2 / dents;

    for (float a = 0; a < PI * 2; a += da) {

        strokeWeight(0.4);

        beginShape();
        vertex(innerR * cos(a), innerR * sin(a));
        vertex(innerR * cos(a + da / 2), innerR * sin(a + da / 2));
        vertex(outerR * cos(a + da / 2 + twist), outerR * sin(a + da / 2 + twist));
        vertex(outerR * cos(a + twist), outerR * sin(a + twist));

        endShape();
    }

}

void drawZigZag() {
    pushMatrix();
    float k = width / 10;
    for (int x = 0; x < 10; x++) {

        if (x % 2 == 0)
            rotate(PI / 3);
        else
            rotate(-PI / 3);
        line(0, 0, k, 0);
        translate(k, 0);
    }
    popMatrix();
}

void drawZigZag2() {
    float k = width / 10;
    noFill();
    beginShape();
    {
        vertex(0, 0);
        vertex(k, -k);
        vertex(k * 3, -k);
        vertex(k * 3, -k * 3);
        vertex(k * 7, 0);
    }
    endShape();
}

void mouseReleased() {
    println(frameCount + " ");
    saveFrame("opart__####.png");
}
