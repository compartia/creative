import java.util.Comparator;
import java.util.Arrays;


boolean SAVE_IMAGES = false;
String wordings_t = "révolutionnai";
String wordings = wordings_t.toUpperCase().replaceAll("--", "—").replaceAll(" ", " ");
float ts;

PFont f;

float lineHeight = 1.62;
int minFramesStill = 50;

PVector bbox;

float degdeg = 0;
float framesPerRevolution = 800;

void setup() {

    size(864, 1080);// Instagramm best

    pixelDensity(2);
    frameRate(30);
    smooth(4);

    ts = height / 18;
    f = createFont("Literata-VariableFont_wght.ttf", ts, true);

    textFont(f, ts);
    textSize(ts);
    background(0);

}

void draw() {

    blendMode(MULTIPLY);
    fill(0, 190);
    rect(0, 0, width, height);

    pushMatrix();
    translate(width / 2, height / 2);

    float degdeginc = -2 * PI / framesPerRevolution;
    degdeg += degdeginc;

    String p = wordings;

   

    float a_reve = (sin(frameCount / 5.0) + 2.0) * 64;
    color clr_reve = color(255, 180, 255, a_reve * 0.5);

    float a_naive = (sin(frameCount / 7.0) + 2.0) * 64;
    color clr_naive = color(220, 255, 255, a_naive * 0.5);

    float a_lutin = (sin(frameCount / 4.0) + 2.0) * 64;
    color clr_lutin = color(255, 220, 220, a_lutin * 0.5);

    float a_alt = (sin(frameCount / 8.0) + 2.0) * 64;
    color clr_alt = color(255, a_alt);

    if (random(3) < 1) {
        p = "f         naï";         
    }

    if (random(3) < 1) {
        p = "    lutin    ";       
    }

    p = p.toUpperCase();

    blendMode(ADD);
    float rot = 0.1 * sin(frameCount / 10.0);
    float rot2 = 0.1 * sin(frameCount / 8.0);
    float rot3 = 0.1 * sin(frameCount / 6.0);

    // scale(0.75);
    draw_c("rêve         ".toUpperCase(), degdeg + rot, clr_reve);
    // scale(0.84);
    draw_c("f         naï".toUpperCase(), degdeg + rot2, clr_naive);
    // scale(0.84);
    draw_c("    lutin    ".toUpperCase(), degdeg + rot3, clr_lutin);

    blendMode(ADD);
    draw_c(wordings, degdeg, clr_alt);

    popMatrix();

    if (frameCount < framesPerRevolution && SAVE_IMAGES)
        saveFrame("revolution_####.png");
}

void draw_c(String poem, float degdeg, color clr){
    
    for(int i=0; i<poem.length(); i++){
    pushMatrix();
        String cc = poem.substring(i,i+1);
        float w = textWidth(cc);
        
        float r = 2* PI * float(i)/(float)poem.length();
        rotate(r+degdeg);
        int gg=(int)((cos(r+50*degdeg)+1)*128.0);
        int bb=(int)((cos(r+22*degdeg)+1)*128.0);
        fill(255-bb/2,255-gg/3, 128+bb/2, alpha(clr));
        float y=-width/4.; 
        
        text(cc, 0-w/2, y);
        fill(clr);
        text(cc, 0-w/2, y );
        
    
    popMatrix();
    }
    
    
}

void mouseReleased() {
    looping = !looping;
    if (looping) {
        loop();
    } else {
        noLoop();
    }
    println(frameCount);
    saveFrame("revolution__####.png");
}
