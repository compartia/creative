 PFont mono; //<>//
float font_size = 19;
int DY = (int) (font_size * 1.4);// (int)(font_size * 2);

// Wavelength (nm) 656.45377[2] 486.13615[3] 434.0462[3] 410.174[4] 397.0072[4]
// 388.9049[4] 383.5384[4] 364.6

// Balmer series
// float[] hydrogen_visible = { 656.45377, 486.13615, 434.0462, 410.174,
// 397.0072, 388.9049, 383.5384 };
float[] hydrogen_visible = { 656.45377, 486.13615, 434.0462, 410.174 };// , 388.9049, 383.5384 };

float getRandomWaveLen() {
    float balmer = hydrogen_visible[(int) random(hydrogen_visible.length)];

    return (balmer + random(0.5) - 0.25) * (1e-3);
}

int fps = 30;
int animationLen = 40 * fps;
int framesToSave = animationLen;

double spectrum_start = 390e-3; // (micrometers)
double spectrum_end = 700e-3;

String txt = "тихо-тихо\n" + "ползет\n" + "улитка\n" + "по склону\n" + "пирамиды Маслоу";

PVector[] coords;
PVector[] targetCoords;

float anim = 0;

float xOffset = 0;

void setup() {

    txt = txt.toUpperCase();
    size(540, 540);
    background(0, 0, 100);
    frameRate(30);
    smooth(4);
    pixelDensity(2); // retina
    background(0);

    String fn = "Roboto-Medium.ttf";

    mono = createFont(fn, font_size);
    textFont(mono);

    targetCoords = calcTargetCoords();
    makeData();
}

void makeData() {
    int len = txt.length();
    coords = new PVector[txt.length()];
    for (int f = 0; f < len; f++) {

        coords[f] = new PVector(random(width / 40) - width / 80 + targetCoords[(f + (int) random(5)) % len].x,
                targetCoords[f].y);
    }
}

PVector[] calcTargetCoords() {
    PVector[] lcoords = new PVector[txt.length()];

    float tPosX = 0;
    float tPosY = 0;

    for (int f = 0; f < txt.length(); f++) {
        char lc = txt.charAt(f);
        float letterW = 1.2 * textWidth("" + lc);

        if (lc == '\n') {
            tPosX = sin(f) * 70;
            tPosY += DY;
        }

        lcoords[f] = new PVector(tPosX, tPosY);

        tPosX += letterW;

    }

    return lcoords;

}

void draw() {

    anim += 4 * PI / animationLen;
    if (random(1) < 0.01) {
        background(random(255));

    } else {

        fill(0, 0, 50, 80);
        rect(0, 0, width, height);

    }

    blendMode(BLEND);
    fill(255);

    pushMatrix();
    renderText(frameCount - 200);

    popMatrix();

    noFill();
    strokeWeight(5);
    stroke(0, 0, 50);
    blendMode(BLEND);
    rect(0, 0, width, height);

}

class Side {
    public PVector r0;
    public PVector r1;

    public Side(PVector p1, PVector p2) {
        this.r0 = p1.copy();
        this.r1 = p2.copy();
    }

    public PVector dir() {
        return PVector.sub(this.r1, this.r0);
    }

    PVector intersect(PVector line2A, PVector line2B) {
        PVector inter = intersection(this.r0, this.r1, line2A, line2B);
        if (inter == null) {
            inter = intersection(this.r1, this.r0, line2A, line2B);
        }

        if (inter == null) {
            inter = intersection(this.r0, this.r1, line2B, line2A);
        }
        return inter;
    }

}

PVector intersection(PVector line1A, PVector line1B, PVector line2A, PVector line2B) {
    PVector sub = PVector.sub(line1B, line1A);
    float a = sub.y / sub.x;
    float b = line1A.y - a * line1A.x;

    PVector sub1 = PVector.sub(line2B, line2A);
    float a1 = sub1.y / sub1.x;
    float b1 = line2A.y - a1 * line2A.x;

    float x = (b1 - b) / (a - a1);
    float y = a * x + b;

    if ((x > min(line1A.x, line1B.x)) && (x < max(line1A.x, line1B.x)) && (y > min(line1A.y, line1B.y))
            && (y < max(line1A.y, line1B.y)) && (x > min(line2A.x, line2B.x)) && (x < max(line2A.x, line2B.x))
            && (y > min(line2A.y, line2B.y)) && (y < max(line2A.y, line2B.y))) {
        return new PVector(x, y);
    }

    return null;
}

ArrayList<Side> listEdges(PShape prism, ArrayList<Side> into, PVector pos, float rot) {

    for (int i = 0; i < prism.getVertexCount() - 1; i++) {
        PVector v1 = prism.getVertex(i).rotate(rot).add(pos);
        PVector v2 = prism.getVertex(i + 1).rotate(rot).add(pos);

        into.add(new Side(v1, v2));

    }

    if (prism.getVertexCount() >= 3) {
        PVector v1 = prism.getVertex(prism.getVertexCount() - 1).rotate(rot).add(pos);
        PVector v2 = prism.getVertex(0).rotate(rot).add(pos);
        into.add(new Side(v1, v2));
    }

    return into;
}

float rotrot = -radians(90);

void renderText(int fc) {

    ArrayList<Side> sides = new ArrayList();

    pushMatrix();
    translate(200, 350);
    rotate(rotrot);
    scale(0.8);

    int len = txt.length();

    for (int f = 0; f < len; f++) {

        int phase = (fc + (len - f)) % animationLen;
        float phasep = 6 * (float) phase / (float) animationLen;

        phasep = (sin(phasep * 5) + 1.6) / 2;

        PVector tPos = targetCoords[f];

        char lc = txt.charAt(f % len);

        float lx = tPos.x;
        float ly = tPos.y;

        float blend = phasep;
        blend = sqrt(blend);
        if (blend > 1)
            blend = 1;

        lx = lerp(coords[f].x, tPos.x, blend);
        ly = lerp(coords[f].y, tPos.y, blend);

        {
            float rot = 0;
            if (blend < 0.98) {
                float wavelen = getRandomWaveLen();
                fill(waveLengthToRGB(wavelen * 1e3), blend * 255);
            } else {
                fill(255, blend * 255);
            }

            drawLetter(lc, lx, ly, 1, rot);

            PShape s = mono.getShape(lc);

            if (s != null)
                listEdges(s, sides, new PVector(lx, ly), rot);
        }

    }

    drawRays(sides, 400, anim / 2);
    drawRays(sides, 200, anim - PI / 2);
    drawRays(sides, 200, anim * 0.43 + PI);

    blendMode(BLEND);
    popMatrix();

}

static float c = 1; // speed of light = 1, for normalization

void drawSpace(float xx, float time0, float rad, float speed) {
    beginShape();
    {
        // velocity relative to speed of light
        for (float a = 0; a < PI * 2; a += PI / 4) {
            float x = xx + rad * sin(a);
            float time = time0 + rad * cos(a);
            PVector r = lorentz(x, time, 0);
            vertex(r.x, r.y);
        }

        noStroke();
    }
    endShape();

}

void drawLetter(char l, float x, float y, float speed, float rotation) {

    pushMatrix();
    {
        translate(x, y);
        rotate(rotation);
        translate(-x, -y);

        PVector r = lorentz(x, y, speed);

        text(l, r.x, r.y);

    }
    popMatrix();
}

void drawShape(PShape shape, float xx, float yy, float speed, float rotation) {
    pushMatrix();

    translate(xx, yy);
    rotate(rotation);
    translate(-xx, -yy);

    beginShape();
    {
        for (int i = 0; i < shape.getVertexCount(); i++) {
            PVector v = shape.getVertex(i);
            PVector r = lorentz(xx + v.x, yy + v.y, speed);
            vertex(r.x, r.y);
        }
    }

    endShape();

    noStroke();

    popMatrix();

    fill(0, 200, 0);
    PVector r = lorentz(xx, yy, 0);
    ellipse(r.x, r.y, 20, 20);
    shape(shape, 200, 200);
}

void mouseReleased() {
    println(frameCount + " ");
    saveFrame("opart__####.png");
}

void drawRays(ArrayList<Side> sides, int totalRays, float anim) {
    int strokeAlpha = (int) (8. * 255. / (float) totalRays);

    blendMode(ADD);

    // ------------------

    for (int i = 0; i < totalRays; i++) {

        float xxx = random(i) / 50.0;
        PVector r0 = new PVector(-500, -250 + xxx + width / 2 + sin(anim * 0.53) * width / 2.2);
        PVector r1 = new PVector(0, 1.1);
        r1.rotate(rotrot);
        r1.setMag(height * 2);
        r1.add(r0);

        float wavelen = getRandomWaveLen();

        ArrayList<PVector> points = new ArrayList();
        points.add(r0);

        for (int s = 0; s < 12; s++) {
            Side side = getClosestIntersect(r0, r1, sides);
            if (side != null) {

                PVector[] r = refractWith(r0, r1, side, wavelen);
                r0 = r[0];
                r1 = r[1];
                points.add(r[0]);

            }
        }
        points.add(r1);

        strokeWeight(2);
        noFill();

        stroke(waveLengthToRGB(wavelen * 1e3), strokeAlpha);
        beginShape();
        {
            for (PVector p : points) {
                vertex(p.x, p.y);
            }
        }
        endShape();
    }

}
