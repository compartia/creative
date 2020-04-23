int loops = 6;
int animationLen = loops * 8 * 30;

boolean SAVE_ANIMATION = false;
Eye s1;


void setup() {
    size(540, 540, P3D);

    frameRate(30);
    smooth(4);
    pixelDensity(2); // retina

    s1 = new Eye(new PVector(0, 0, 0));
}


void draw() {

    background(0);

    pushMatrix();
    translate(width / 2, height / 2, 0);

    blendMode(BLEND);
    s1.show(frameCount);
    blendMode(ADD);
    fill(40);

    stroke(30);
    strokeWeight(2);
    ellipse(0, 0, s1.r + s1.r / 3, s1.r + s1.r / 3);

    float str_w = s1.r / 2.5;
    float str_t = s1.r;
    float str_b = height / 2 - +s1.r / 5;
    blendMode(BLEND);
    rect(0 - str_w / 2, str_t, str_w, str_b - str_t, str_w / 2.1);

    drawVeco(frameCount - 10);

    popMatrix();

    fill(255);
    rect(0, 140, 3, 20);

    if (frameCount < animationLen && SAVE_ANIMATION)
        saveFrame("render/opart__####.png");
}

public void drawVeco(int frame) {
    int fragment_len = animationLen / loops;
    float phase = (frame % fragment_len) / (float) fragment_len;

    float a_start = 0.96;
    float a_end = 0.99;

    float sc = 0;
    if (phase > a_start && phase < a_end) {
        sc = (phase - a_start) / (a_end - a_start);
        println(sc);
        sc = cos(PI / 2 - PI * sc);

    }

    pushMatrix();
    translate(0, 0, 300);
    noFill();
    fill(0, 0, 255);
    noStroke();

    rect(-width / 2, -50, width, sc * 50);
    rect(-width / 2, 50 - sc * 50, width, sc * 50);
    popMatrix();

}

void mouseReleased() {
    println(frameCount + " ");
    saveFrame("eye_####.png");

}
