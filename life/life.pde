String path_to_save_snapshots = "/Users/artem/work/creative/life"; 

color bg = color(5, 30, 40, 120);

 
int time = 0;
float psize = 5;
float topspeed = 3;
 
static int side_x = 1080;
static int side_y = 1080;

ArrayList<Animal> animals = new ArrayList();

color[] colors = { 
    color(255, 0, 128, 100), 
    color(0, 180, 180, 100), 
    color(0, 128, 255, 100),
    color(128, 128, 255, 100), 
    color(40, 0, 200, 100), 
    color(0, 180, 40, 100), 
    color(200, 160, 0, 200),
    color(200, 0, 40, 100) 
    };



class Animal {
    int c;
    PVector pos;
    PVector v;

    Animal(float x, float y, int clr) {
        this.v = new PVector(random(1) - 0.5, random(1) - 0.5);
        this.pos = new PVector(x, y);
        this.c = clr;
    }

    void draw() {
        noStroke();
        fill(colors[this.c]);
        ellipse(pos.x, pos.y, psize, psize);
    }

    void move() {
        pos.add(v);
    }
}


void setup() {
    size(640, 640);
    side_x = width;
    side_y = height;


    background(bg);
    frameRate(60);
    smooth(2);
    pixelDensity(1);
    strokeWeight(1);


    for (int f = 0; f < 600; f++) {
        animals.add(new Animal(random(side_x), random(side_y), (int) random(colors.length)));
    }
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

void calcforces() {

    for (Animal a : animals) {

        for (Animal b : animals) {
            if (a != b) {

                PVector direction = PVector.sub(b.pos, a.pos);
                float distanceSq = direction.magSq();
                float force = (a.c - 2.5) * (b.c - 3.3) / (0.0001 + distanceSq);
                if (distanceSq < (a.c - b.c) * (a.c - b.c + 2) * psize) {
                    force = -force;
                }

                if (distanceSq < 150) {
                    force = -abs(force);
                }

                if (distanceSq > 700 * (a.c + 2)) {
                    force = -force;
                }

                direction.setMag(1).mult(force);
                a.v.add(direction);

            }
        }
        a.v.limit(topspeed);
    }

    for (Animal a : animals) {
        a.v.mult(0.99);// innertia (momentum)
        if (a.pos.x < 0)
            a.pos.x = 0;
        if (a.pos.y < 0)
            a.pos.y = 0;
        if (a.pos.x > width)
            a.pos.x = width;
        if (a.pos.y > height)
            a.pos.y = height;
    }
}

void mouseReleased() {
    saveFrame(path_to_save_snapshots+"/life_####.png");
    looping = !looping;
    if (looping) {
        loop();
    } else {
        noLoop();
    }
}
