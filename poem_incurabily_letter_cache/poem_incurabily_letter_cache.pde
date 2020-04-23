import java.util.Comparator;
import java.util.Arrays;

boolean SAVE_IMAGES=false;

String poem_tmp=
  "Приплыли, Сеньорита!\n"+
  "Fondamenta degli Incurabili.\n"+
  "Ложитесь, загорайте, \n"+
  "ваш случай неизлечим.\n"+
  "Прикройте веки монетами \n"+ 
  "от ультрафиолета лучей --\n"+
  "тут уже не Венеция.\n"+
  "Не удивляйтесь, но\n"+
  "это конечная лодочная станция\n"+
  "-- Варанаси. Да,\n"+
  "я бы тоже подумал “нихуясе”,\n"+
  "но следует проверить гипотезу о\n"+ 
  "метемпсихозе.";





PVector bbox;
String poem = poem_tmp.toLowerCase().replaceAll("--", "—").replaceAll(" ", " ");
float ts = 25;

PFont f;

Letter[] letters;
Glyph[] glyphs;

float lineHeight = 1.62;
int minFramesStill = 50;
GComparator aGComparator = new GComparator();

int currentLetter = 0;

 

class GComparator implements Comparator<Glyph> {
    int compare(Glyph a, Glyph b) {
        return -a.stillFrames + b.stillFrames;
    }
}

 
void setup() {

    size(864, 1080);// Instagramm best
    // size(600, 600); //testing FPS-optimal
    background(255);
    pixelDensity(2);
    frameRate(30);
    smooth(4);

    ts = height / 32;
    f = createFont("Literata-VariableFont_wght.ttf", ts, true);

    textFont(f, ts);
    textSize(ts);

    bbox = makeLetters(poem);
    //
}
    
void draw() {
    Arrays.sort(glyphs, aGComparator);
    translate((width - bbox.x) / 2, (height - bbox.y) / 2);// ceter text on screen

    background(0);
    fill(255, 140);

    drawPoem();

    if (frameCount < 3000 && SAVE_IMAGES)
        saveFrame("poem_####.png");
}

PVector makeLetters(String line) {
    letters = new Letter[poem.length()];
    glyphs = new Glyph[poem.length()];

    float x = 0;
    float y = 0;

    float maxX = 0;
    float maxY = 0;

    for (int i = 0; i < line.length(); i++) {
        String cc = line.substring(i, i + 1);
        float w = textWidth(cc);

        letters[i] = new Letter(cc);
        letters[i].pos = new PVector(x, y);

        glyphs[i] = new Glyph(cc);
        glyphs[i].pos = letters[i].pos.copy();
 
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

    for (Glyph g : glyphs) {
        g.pos.x = 2 * maxX * randomGaussian();
        g.pos.y = 100 + 4 * maxY * abs(randomGaussian());
    }
    return new PVector(maxX, maxY);
}

    

void drawPoem() {

    for (Glyph l : glyphs) {
        l.draw();            
    }

  
    if (frameCount % 3 == 0) {
        Letter cl = letters[currentLetter];
        Glyph cg = findFreeGlyph(cl);
        if (cg != null) {
            cg.setNewTarget(cl);
            currentLetter = (currentLetter + 1) % letters.length;
        }
    }
}

Glyph findFreeGlyph(Letter l) {
    for (Glyph g : glyphs) {
        if (g.canReuse() && g.c.equals(l.c)) {
            return g;
        }
    }
    return null;
}



void mouseReleased() {
    looping = !looping;
    if (looping) {
        loop();
    } else {
        noLoop();
    }
    println(frameCount);
    saveFrame("poem_####.png");
}
