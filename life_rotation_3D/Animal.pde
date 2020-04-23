class Animal {
    int c;
    Vec3 pos;
    Vec3 v;

    Animal(float x, float y, int clr) {
        this.v = new Vec3(random(1) - 0.5, random(1) - 0.5);
        this.pos = new Vec3(x, y);
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
