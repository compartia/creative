boolean renderToDisk = false;
int frames = 1; // 60*30;
float  anim = 0;

void setup() {
    size(600, 600);
    background(0);
    frameRate(60);
    smooth(8);
    pixelDensity(2); //retina
    background(0);
}

void drawLogo(int s, int sw){
    pushMatrix();
    strokeCap(ROUND);
    strokeJoin(ROUND);

    int yy = (int) (-s /tan(PI / 6.));
    yy = yy- yy%(sw*2);
    
    beginShape();
    {
        vertex(0, 0);
        vertex(s, 0);
        vertex(s, yy);
        // vertex(0,0);
    }
    endShape(CLOSE);

    translate(s + s / 2, 0);
    beginShape();
    
    {
        vertex(s, 0);
        vertex(0, 0);
        vertex(s, yy);
        vertex(0, yy);
        // vertex(0,0);
    }
    endShape();
    popMatrix();
}


void draw(){
    translate(width / 2, height / 2);
    if(random(1)<0.04){
      rotate(-PI/6);
    }
   //
    scale(1.5 + cos( sin(anim*20) )/6);
    int s = 80;
    int sw = s / 10;
    anim += 2 * PI / 300;
    background(random(220),random(170),random(255));
     
    strokeWeight(sw);
    noFill();
    
    //blendMode(EXCLUSION);
   
    strokeWeight(sw*1.6);
    noFill();
    
     stroke(0, 150);
    for (float i=-width/2; i<width/2;  i+=sw*2){
      line(-width/2, i, width/2, i);
    }
    
    
     stroke(0, 150);
    for (float i=-width/2; i<width/2;  i+=sw*2){
      line(i, -width/2, i, width/2);
    }
    
     
    blendMode(BLEND);
    strokeWeight(sw+1);
    translate(sw/2, -sw/2);
    
    //blendMode(EXCLUSION);
    for (int i = (int)-random(8); i < (int)random(18); i++) {
        pushMatrix();               
        translate(-s * 1.5 + sw*i*1.5, s+ sw*i*1.5);
        stroke(200, random(120));
        drawLogo(s, sw);
        popMatrix();

    }
    translate(-s * 1.5  , s );
    stroke(255 );
    drawLogo(s, sw);
    
    
    if (frameCount < frames && renderToDisk) {
        println(frameCount + " ");
        saveFrame("/Users/artem/work/creative-code/opart_18_dasha/opart__####.tif");
    } else {
        //noLoop();
    }

}



void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_18_dasha/opart__####.png");
}
