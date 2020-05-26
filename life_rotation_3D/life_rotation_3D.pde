boolean fillStar = false;
boolean drawHex = false;
boolean drawBoxSides = false;

static int side = 640;

color base_color = color(170, 50, 230);
color bg = color(5, 30, 40, 120);

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

static int side_x = 640;
static int side_y = 640;

ArrayList<Animal> animals = new ArrayList();
ArrayList<Vec3> dots = new ArrayList();

color[] colors = { color(255, 0, 128, 100), color(0, 180, 180, 100), color(0, 128, 255, 100),
        color(128, 128, 255, 100), color(40, 0, 200, 100), color(0, 180, 40, 100), color(200, 160, 0, 200),
        color(200, 0, 40, 100) };

float psize = 5;


// --
void setup() {
    size(640, 640);
    side_x = width;
    side_y = height;

    background(bg);
    frameRate(60);
    smooth(2);
    pixelDensity(1);
    strokeWeight(1);

    setupcubes();
    for (int f = 0; f < dots.size(); f++) {
        animals.add(new Animal(random(side_x), random(side_y), (int) random(colors.length)));
    }
}

void setupcubes() {

    int l1 = 5;
    int lh1 = 6;

    int l2 = 3;
    

    create_cube(l1, l1, lh1, 0, 0, 0);
    create_cube(l2, l2, 6, 0, lh1, 0);
    create_cube(1, 1, 6, 0, 12, 0);

    create_cube(l1, l1, lh1, -90, 0, 0);
    create_cube(l2, l2, 6, -90, lh1, 0);
    create_cube(1, 1, 6, -90, 12, 0);

    create_cube(l1, l1, lh1, 90, 0, 0);
    create_cube(l2, l2, 6, 90, lh1, 0);
    create_cube(1, 1, 6, 90, 12, 0);

    create_cube(l1, l1, lh1, 180, 0, 0);
    create_cube(l2, l2, 6, 180, lh1, 0);
    create_cube(1, 1, 6, 180, 12, 0);

    create_cube(l1, l1, lh1, 180, 0, 90);
    create_cube(l2, l2, 6, 180, lh1, 90);
    create_cube(1, 1, 6, 180, 12, 90);

    create_cube(l1, l1, lh1, 180, 0, -90);
    create_cube(l2, l2, 6, 180, lh1, -90);
    create_cube(1, 1, 6, 180, 12, -90);

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

    for (Vec3 d : dots) {
        d.rotateX(2.0 * PI / (200));
        d.rotateY(2.0 * PI / (300));
        d.rotateZ(4.0 * PI / (600));
    }

    for (int i = 0; i < dots.size(); i++) {
        PVector mid = new PVector(width / 2, height / 2);
        mid.add(dots.get(i));
        animals.get(i).pos.lerp(mid, 0.01);
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
        a.v.mult(0.99);// innertia
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

boolean exists(Vec3 p) {
    for (Vec3 dd : dots) {
        if (dd.nearlySame(p))
            return true;
    }
    return false;
}

void create_cube(int w, int h, int d, int rot, int offset_z, int rot2) {
    int mul = 30;
    for (int x = 0; x < w; x++) {
        for (int y = 0; y < h; y++) {
            for (int z = 0; z < d; z++) {
               
                Vec3 p = new Vec3((x - w / 2) * mul, (y - h / 2) * mul, (z) * mul + offset_z * mul);

                p.rotateX(radians(rot2));
                p.rotateY(radians(45 + rot));               
                p.rotateX(radians(145));

               
                if (!exists(p))
                    dots.add(p);
               
            }
        }
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
    saveFrame("life__####.png");
}
