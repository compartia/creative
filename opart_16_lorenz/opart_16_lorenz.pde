
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
    //noLoop();
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
    for (int n = 0; n < 10; n++) {
        drawHyp(n * 3000, step);
    }
    popMatrix();
    
    
    fill(255);
     
    for (int m = 1; m < 10; m++) {
       beginShape();
      for (int n = 1; n < 10; n++) {
        float x =  funcR(n * 3000, 10*m*sin(anim/3));   ;//pow(n, m) * 30  +(sin(anim)-2.)*width/4;
        float y = func(n * 3000, x);
        ellipse(x, y, 10, 10);
        vertex(x, y);
      }
       stroke(255, 0,0,120);
      strokeWeight(4);
      endShape();
    }
}

float func(float n, float x){
  return (4 * n) / x ;
}

float funcR(float n, float y){
  return (0.25 * n) / y;
}

void drawHyp(int n, float step){
    //blendMode(DIFFERENCE);
    blendMode(ADD);

    noFill();
    stroke(255, 120);
    strokeWeight(4);
    beginShape();
    for (float x = 0.001; x < width * 2; x += step) {
        float y =func(n, x);
        vertex(x, y);
    }
    endShape();
}
void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_16/opart__####.png");
}
