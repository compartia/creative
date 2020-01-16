PFont mono;
float font_size = 26;

int framesToSave = 1;//30 * 30;

int fps=30;
int animationLen = 20 * fps;

 


String txt="приходи\n"+
"birthday_party\n"+
"privet_annette\n"+
"1 февраля 2020\n"+
"суббота\ndress_code: be_sexy\n"+
"кутузовский_проспект 12 стр 9\n"+
"campus_zavod\n"+
"жду тебя\n"+
"15:00\n";



PVector[] coords;
PVector[] targetCoords;

float  anim = 0;

void setup() {
  //txt+=txt;
  //txt+=txt;
  
   
  txt = txt.toUpperCase();
    size(540, 960);
    background(0, 0, 100);
    frameRate(30);
    smooth(4);
    //pixelDensity(2); //retina
    background(0);


    textSize(14);
    String fn = "Roboto-Light.ttf";
    mono = createFont(fn, font_size);
    textFont(mono);
    
    targetCoords = calcTargetCoords();
    makeData();
}


void makeData(){
 int len = txt.length();
 coords =new PVector[txt.length()];
 for (int f = 0; f < len; f++) {
   //coords[f] = targetCoords[(int)random(len)].x ;
   coords[f] = new PVector(random(width/4)-width/8 + targetCoords[(f+(int)random(5))%len].x, targetCoords[f].y);
   //new PVector(random(width*2)-width/2, random(width*2)-width/2);
   //coords[f].mult(1.6);
   //coords[f].add(targetCoords[f]);
 }
}


PVector[] calcTargetCoords( ){
  PVector[] lcoords =new PVector[txt.length()];
  
  float tPosX = 0;
  float tPosY = 0;
 
    for (int f = 0; f < txt.length(); f++) {
        char lc = txt.charAt(f);
        float letterW = textWidth("" + lc);
       // boolean space = lc == ' ' || lc == '.'|| lc == ','|| lc == '-';
        //if (space) {
        //    letterW = font_size;
        //}
        if (lc == '\n') {
           // tPosX = (f % 2) * font_size * 2;
           tPosX = sin(f)*100;
           tPosY += font_size * 2.8;
        }
        
        
        lcoords[f] = new PVector(tPosX, tPosY);         

        tPosX += letterW ;
       
    }

    return lcoords;
   
}

void draw(){
    
    anim += 2 * PI / 300;
    if(random(1)<0.01){
      background(random(255));
      //scale(0.98);
    }
    else{
      //background(0);
      //fill(0, random(250));
      fill(0, 0, 70, 70);
      rect(0, 0, width, height);
    
    }

    //scale(0.9);
    float endSpeed = -0;
 

    blendMode(BLEND);
    fill(255);
     
    
    //pushMatrix();
    //renderText( (int ) (sin(frameCount/200.)*400));
    //popMatrix();
    
    //fill(0, 0, 70, 170);
    //rect(0, 0, width, height);
     pushMatrix();
    renderText(frameCount -100);
    
    //renderText(frameCount +320);
    popMatrix();
    


//    if (frameCount < framesToSave) {
//        println(frameCount + " ");
//        saveFrame("/Users/artem/work/creative-code/opart_20_poem/opart__####.tif");
//    } else {
//        noLoop();
//    }

}





void drawLetter(char l, float x, float y, float speed, float rotation){    
    PShape shape = mono.getShape(l);
    drawShape(shape, x, y, speed, rotation);     
}

void renderText( int fc){


    pushMatrix();
    translate(120, 260);
    rotate(-radians(15));
    scale(0.8);
 
    translate(random(1), 0);
    
    int len = txt.length();
    
    float  lettersPerFrame = (float)animationLen / (float)len;
    //println(lettersPerFrame+" " + animationLen +" "+ len);
    
    //for (int f = 0; f < len; f++) {
    //  fill(255, 40);
    //  PVector tPos = targetCoords[f];
    //  drawSpace(tPos.x, tPos.y-font_size/2, random(4),1);
    //}
    for (int f = 0; f < len; f++) {
      
      
      int phase = (fc +(len-f)) % animationLen;
      float phasep = 6 * (float)phase / (float)animationLen;
      
      phasep=(sin(phasep*5)+1.3)/2;
      
      PVector tPos = targetCoords[f];
       
    
        char lc = txt.charAt(f % len);
 
        float lx = tPos.x;
        float ly = tPos.y;
         
        float blend =phasep;// sin(sin(anim*2)*3)/10;
        blend= sqrt(blend);
        if(blend>1) blend=1;
       
       //float blend=1;
       
        lx = lerp(coords[f].x, tPos.x,  blend);
        ly = lerp(coords[f].y, tPos.y,  blend);
        
 
        {
          
            fill(255, blend*255);
            //if (random(1) > 0.01)
                //drawLetter(lc, lx, ly, 1, 2*PI*sin(1*PI*blend));
                //drawLetter(lc, lx, ly, 1, -PI*(1-blend));
                drawLetter(lc, lx, ly, 1, 0);
        }

 
    }

    popMatrix();

}




static float c = 1.; //speed of light = 1, for normalization

PVector lorentz(float space1, float time1, float v){
    //float gammaLorentzFactor = 1 / sqrt(1 - v * v / c * c);

    //float time1 = gammaLorentzFactor * (time - v * space / c * c);
    //float space1 = gammaLorentzFactor * (space - v * time);


    float r = sqrt((space1+200)*(space1+200) + (time1+200)*(time1+200))/60;
    //space1+=15*sin(anim*3+r/30.);    
    time1+=2*cos(anim*8+time1/30.);
    
    time1+=2*cos(anim*2+r);
    space1+=2*sin(anim*2+r);
    
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

void drawShape(PShape shape, float xx, float yy, float speed, float rotation){
  pushMatrix();
  translate(xx, yy);
    rotate(rotation);
    translate(-xx, -yy);
    
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
popMatrix();
}




void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_19_poem/opart__####.png");
}
