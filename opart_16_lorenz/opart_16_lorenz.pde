
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
    anim += 2*PI/300;
    fill(0, 80);
    //rect(0,0,width, width);
    //noLoop();
    background(0);

    translate(width / 2, height / 2);

    scale(0.4);
    // rotate(PI / 4);
    drawHyps();

    rotate(PI / 2);
    drawHyps();

    rotate(PI);
    drawHyps();

    rotate(-PI / 2);
    drawHyps();

    if (frameCount<600){
      println(frameCount + " ");
      saveFrame("/Users/artem/work/creative-code/opart_16/opart__####.tif");
    }

}

color hyperbolaColor=color(255,120);


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
      // velocity relative to speed of light
      for (float velocity = -0.999; velocity <= 0.999; velocity += 0.01) {                
          PVector r = lorentz(space, time, velocity);
          vertex(r.x, r.y);
      }
      noFill();
      strokeWeight(5.);
      stroke(hyperbolaColor);
    }
    endShape();
}


void drawCircle(float xx, float yy, float rad, float initialSpeed){
  float speed =initialSpeed+  0.49 * (sin(anim / 2) + 1.0);
  
  //float speed = (initialSpeed*100+ frameCount%100)/100.0;
  
  //speed+=initialSpeed;
  
  beginShape();
    {
      // velocity relative to speed of light
      for (float a = 0; a < PI*2; a += PI/6) {
        float x = xx + rad*sin(a);
        float y = yy + rad*cos(a);
          PVector r = lorentz(x, y, speed);
          vertex(r.x, r.y);
      }
      fill(255);
      noStroke();      
    }
    endShape();
    
    
}


void drawHyperbolaDot(float x, float time, boolean doline){

    float speed = 0.49 * (sin(anim / 2) + 1.0);
    //float speed = (frameCount%100)/100.0;
    speed *= 0.95;

    PVector l = lorentz(x, time, speed);
    if (doline) {


        //noStroke();
        //blendMode(DIFFERENCE);
        //fill(255);
        //beginShape();
        //vertex(0,0);
        //vertex(0,l.y);
        //vertex(l.x,l.y);
        //endShape();
        //blendMode(BLEND);

        //stroke(255,0,0,170);
        //line(0,l.y, l.x,l.y );
    }
    noStroke();
    fill(255, 200);

    float r = 1.5 * log(1 + time * 4);
    ellipse(l.x, l.y, r, r);


}

void drawHyps(){
     
    int step = 35;
    //for (int n = 1; n < 20; n++)
    for (int time = 1; time < 30; time++) {
        drawHyperbola(0, time * step);

        for (int k = -6; k < 6; k++) {
            PVector l = lorentz(0, time * step, 0.1 * k);
            //drawHyperbolaDot(l.x, l.y, k == -6);
            
            drawCircle(l.x, l.y, 5, 0.1 * k);
        }

    }
    
}




void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_16/opart__####.png");
}
