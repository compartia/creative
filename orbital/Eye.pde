class Eye {
    PShape sun;
    PShape moon;
    PVector pos;
    PVector moonpos;
    float orbitr = 100;
    float r = 120;
    float moon_r;

    public Eye(PVector pos) {
        moon_r = r / 3;
        orbitr = r + moon_r * 1.2;
        this.pos = pos;
        translate(pos.x, pos.y, pos.z);
        fill(255);
        noStroke();
        sun = createShape(SPHERE, r / 2);

        moonpos = new PVector(orbitr, 0, 0);

        fill(255);

        moon = createShape(SPHERE, moon_r / 2);

    }

    public void show(int frame) {
        float angle = loops * TWO_PI * (frame % (animationLen)) / (float) animationLen;

        pushMatrix();
        translate(pos.x, pos.y, pos.z);

        shape(sun);
        moonpos.x = orbitr * sin(angle);
        moonpos.z = orbitr * cos(angle);
        directionalLight(255, 255, 255, moonpos.x, moonpos.y, moonpos.z);

        translate(moonpos.x, moonpos.y, moonpos.z);

        shape(moon);

        popMatrix();
    }
}
