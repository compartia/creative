String poem="На белой бумаге черная итальянская магия\n"+
          "грабит банки чернил и памяти.\n"+
          "Вселенная, пленница символов,\n"+
          "исполняет любовь под дуду алхимии.\n"+
          "Теперь не имеет значения, любовь истинна или\n"+
          "она -- лишь симптом, эдакий Стокгольмский синдром.\n"+
          "Абракадабра мантры в действии. Ом шанти ом!\n"+
          
          "Когда плотность чудес, как в кино,\n"+
          "неофобия просит одно: детоксикации! --\n"+
          "за шевелюру -- на дно --\n"+
          "фокус Мюнхгаузена, только в противофазе --\n"+
          "спрятать остатки себя в облаках каракатиц,\n"+
          "в кольцах аккреции черных сердец,\n"+
          "за горизонтом соитий уравнивать денствия, ныть\n"+
          "в энергетически-выгодной потенциальной низине,\n"+
          "в омуте амнезии.\n"+
          "Ты могла сделать меня цветком,\n"+ 
          "но я становлюсь раффлезией.\n"+
          
          "Память доступна на запись и чтение,\n"+
          "удаление же запрещено эпистемой,\n"+
          "смажь соком из глаз макияж, обнажи\n"+ 
          "татуаж, покажи, обратима ли\n"+
          "декогеренция побратимов?\n"+
           
          "На том берегу войда, стих\n"+
          "запутан с тобою, и, пусть\n"+
          "на какую-то часть он мертв или пуст, но на другую —\n"+
          "сил полон и Луна существует, пока на нее воет\n"+
          "солипсист-воин в электромагнитном поле.\n"+
          
          "Настройка моего приемника не очень\n"+
          "точна, но я думаю, что реальность --\n"+
          "это радиоволна\n"+
          "и, она, разумеется, не одна.\n"+
          "На всех частотах\n"+
          "миротворец Хью Эверетт (пользуюсь случаем)\n"+
          "передает привет.\n"+
           
          "Пока похоже, что это игра, --\n"+
          "шахматный шутер от первого лица,\n"+
          "в лабиринтах кроссвордов\n"+
          "зомби - фигуры (и пунктуация),\n"+
          "белый слон уже ест афро-американского короля,\n"+
          "Но, верю я, в одной из вселенных возможна ничья.\n";




int framesPerMotion = 60;
int currentLine = 0;
int endframe = 0;
    
String prep = poem.replaceAll("--", "—").replaceAll(" ", " ");
float ts = 25;

PFont f;
String[] lines;
float[] shifts;
int visiblelines;
float lineHeight = 1.62;

float pos = 100;
 

void setup() {

    lines = prep.split("\n");
    shifts = new float[lines.length];

    size(864, 1080);

    background(255);
    pixelDensity(2);
    frameRate(30);
    smooth(4);

    ts = height / 38;
    f = createFont("Literata-VariableFont_wght.ttf", ts, true);

    textFont(f, ts);
    textSize(ts);

    visiblelines = (int) ((float) height / (ts * lineHeight)) - 1;

}


void drawShadLine(String line) {
     
    float x = 0;
    for (int i = 0; i < line.length(); i++) {
        String cc = line.substring(i, i + 1);
        float w = textWidth(cc);
        int alph = 255 - i * 4;
        fill(255, alph);
        text(cc, x, 0);
        x += w;
    }
}

float drawLine(int k) {

    float x = 0;

    for (int i = 0; i < lines.length; i++) {
        String line = lines[(k + i) % lines.length].replaceAll("\n", " ");
        if (!line.endsWith(" "))
            line += " ";
        float w = textWidth(line);

        noStroke();

        pushMatrix();
        translate(x, 0);
        drawShadLine(line);

        stroke(255, 40);

        popMatrix();

        x += w;
    }

    return 0;
}

   

void draw() {
    endframe = framesPerMotion * lines.length;
    boolean snap = (frameCount % framesPerMotion) == 0;
    float motionPhase = (frameCount % framesPerMotion) / ((float) framesPerMotion);

    background(0);

    for (int i = 0; i < visiblelines; i++) {
        String ln = lines[(i + currentLine) % lines.length].replaceAll("\n", " ");

        float lw = textWidth(ln);
        if (snap) {
            shifts[i] += lw;
        }

        pushMatrix();
        float smoother = (1.0 - 0.5 * (cos(PI * motionPhase) + 1));

        float off_x = -lw * smoother - shifts[i];
        translate(ts * 4 + off_x, (i + 1.5) * ts * lineHeight);
        drawLine(i);
        popMatrix();

    }

    if (snap) {
        currentLine++;
    }

}

void mouseReleased() {
    looping = !looping;
    if (looping) {
        loop();
    } else {
        noLoop();
    }
    println(frameCount, pos, lines.length, endframe);
    saveFrame("poem__####.png");
}
