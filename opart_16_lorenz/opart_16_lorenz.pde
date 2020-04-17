
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
    anim += 2 * PI / 300;

    fill(0, 470);
    rect(0, 0, width, width);


    translate(width / 2, height / 2);

    scale(0.33);

    drawHyps();
    rotate(PI);
    drawHyps();

    scale(-1, 1);
    rotate(PI / 2);
    drawHyps();



    rotate(PI);
    drawHyps();


}

color hyperbolaColor = color(0, 50, 255, 160);


static float c = 1.; //speed of light = 1, for normalization

PVector lorentz(float space, float time, float v){
    float gammaLorentzFactor = 1 / sqrt(1 - v * v / c * c);

    float time1 = gammaLorentzFactor * (time - v * space / c * c);
    float space1 = gammaLorentzFactor * (space - v * time);

    return new PVector(space1, time1);
}



void drawHyperbola(float space, float time){
    beginShape();
    {
         
        for (float velocity = -0.99; velocity <= 0.99; velocity += 0.01) {
            PVector r = lorentz(space, time, velocity);
            vertex(r.x, r.y);
        }
        noFill();
        strokeWeight(5.);
        stroke(hyperbolaColor);
    }
    endShape();
}


void drawCircle(float xx, float time0, float rad, int frame_offset){
    //float speed =initialSpeed+  0.49 * (sin(anim / 2) + 1.0);

    float speed = (frame_offset + frameCount % 16) / 180.0;


    float as=abs(speed);
    int alph = 255 - (int)(as * 200);
    beginShape();
    {
        // velocity relative to speed of light
        for (float a = 0; a < PI * 2; a += PI / 4) {
            float x = xx + rad * sin(a);
            float time = time0 + rad * cos(a);
            PVector r = lorentz(x, time, speed);
            vertex(r.x, r.y);
        }
         
        fill(255, alph);
        noStroke();
    }
    endShape();


}


void drawHyps(){

    int step = 40;

    for (int time = 4; time < 30; time++) {
        drawHyperbola(0, time * step);


        float r = 3 * log(1 + time * 2);
        for (int o = -30; o < 30; o++) {
            drawCircle(0, time * step, r, o * 16);
        }
    }

}




void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_16/opart__####.png");
}
