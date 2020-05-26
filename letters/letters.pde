 String path_to_save_snapshots = "/Users/artem/work/creative/letters"; 

 
 // settings
static String textstr = "Форма нуля в слове чучело-вечность — " + "лого собой увлеченности. " + "Форма "
        + "чело-увечности тишиной " + "тесной и кол- " + "бой со спиртом и с " + "форма- " + "лином. "
        + "Травит змея-альбинос " + "свой парафиновый хвост — " + "форма " + "браслета часовой бомбы "
        + "у пса по имени Кербер на горле, " + "у пса, приуроченного " + "к открытию коробки Пандоры. "
        + "Упс. А надежду оставили.";

color bg = color(5, 30, 40, 0);

int time = 0;

float topspeed = 3;

static int side_x = 1080;
static int side_y = 1080;

ArrayList<Animal> animals = new ArrayList();
float psize = 5;

color[] colors = { color(255, 5), color(0, 30, 35, 40), color(255, 0, 128, 5), color(10, 170, 180, 100),
        color(200, 160, 0, 20), color(200, 0, 40, 10) };

class Animal {
    int c;
    PVector pos;
    PVector v;
    char letter;
    Animal target;
    float w;
    float mass;

    Animal(float x, float y, int clr, char letter) {
        this.v = new PVector(random(1) - 0.5, random(1) - 0.5);
        this.pos = new PVector(x, y);
        this.c = clr;
        this.letter = letter;
        this.w = textWidth(letter);
        this.mass = 0.1 + random(2.0);
    }

    void draw() {
        pushMatrix();
        float angle = atan2(this.v.y, this.v.x);

        translate(pos.x, pos.y);
        rotate(PI + angle);
        noStroke();

        fill(0, 4);
        ellipse(1, 2, psize * 3 + 4, 3.0 * this.mass + 4);

        fill(colors[this.c]);
        ellipse(0, 0, psize * 3, 3.0 * this.mass);

        popMatrix();
    }

    void move() {
        pos.add(v);
    }
}

void setup() {
    textstr = textstr + textstr;
    size(640, 640);

    side_x = width;
    side_y = height;

    background(bg);
    frameRate(60);
    smooth(4);
    pixelDensity(1);
    strokeWeight(1);

    textSize(20);
    Animal prev = null;

    for (int f = textstr.length() - 1; f >= 0; f--) {
        Animal a = new Animal(width / 2 + random(side_x / 100) - side_x / 4,
                height / 2 + random(side_y / 100) - side_y / 2, (int) random(colors.length), textstr.charAt(f));

        a.target = prev;
        animals.add(a);

        prev = a;
    }
    animals.get(0).target = prev;

}

void draw() {

    time++;
    if (time == 1000)
        time = 0;
    fill(bg);
    rect(0, 0, width, height);
    noStroke();

    calcforces();

    for (Animal a : animals) {
        a.move();
        a.draw();
    }
}

PVector center = new PVector(width / 2.0, height / 4.0);
float MDIST = 6;

void calcforces() {
    // repulsion
    for (Animal a : animals) {

        for (Animal b : animals) {
            if (a != b) {
                PVector direction = PVector.sub(a.pos, b.pos);
                float distanceSq = direction.magSq();
                float force = 30 / (0.0001 + distanceSq);

                direction.setMag(2).mult(force);

                a.v.add(direction);
            }
        }

    }

    for (Animal a : animals) {
        PVector directionc = PVector.sub(a.pos, center);
        directionc.setMag(0.01);
        a.v.sub(directionc);

        Animal b = a.target;

        if (b != null) {

            PVector direction = PVector.sub(a.pos, b.pos);

            float distanceSq = direction.mag();
            float force = (a.w + 3) - 0.5 / (0.0001 + distanceSq);

            direction.setMag(1).mult(-force);

            b.v.sub(direction);

        }

    }

    for (Animal a : animals) {

        a.v.mult(1.0 / a.mass);// innertia
        if (a.pos.x < 0)
            a.pos.x = 0;
        if (a.pos.y < 0)
            a.pos.y = 0;
        if (a.pos.x > width)
            a.pos.x = width;
        if (a.pos.y > height)
            a.pos.y = height;

        a.v.limit(topspeed / 2);
    }
}

void mouseReleased() {
    saveFrame(path_to_save_snapshots+"/sample_####.png");
    looping = !looping;
    if (looping) {
        loop();
    } else {
        noLoop();
    }
}
