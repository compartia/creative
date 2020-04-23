//settings
static String textstr="Тошное равенство сегодня и завтра "+
                      "выветрен смысл пространства "+
                      "площади шаркают — шёпот хоронит "+
                      "под камнем остывшее мыло оперы "+
                      "скользкое зеркало лужи надвое "+
                      "режет велосипеда шина, туча "+
                      "пляжное полотенце выкручивает "+
                      "мысли прячутся жалкие беженцы "+
                      "берега линия не может тоже "+
                      "найти себе места под ветром "+
                      "Приведи, Мефистофель, Елену. Мне "+
                      "Срочно необходимо влюбиться. Две "+
                      "единицы создают между ними напряжение поля "+
                      "ржи население стрекочет сплетнями "+
                      "ловят сами себя отпевают птицы "+
                      "искажают метео- информацию. "+
                      "Нужно срочно влюбиться. Мефисто, "+
                      "приведи Гретхен мне, плиз, "+
                      "хотя бы на время, рыхлое "+
                      "дешевое время, иначе нет смысла. "+
                      "Нет. "+
                      "Все же — Елену.";



boolean fillStar = false;
boolean drawHex = false;
boolean drawBoxSides = false;

static int side = 640 * 2;

color base_color = color(170, 50, 230);
color bg = color(5, 30, 40, 1);

int N = 5;
float base_radius = (side / N) / sin(radians(60)) / 2;

float dx = 2 * base_radius * sin(radians(60));
float dy = base_radius / 2 + 2 * base_radius * cos(radians(60));

int time = 0;
float dotsD = 12;
float dotsR = 12;

float topspeed = 3;

float dot_dx = dx / dotsD;
float dot_dy = dy / dotsD;

static int side_x = 1080;
static int side_y = 1080;

ArrayList<Animal> animals = new ArrayList();
int al = 40;
color[] colors = { color(255, al), color(220, 160, 0, al), color(200, 20, 128, al), color(10, 190, 180, al),
        color(240, 80, 200, al), color(200, 180, 40, al) };
float psize = 5;

// --
PVector center = new PVector(640, 640);
int added_letters = 0;

void setup() {
    size(1080, 1080);
    side_x = width;
    side_y = height;

    background(0);
    frameRate(90);
    smooth(4);
    pixelDensity(1);
    strokeWeight(1);
    textSize(20);
    Animal prev = null;

    float spread = 200;
    for (int f = 0; f < 3; f++) {
        add_letter();
    }

}

void add_letter() {
    Animal a = new Animal(side_x / 2 + random(side_x / 20) - side_x / 10,
            side_y / 2 + random(side_y / 20) - side_y / 10, (int) random(colors.length),
            textstr.charAt(animals.size()));

    if (animals.size() > 0) {
        a.target = animals.get(0);
        animals.get(animals.size() - 1).target = a;
    }

    animals.add(a);
}

class Animal {
    int c;
    PVector pos;
    PVector v;
    char letter;
    Animal target, child;
    float w;
    float mass;

    Animal(float x, float y, int clr, char letter) {
        this.v = new PVector(random(1) - 0.5, random(1) - 0.5);
        this.pos = new PVector(x, y);
        this.c = clr;
        this.letter = letter;
        this.w = textWidth(letter) + 3;
        print(this.w);
        this.mass = 0.1 + random(2.0);
    }

    void setTarget(Animal t) {
        if (this.target != null) {
            this.target.child = null;
        }
        this.target = t;
        if (t != null) {
            if (t.child != null)
                t.child.target = null; // unlink old child
            t.child = this;
        }
    }

    void draw(boolean shad) {
        pushMatrix();
        float angle = 0;
        if (target != null) {
            PVector direction = PVector.sub(pos, target.pos);
            angle = atan2(direction.y, direction.x);
        }

        translate(pos.x, pos.y);
        rotate(PI + angle);

        if (shad) {
            noStroke();
            fill(0, 2, 100, al / 5);
            ellipse(w / 2, -5, w * 1.2, w * 1.2);
        }

        else {
            noStroke();
            fill(colors[this.c]);
            text(this.letter, 0, 0);
        }

        popMatrix();

    }

    void move() {
        pos.add(v);
    }
}

void draw() {
    if (frameCount % 5 == 0 && animals.size() < textstr.length()) {
        add_letter();
    }

    noStroke();

    calcforces();

    for (Animal a : animals) {
        a.draw(true);
    }

    for (Animal a : animals) {
        a.move();
        a.draw(false);
    }

}

float MDIST = 20;

void calcforces() {

    // repulsion
    for (Animal a : animals) {

        for (Animal b : animals) {
            if (a != b) {
                PVector direction = PVector.sub(a.pos, b.pos);
                float distanceSq = direction.magSq();
                float force = (a.w / 5) / (0.001 + distanceSq);

                direction.setMag(1).mult(force);
                a.v.add(direction);
                b.v.sub(direction);

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

            float distanceSq = direction.magSq();

            float dis = a.w;
            dis *= dis;

            float force = -dis + distanceSq;

            direction.setMag(0.01).mult(-force);

            b.v.sub(direction.mult(2));
            a.v.add(direction.mult(0.5));

        }          

    }

    for (Animal a : animals) {

        a.v.mult(0.99);// momentum
        if (a.pos.x < 0)
            a.pos.x = 0;
        if (a.pos.y < 0)
            a.pos.y = 0;
        if (a.pos.x > width)
            a.pos.x = width;
        if (a.pos.y > height)
            a.pos.y = height;

        a.v.limit(topspeed / 4);
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
    saveFrame("letters__####.png");
}
