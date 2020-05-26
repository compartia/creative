import java.util.Comparator;
import java.util.Arrays;

boolean SAVE_IMAGES = true;
String poem_tmp = "                         мы некогда были газом,\n" + "заполняя собой пространство,\n"
        + "гоняли бизонов в саванне,\n" + "спорадически создавали\n" + "слабые детородные связи,\n"
        + "открывая тем самым переход фазовый, и\n" + "мы превратились в воду.\n"
        + "в течения, тренды и людовороты,\n" + "в рококо турбульона, в завитки моды.\n"
        + "поплатились, видимо, за фертильность.\n" + "в реках дорог плотины, тромбы\n" + "в трубах метро,\n"
        + "И вот новый фазовый переход.\n" + "Теперь мы в решетке кристалла,\n"
        + "в кубиках комнат, в отелях капсульных,\n" + "миллиарды уединений замерших,\n"
        + "полное оледенение глобуса\n" +

        "в принципе, жизнь -- это структура\n" + "с маленькой энтропией,\n" + "призванная лишь рассеивать\n"
        + "градиент энергии";

String poem = poem_tmp.toUpperCase().replaceAll("--","—").replaceAll(" "," ") ;
float ts=25;

PFont f;
float speed = 1.0 / 180.0;

int motionblur_steps = 24;

int currentLetter = 0;

int k = 0;
float rotation_offset = 40;
float rotation_speed = 10;
float rotation_wave = 10;

Letter[] letters;

float lineHeight=1.62;
int minFramesStill = 50;

float INF_D=4;


PVector bbox;
ArrayList<PVector> dots;
void setup() {
    
    size(600, 600); // testing FPS-optimal
    background(200, 0, 0);
    // pixelDensity(2);
    frameRate(30);
    smooth(4);

    ts = height / 82;
    f = createFont("FiraSans-Regular.ttf", ts, true);

    textFont(f, ts);
    textSize(ts);

    dots = makeDots();
    bbox = makeLetters(poem);

    for (int l = 0; l < letters.length; l++) {
        PVector d = dots.get(l);
        letters[l].target = d;
        if (random(1) < 0.01)
            letters[l].infected = true;

        letters[l].pos.x = randomGaussian() * width * 0.5;
        letters[l].pos.y = randomGaussian() * height * 0.5;
    }

    INF_D = 20;// width/500.0;
    //
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
    background(200, 30, 0);

    rotation_offset *= .994;

    rotation_speed *= 0.995;
    rotation_wave *= 0.95;

    fill(255, 190);
    translate(width / 2, ts * 2 + height / 2);// ceter text on screen
    scale(1.3);
    for (int l = 0; l < letters.length; l++) {
        letters[l].updateVelocity(letters);
    }
    for (int l = 0; l < letters.length; l++) {
        letters[l].move();
        letters[l].draw();

    }

}

ArrayList<PVector> makeDots() {
    int N = 3;
    float base_radius = (width / N) / sin(radians(60)) / 2;
    float dotsD = 13;
    float dx = 2 * base_radius * sin(radians(60));
    float dy = base_radius / 2 + 2 * base_radius * cos(radians(60));

    float dot_dx = dx / dotsD;
    float dot_dy = dy / dotsD;

    ArrayList<PVector> list = new ArrayList();

    for (float y = -(N / 2) * dotsD; y < (N / 2) * dotsD; y += 1) {
        float o = y % 2 == 0 ? 0 : dot_dx / 2;

        for (float x = -(N / 2) * dotsD; x < (N / 2) * dotsD; x += 1) {

            PVector pv = new PVector(x * dot_dx + o, y * dot_dy);
            list.add(pv);

        }
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
