PFont mono;
float font_size = 19;
int DY= (int)(font_size*1.4);//(int)(font_size * 2);


//Wavelength (nm)  656.45377[2]  486.13615[3]  434.0462[3]  410.174[4]  397.0072[4]  388.9049[4]  383.5384[4]  364.6

//Balmer series 
//float[] hydrogen_visible = { 656.45377,  486.13615,  434.0462,  410.174,  397.0072,  388.9049,  383.5384 };
float[] hydrogen_visible = { 656.45377,  486.13615,  434.0462,  410.174 };//,  388.9049,  383.5384 };

float getRandomWaveLen(){
  float balmer = hydrogen_visible[ (int)random(hydrogen_visible.length) ] ;
  
  return (balmer + random(0.5)-0.25) * (1e-3);
}
 
int fps=30;
int animationLen = 40 * fps;
int framesToSave = animationLen;
 
double spectrum_start = 390e-3; //(micrometers)
double spectrum_end = 700e-3;

String txt222="приходи\n"+
"birthday_party\n"+
"privet_annette\n"+
"1 февраля 2020\n"+
"суббота\ndress_code: be_sexy\n"+
"кутузовский_проспект 12 стр 9\n"+
"campus_zavod\n"+
"жду тебя\n"+
"15:00";

String txt="тихо-тихо\n"+
"ползет\n"+
"улитка\n"+
"по склону\n"+
"пирамиды Маслоу";

PVector[] coords;
PVector[] targetCoords;

float  anim = 0;

float xOffset=0;

void setup() {  
  //txt+=txt;
  //txt+=txt;
  
   
  txt = txt.toUpperCase();
    size(540, 540);
    background(0, 0, 100);
    frameRate(30);
    smooth(4);
    pixelDensity(2); //retina
    background(0);


    //textSize(14);
    String fn = "Roboto-Medium.ttf";
    //String fn = "UbuntuMono-Bold.ttf";
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
   coords[f] = new PVector(random(width/40)-width/80 + targetCoords[(f+(int)random(5))%len].x, targetCoords[f].y);
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
        float letterW = 1.2*textWidth("" + lc);
       // boolean space = lc == ' ' || lc == '.'|| lc == ','|| lc == '-';
        //if (space) {
        //    letterW = font_size;
        //}
        if (lc == '\n') {
           // tPosX = (f % 2) * font_size * 2;
           tPosX = sin(f)*70;
           tPosY += DY;
        }
        
        
        lcoords[f] = new PVector(tPosX, tPosY);         

        tPosX += letterW ;
       
    }

    return lcoords;
   
}

void draw(){
    
    anim += 4 * PI / animationLen;
    if(random(1)<0.01){
      background(random(255));
      //scale(0.98);
    }
    else{
      //background(0);
      //fill(0, random(250));
      fill(0, 0, 50, 80);
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
    renderText(frameCount -200);
    
    //renderText(frameCount +320);
    popMatrix();
    


    if (frameCount < framesToSave) {
        println(frameCount + " ");
        saveFrame("/Users/artem/work/creative-code/opart_21_inv6/opart__####.tif");
    } else {
        noLoop();
    }
    
    noFill();
    strokeWeight(5);
    stroke(0, 0, 50);
    blendMode(BLEND);
    rect(0, 0, width, height);

}


class Side {
    public PVector r0;
    public PVector r1;

    public Side(PVector p1, PVector p2) {
        this.r0 = p1.copy();
        this.r1 = p2.copy();
    }

    public PVector dir() {
        return PVector.sub(this.r1, this.r0);
    }

    PVector intersect(PVector line2A, PVector line2B) {
        PVector inter = intersection(this.r0, this.r1, line2A, line2B);
        if (inter == null) {
            inter = intersection(this.r1, this.r0, line2A, line2B);
        }

        if (inter == null) {
            inter = intersection(this.r0, this.r1, line2B, line2A);
        }
        return inter;
    }

}

PVector intersection(PVector line1A, PVector line1B, PVector line2A, PVector line2B){
    PVector sub = PVector.sub(line1B, line1A);
    float a = sub.y / sub.x;
    float b = line1A.y - a * line1A.x;


    PVector sub1 = PVector.sub(line2B, line2A);
    float a1 = sub1.y / sub1.x;
    float b1 = line2A.y - a1 * line2A.x;

    float x = (b1 - b) / (a - a1);
    float y = a * x + b;

    if ((x > min(line1A.x, line1B.x)) && (x < max(line1A.x, line1B.x)) && (y > min(line1A.y, line1B.y)) && (y < max(line1A.y, line1B.y))
        && (x > min(line2A.x, line2B.x)) && (x < max(line2A.x, line2B.x)) && (y > min(line2A.y, line2B.y)) && (y < max(line2A.y, line2B.y))) {
        return new PVector(x, y);
    }
     //return new PVector(x, y);
    return null;
}



ArrayList<Side> listEdges(PShape prism, ArrayList<Side> into, PVector pos, float rot){
  
   
  for (int i = 0; i < prism.getVertexCount()-1; i++) {
    PVector v1 = prism.getVertex(i).rotate(rot).add(pos);
    PVector v2 = prism.getVertex(i+1).rotate(rot).add(pos);
        
    into.add(new Side(v1, v2));
    
   
  }
 
   if(prism.getVertexCount()>=3){
      PVector v1 = prism.getVertex(prism.getVertexCount()-1).rotate(rot).add(pos);
      PVector v2 = prism.getVertex(0).rotate(rot).add(pos);
      into.add(new Side(v1, v2));
   }
  //into.add(new Side(prism.getVertex(prism.getVertexCount()-1), prism.getVertex(0)));   //<>//
  return into;
}

float rotrot=-radians(90);
void renderText( int fc){
    
    ArrayList<Side> sides =new  ArrayList();

    pushMatrix();
    translate(200, 350);
    rotate(rotrot);
    scale(0.8);
 
    //translate(random(1), 0);
    
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
      
      phasep=(sin(phasep*5)+1.6)/2;
      
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
            float rot= 0;//PI*(1-blend); 
            //fill(255, blend*255);
            //double spectrum_start = 390e-3; //(micrometers)
            //double spectrum_end = 700e-3;
            if(blend<0.98){
               
              //float wavelen1 = (float)(spectrum_start + random(1)*(spectrum_end - spectrum_start)) ;
               
              //float wavelen2 = lerp((float)spectrum_end, (float)spectrum_start, 1-phasep);//(float)(spectrum_start + blend*(spectrum_end - spectrum_start)) ;
              //float wavelen = lerp(wavelen1, wavelen2, 0.33);
              
              float  wavelen = getRandomWaveLen();
              fill(waveLengthToRGB(wavelen * 1e3), blend*255);
            }else{
              fill(255, blend*255);
            }
            //if (random(1) > 0.01)
                //drawLetter(lc, lx, ly, 1, 2*PI*sin(1*PI*blend));
                drawLetter(lc, lx, ly, 1, rot);
            //drawLetter(lc, lx, ly, 1, 0);
            
            PShape s= mono.getShape(lc);
            //PShape s=createShape(TRIANGLE,0,0,10,0,5,10);
            if(s!=null)
              listEdges(s, sides, new PVector(lx, ly), rot);
        }

 
    }


    //for (Side s :sides){
    // stroke(255, 0,0, 60);
    //  line(s.r0.x, s.r0.y, s.r1.x, s.r1.y);
    //}
   
    drawRays( sides, 400, anim/2);
    drawRays( sides, 200, anim-PI/2); 
    drawRays( sides, 200, anim*0.43+PI);
    
    
    blendMode(BLEND);
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
    
    time1  += 5*cos(anim*2+r);
    space1 += 5*sin(anim*2+r);
    
    return new PVector(space1, time1);
}




void drawSpace(float xx, float time0, float rad, float speed){
 
    beginShape();
    {
        // velocity relative to speed of light
        for (float a = 0; a < PI * 2; a += PI / 4) {
            float x = xx + rad * sin(a);
            float time = time0 + rad * cos(a);
            PVector r = lorentz(x, time, 0);
            vertex(r.x, r.y);
        }

        noStroke();
    }
    endShape();


}

void drawLetter(char l, float x, float y, float speed, float rotation){    
    //PShape s = mono.getShape(l);
     
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    translate(-x, -y);
    
    PVector r = lorentz(x, y, speed);
    //s.translate(r.x, r.y);
    //shape(s, r.x, r.y);
    //drawShape(s, x, y, speed, rotation);     
    text(l, r.x, r.y);
    
    popMatrix();
}


void drawShape(PShape shape, float xx, float yy, float speed, float rotation){
  pushMatrix();
  
    translate(xx, yy);
    rotate(rotation);
    translate(-xx, -yy);

    beginShape();
    for (int i = 0; i < shape.getVertexCount(); i++) {
        PVector v = shape.getVertex(i);
        PVector r =   lorentz(xx + v.x, yy + v.y, speed);
        vertex(r.x, r.y);
    }
    //fill(255, alph);
    
    noStroke();
    endShape();
    
   
    
  popMatrix();
  
   fill(0,200,0);
    PVector r =   lorentz(xx , yy , 0);
    ellipse(r.x,r.y,20,20);
    shape(shape, 200, 200);
}




float clamp(float lo, float  hi, float v){
    return max(lo, min(hi, v));
}

PVector refract(PVector I, PVector N, float ior)
{
    PVector ii = I.copy();
    float cosi = clamp(-1, 1, I.dot(N));
    float etai = 1, etat = ior;
    PVector n = N.copy();
    if (cosi < 0) {
        cosi = -cosi;
    } else {
        float tmp = etai;
        etai = etat;
        etat = tmp;
        n.mult(-1);
    }
    float eta = etai / etat;
    float k = 1 - eta * eta * (1 - cosi * cosi);
    float w = eta * cosi - sqrt(k);
    return k < 0 ? new PVector() : ii.mult(eta).add(n.mult(w));
}

//=======================================
float ri_by_wl(float  waveLength, float refractive_index){
    
    //according to Cauchy’s equation n= a + (b/λ^2)
    double waveLength2 = waveLength * waveLength;
    double n = refractive_index + dispersion / waveLength2;    
    return (float)n; 
}


float refractive_index = 1.5220;
double dispersion = 0.0959e2; //(μm2)

PVector[] refractWith( PVector _r0, PVector _r1, Side wall, float waveLength){

    PVector hit = wall.intersect(_r0, _r1);

    PVector ray_dir = PVector.sub(_r1, _r0);
    PVector wall_dir = wall.dir().rotate(PI / 2);

    float ior = ri_by_wl(waveLength, (float)refractive_index);
    PVector refracted = refract(ray_dir, wall_dir, ior);
    refracted.setMag(width*2.5);
    refracted.add(hit);

    PVector[] ret = new PVector[2];
    ret[0] = hit;
    ret[1] = refracted;

    return ret;
}

void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_21_poem/opart__####.png");
}






void drawRays(ArrayList<Side> sides, int totalRays, float anim) {
  int strokeAlpha = (int)(8. * 255. / (float)totalRays);
  double delta_spectrum = (spectrum_end - spectrum_start) / (double)totalRays;
     
    blendMode(ADD);    
     
    //------------------

    int sp=DY;
    float offset = width/(float)sp;// height / (2. * (float)totalRays);
    float offsetY = 0;//height / 2. - ((float)totalRays * offset) /2;

    for (int i = 0; i < totalRays; i++) {
        int k = (int)random(totalRays);

 
        
        float xxx = random(i)/50.0;//(int)((i*offset-100)/sp) * sp-510;
        PVector r0 = new PVector(-500, -250+xxx+ width/2 + sin(anim*0.53) * width/2.2);
        PVector r1 = new PVector(0, 1.1);
        r1.rotate(rotrot);
        r1.setMag(height*2);
        r1.add(r0);
        
        //line(r0.x, r0.y, r1.x, r1.y);

        float wavelen = getRandomWaveLen();//(float)(spectrum_start + i * delta_spectrum);

        ArrayList < PVector > points = new ArrayList();
       points.add(r0);
         
        for (int s = 0; s <12; s++) {
            Side side = getClosestIntersect(r0, r1, sides);
            if (side != null) {
    //print("side");
                PVector[] r = refractWith(  r0, r1, side, wavelen);
                r0 = r[0];
                r1 = r[1];
                points.add(r[0]);

            } else {    
             //print("no side");
                //no intersection
            }
        }
        points.add(r1);


        strokeWeight(2);
        noFill();
   
        stroke(waveLengthToRGB(wavelen * 1e3), strokeAlpha);
        beginShape();
        {
            for (PVector p : points) {
                vertex(p.x, p.y);
            }
        }
        endShape();
    }


}

Side getClosestIntersect(PVector l1, PVector l2,  ArrayList<Side> sides){
    Side best = null;
    float eps = 0.02;
    float bestdist = -1;
    for (Side side : sides) {
        PVector i = side.intersect(l1, l2);
        if (i != null) {
            float dist = i.dist(l1);
            if (dist > eps) {
                if (best == null) {
                    best = side;
                    bestdist = dist;
                } else {
                    if (dist < bestdist) {
                        best = side;
                        bestdist = dist;
                    }
                }
            }
        }
    }

    return best;
}


static private double Gamma = 0.80;
static private double IntensityMax = 255;

/** Taken from Earl F. Glynn's web page:
* <a href="http://www.efg2.com/Lab/ScienceAndEngineering/Spectra.htm">Spectra Lab Report</a>
* */
public color waveLengthToRGB(double Wavelength){
    double factor;
    double Red, Green, Blue;

    if ((Wavelength >= 380) && (Wavelength < 440)) {
        Red = -(Wavelength - 440) / (440 - 380);
        Green = 0.0;
        Blue = 1.0;
    } else if ((Wavelength >= 440) && (Wavelength < 490)) {
        Red = 0.0;
        Green = (Wavelength - 440) / (490 - 440);
        Blue = 1.0;
    } else if ((Wavelength >= 490) && (Wavelength < 510)) {
        Red = 0.0;
        Green = 1.0;
        Blue = -(Wavelength - 510) / (510 - 490);
    } else if ((Wavelength >= 510) && (Wavelength < 580)) {
        Red = (Wavelength - 510) / (580 - 510);
        Green = 1.0;
        Blue = 0.0;
    } else if ((Wavelength >= 580) && (Wavelength < 645)) {
        Red = 1.0;
        Green = -(Wavelength - 645) / (645 - 580);
        Blue = 0.0;
    } else if ((Wavelength >= 645) && (Wavelength < 781)) {
        Red = 1.0;
        Green = 0.0;
        Blue = 0.0;
    } else {
        Red = 0.0;
        Green = 0.0;
        Blue = 0.0;
    };

    // Let the intensity fall off near the vision limits

    if ((Wavelength >= 380) && (Wavelength < 420)) {
        factor = 0.3 + 0.7 * (Wavelength - 380) / (420 - 380);
    } else if ((Wavelength >= 420) && (Wavelength < 701)) {
        factor = 1.0;
    } else if ((Wavelength >= 701) && (Wavelength < 781)) {
        factor = 0.3 + 0.7 * (780 - Wavelength) / (780 - 700);
    } else {
        factor = 0.0;
    };


    int[] rgb = new int[3];

    // Don't want 0^x = 1 for x <> 0
    rgb[0] = Red == 0.0 ? 0 : (int) Math.round(IntensityMax * Math.pow(Red * factor, Gamma));
    rgb[1] = Green == 0.0 ? 0 : (int) Math.round(IntensityMax * Math.pow(Green * factor, Gamma));
    rgb[2] = Blue == 0.0 ? 0 : (int) Math.round(IntensityMax * Math.pow(Blue * factor, Gamma));

    return color(rgb[0], rgb[1], rgb[2]) ;
}
