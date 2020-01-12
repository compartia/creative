PFont mono;
float font_size = 12;
static String name = "кто хочет";
static String txt = "среда 15 января 2020 год 18 часов " + name + " приди " + name + " явись black beach resto 2 этаж hannoman штрассэ " + name + " приди еда питье ";
float  anim = 0;

void setup() {
    size(600, 600);
    background(0);
    frameRate(30);
    smooth(8);
    pixelDensity(2); //retina
    background(0);


    textSize(14);
    String fn = "Roboto-MediumItalic.ttf";
    mono = createFont(fn, font_size);
    textFont(mono);
}

void draw(){

    anim += 2 * PI / 300;
    background(0);


    float endSpeed = 0.15;
    float startSpeed = -0.3;
    float ds = (endSpeed - startSpeed);


    blendMode(BLEND);
    fill(255);
    renderText(endSpeed - (1 + sin(anim * 2)) * 0.05);




    if (frameCount < 15 * 30) {
        println(frameCount + " ");
        saveFrame("/Users/artem/work/creative-code/opart_17_invite/" + name + "/opart__####.tif");
    } else {
        noLoop();
    }

}

 


void drawLetter(char l, float x, float y, float speed){    
    PShape shape = mono.getShape(l);
    drawShape(shape, x, y, speed);     
}

void renderText(float speed){


    pushMatrix();
    translate(-30, -30);
    scale(1.3);
 
    txt = txt.toUpperCase();
    float tPosX = 0;
    float tPosY = 0;
    int len = txt.length();
    for (int f = 0; f < 3000; f++) {
        char lc = txt.charAt(f % len);
        String l = "" + lc;
        float letterW = textWidth(l) * 0.9;
        boolean space = lc == ' ' || lc == '\n';
        if (space) {
            letterW = font_size;
        }
        if (tPosX > width * 1.2) {
            tPosX = (f % 2) * font_size * 2;
            tPosY += font_size * 1.5;
        }
        

        float speedk = speed + tPosX / (width * 6);
       

        if (space) {
            if (random(1) > 0.5)
                fill(200, 140, 30);
            else
                fill(250, 200, 130);
            drawSpace(tPosX + letterW / 2, tPosY - font_size * 0.4, font_size * 0.15, speedk);
        }
        else {
          
            fill(255);
            if (random(1) > 0.01)
                drawLetter(lc, tPosX, tPosY, speedk);
        }

        tPosX += letterW + sin(anim) * 0.1;
       


    }

    popMatrix();

}




static float c = 1.; //speed of light = 1, for normalization

PVector lorentz(float space, float time, float v){
    float gammaLorentzFactor = 1 / sqrt(1 - v * v / c * c);

    float time1 = gammaLorentzFactor * (time - v * space / c * c);
    float space1 = gammaLorentzFactor * (space - v * time);

    return new PVector(space1, time1);
}




void drawSpace(float xx, float time0, float rad, float speed){

    float as=abs(speed);
    int alph = 255 - (int)(as * 255);
    beginShape();
    {
        // velocity relative to speed of light
        for (float a = 0; a < PI * 2; a += PI / 4) {
            float x = xx + rad * sin(a);
            float time = time0 + rad * cos(a);
            PVector r = lorentz(x, time, speed);
            vertex(r.x, r.y);
        }

        noStroke();
    }
    endShape();


}

void drawShape(PShape shape, float xx, float yy, float speed){

    float as=abs(speed);
    int alph = 255 - (int)(as * 255);

    beginShape();
    for (int i = 0; i < shape.getVertexCount(); i++) {
        PVector v = shape.getVertex(i);
        PVector r = lorentz(xx + v.x, yy + v.y, speed);
        vertex(r.x, r.y);
    }
    //fill(255, alph);
    noStroke();
    endShape();

}




void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_17_invite/opart__####.png");
}
