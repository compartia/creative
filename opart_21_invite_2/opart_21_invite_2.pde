PFont mono;
float font_size = 15;

int framesToSave = 1;//30 * 30;

int fps=30;
int animationLen = 20 * fps;

String txt="Темнокожие комми-\n"+
"вояжеры мысленные\n"+
"тянут из прежнего \nбаржи порожних гимнов.\n"+
"Тростником сахарным заросли речи,\n"+
"берега аппарата накрашены кетчупом,\n"+
"на хлопчато-неважных встречах разводим подсчет овечек --\n"+
"вычисление индекса нежности на единицу евро.\n"+
"Раб электронной лампы натирает экраны,\n"+
"социальное желание -- это гидромассажная ванна\n"+
"с пузырями экономическими, в которой барахтаясь,\n"+
"фекалия человеческой субъективности\n"+
"исполняет приказ общества демонстративно\n"+
"получать от него удовольствие.\n"+
"Душа-недотрога, тело без органов,\n"+
"ментальная светопись, фотовспышка вечности\n"+
"арестована здесь ходзёдзюцу-мастером дождевого леса.\n"+
"Оптическими лианами, коаксиальными стеблями\n"+
"и витыми ветвистыми парами\n";


PVector[] coords =new PVector[txt.length()];
PVector[] targetCoords;

float  anim = 0;

void setup() {
    size(640, 640);
    background(0);
    frameRate(30);
    smooth(8);
    pixelDensity(2); //retina
    background(0);


    textSize(14);
    String fn = "Roboto-MediumItalic.ttf";
    mono = createFont(fn, font_size);
    textFont(mono);
    
    targetCoords = calcTargetCoords();
    makeData();
}


void makeData(){
 int len = txt.length();
 
 for (int f = 0; f < len; f++) {
   coords[f] = new PVector(random(width*2)-width/2, random(width*2)-width/2);
 }
}


PVector[] calcTargetCoords( ){
  PVector[] lcoords =new PVector[txt.length()];
  
  float tPosX = 0;
  float tPosY = 0;
 
    for (int f = 0; f < txt.length(); f++) {
        char lc = txt.charAt(f);
        String l = "" + lc;
        float letterW = textWidth(l) * 0.9;
        boolean space = lc == ' ' || lc == '.'|| lc == ','|| lc == '-';
        if (space) {
            letterW = font_size;
        }
        if (tPosX > width * 1.2 || lc == '\n') {
            tPosX = (f % 2) * font_size * 2;
            tPosY += font_size * 1.5;
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
      scale(0.98);
    }
    else{
      //background(0);
      fill(0, random(250));
      rect(0, 0, width, height);
    
    }

    scale(0.9);
    float endSpeed = -0;
 

    blendMode(BLEND);
    fill(255);
     
    renderText( );
    


//    if (frameCount < framesToSave) {
//        println(frameCount + " ");
//        saveFrame("/Users/artem/work/creative-code/opart_20_poem/opart__####.tif");
//    } else {
//        noLoop();
//    }

}





void drawLetter(char l, float x, float y, float speed){    
    PShape shape = mono.getShape(l);
    drawShape(shape, x, y, speed);     
}

void renderText( ){


    pushMatrix();
    translate(120, 230);
    rotate(-radians(10));
    scale(0.8);
 
    txt = txt.toUpperCase();
    
    int len = txt.length();
    
    float  lettersPerFrame = (float)animationLen / (float)len;
    println(lettersPerFrame+" " + animationLen +" "+ len);
    
    
    for (int f = 0; f < len; f++) {
      
      
      int phase = (frameCount +(len-f)) % animationLen;
      float phasep = 3 * (float)phase / (float)animationLen;
      
      PVector tPos = targetCoords[f];
       
    
        char lc = txt.charAt(f % len);
 
        float lx = tPos.x;
        float ly = tPos.y;
         
        float blend =phasep;// sin(sin(anim*2)*3)/10;
        if(blend>1) blend=1;
       
       //float blend=1;
        lx = lerp(coords[f].x, tPos.x,  blend);
        ly = lerp(coords[f].y, tPos.y,  blend);
        

       
       
 
        {
          
            fill(255);
            //if (random(1) > 0.01)
                drawLetter(lc, lx, ly, 1);
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
    saveFrame("/Users/artem/work/creative-code/opart_19_poem/opart__####.png");
}
