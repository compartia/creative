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

int N = 14;

void draw() {
    int centerw = width / 8;
    translate(width / 2, height / 2);

    scale(0.95);
    background(255);

    float size = width / 2.;
    float dx = size / N;
    int o = 8;
    for (float x = -size, cx = 0; x <= size; x += dx, cx++) {
        for (float y = -size, cy = 0; y <= size; y += dx, cy++) {
            
            pushMatrix();
            translate(x + dx / 2, y + dx / 2);

            float r = abs(cx - cy);
            float rot = 0.5;
            if (r < 5)
                rot = 0;

            if ((cx + cy) % 2 == 0)
                fill(190, 0, 60);
            else {
                fill(190, 0, 40);
            }

            rect(-dx / 2, -dx / 2, dx, dx);
            drawBox(dx, -(rot + (cx + cy) % 2) * PI);

            popMatrix();

        }
    }
}

void drawBox(float side, float rot) {

    rotate(rot);

    pushMatrix();
    translate(-side / 2, -side / 2);

    fill(255);
    drawCorner(side);
    popMatrix();

    rotate(PI);
    pushMatrix();
    translate(-side / 2, -side / 2);
    fill(0);
    drawCorner(side);
    popMatrix();

}

void drawCornerDot(float side) {
    float p = side * 0.3;
    noStroke();
    ellipse(p / 2, p / 2, p, p);
    ellipse(side - p / 2, p / 2, p / 2, p / 2);
    ellipse(p / 2, side - p / 2, p / 2, p / 2);
}

void drawCorner(float side) {

    float p = side * 0.12;
    float k = p * 2;
    noStroke();
    beginShape();
    vertex(0, 0);
    vertex(side / 3, 0);
    vertex(p, p);
    vertex(0, side / 3);
    endShape();

}

void mouseReleased() {
    println(frameCount + " ");
    saveFrame("opart__####.png");
}
