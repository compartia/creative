
void setup() {
    size(640, 640);
    background(0);
    frameRate(30);
    smooth(8);
    pixelDensity(2); //retina
    background(0);
}


float  anim = 0;
void draw(){
    anim += 0.05;
    noLoop();
    background(0);

    translate(width / 2, height / 2);

    scale(0.4);
    rotate(PI / 4);
    drawHyps();

    rotate(PI / 2);
    drawHyps();

    rotate(PI);
    drawHyps();

    rotate(-PI / 2);
    drawHyps();


}

void drawHyps(){
    pushMatrix();
    float step = width / 320.;
    for (int x = 0; x < 30; x++) {
        drawHyp(x * 3000, step);
    }

    popMatrix();
}

void drawHyp(int n, float step){
    //blendMode(DIFFERENCE);
    blendMode(ADD);

    noFill();
    stroke(255, 120);
    strokeWeight(4);
    beginShape();
    for (float x = 0.001; x < width * 2; x += step) {
        float y = (n) / (x / 4);
        vertex(x, y);
    }
    endShape();
}
void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_16/opart__####.png");
}
