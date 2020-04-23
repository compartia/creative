import java.util.Comparator;
import java.util.Arrays;

boolean SAVE_IMAGES=false;
String poem_tmp=  
  "          мы некогда были газом,\n"+
            "заполняя собой пространство,\n"+
            "гоняли бизонов в саванне,\n"+
            "спорадически создавали\n"+
            "слабые детородные связи,\n"+
            "открывая тем самым переход фазовый, и\n"+
            "мы превратились в воду.\n"+
            "в течения, тренды и людовороты,\n"+
            "в рококо турбульона, в завитки моды.\n"+
            "поплатились, видимо, за фертильность.\n"+
            "в реках дорог плотины, тромбы\n"+
            "в трубах метро,\n"+
            "И вот новый фазовый переход.\n"+
            "Теперь мы в решетке кристалла,\n"+
            "в кубиках комнат, в отелях капсульных,\n"+ 
            "миллиарды уединений замерших,\n"+
            "полное оледенение глобуса\n"+
            
            "в принципе, жизнь -- это структура\n"+
            "с маленькой энтропией,\n"+
            "призванная лишь рассеивать\n"+ 
            "градиент энергии";


String poem = poem_tmp.toUpperCase().replaceAll("--", "—").replaceAll(" ", " ");
float ts = 25;

PFont f;

Letter[] letters;

float lineHeight = 1.62;
int minFramesStill = 50;

float INF_D = 5;
float motion_blur_steps = 1;

float speed = 1.0 / 180.0;

int motionblur_steps = 24;

int currentLetter = 0;

int k = 0;
float rotation_offset = 40;
float rotation_speed = 10;
float rotation_wave = 10;

PVector bbox;
ArrayList<PVector> dots;

void setup() {
    motion_blur_steps = 16;

    // size(864, 1080);//Instagramm best
    // size(300, 300); //testing FPS-optimal
    // 2560x1440 1280 x 720
    
    size(1280, 720);// Youtube 2K x pixel density
    
    background(200, 0, 0);
    pixelDensity(2);
    frameRate(30);
    smooth(4);

    float side_len = sqrt(height * width);
    ts = side_len / 70;
    f = createFont("FiraSans-Regular.ttf", ts, true);

    textFont(f, ts);
    textSize(ts);

    dots = makeDots();
    bbox = makeLetters(poem);

    for (int l = 0; l < letters.length; l++) {
        PVector d = dots.get(l);
        letters[l].target = d;
        if (random(1) < 0.02)
            letters[l].infected = true;

        letters[l].pos.x = randomGaussian() * width * 0.5;
        letters[l].pos.y = randomGaussian() * height * 0.5;
    }

    INF_D = side_len / 50;
 
}



PVector makeLetters(String line) {
    letters = new Letter[poem.length()];

    float x = 0;
    float y = 0;

    float maxX = 0;
    float maxY = 0;

    for (int i = 0; i < line.length(); i++) {
        String cc = line.substring(i, i + 1);
        float w = textWidth(cc);

        letters[i] = new Letter(cc);
        letters[i].pos = new PVector(x, y);
        letters[i].w = w;

        if (x > maxX)
            maxX = x;
        if (y > maxY)
            maxY = y;

        x += w;

        if ("\n".equals(cc)) {
            y += lineHeight * ts;
            x = 0;
        }
    }

    return new PVector(maxX, maxY);
}

void draw() {

    background(200, 10, 50);

    rotation_offset *= .994;

    rotation_speed *= 0.995;
    rotation_wave *= 0.95;

    fill(255, 3);
    translate(width / 2, height / 2);// ceter text on screen

    noStroke();
    for (int l = 0; l < dots.size(); l++) {
        PVector dot = dots.get(l);
        ellipse(dot.x, dot.y, 3, 3);
    }

    for (int l = 0; l < letters.length; l++) {
        letters[l].updateVelocity(letters);
    }
    for (int l = 0; l < letters.length; l++) {

        for (int al = 0; al < motion_blur_steps; al++) {
            letters[l].move(1. / motion_blur_steps);
            letters[l].draw(1. / motion_blur_steps);
        }

        letters[l].decay();
    }

    if (frameCount < 60 * 30 && SAVE_IMAGES)
        saveFrame("hd/poem__####.png");
}

ArrayList<PVector> makeDots() {
    int N = 20;
    float offset = min(width, height) / 10.0;
    float dist = min(width, height) / (float) N;

    float base_radius = N * dist;
    print(base_radius);
    float dotsX = dist; 
    float dotsY = dist; 
    float dx = 2 * base_radius * sin(radians(60));
    float dy = base_radius / 2 + 2 * base_radius * cos(radians(60));

    float dot_dx = dx / dotsX;
    float dot_dy = dy / dotsY;



    ArrayList<PVector> list = new ArrayList();

    int yc = 0;
    for (float y = -height / 2 + offset; y < height / 2 - offset; y += dot_dy) {
        float o = yc % 2 == 0 ? 0 : dot_dx / 2;

        for (float x = -width / 2 + offset; x < width / 2 - offset; x += dot_dx) {

            PVector pv = new PVector(x + o, y);
            list.add(pv);

        }
        yc++;
    }

    return list;

}

void mouseReleased() {
    looping = !looping;
    if (looping) {
        loop();
    } else {
        noLoop();
    }
    println(frameCount);
    saveFrame("poem__####.png");
}
