
static float c = 299792458; //ms
int totalRays = 25; // 250 is better, but slow

//Chromatic dispersion

//Hard crown glass K5  1.5220  0.00459
//Dense flint glass SF10  1.7280  0.01342
float refractive_index = 1.5220;
double dispersion = 0.00459e2; //(μm2)

// visible spectrum  380 to 740 nanometers
double spectrum_start = 390e-3; //(micrometers)
double spectrum_end = 700e-3;
double delta_spectrum = (spectrum_end - spectrum_start) / (double)totalRays;

int strokeAlpha = (int)(8. * 255. / (float)totalRays);

void setup() {
    size(640, 640);
    pixelDensity(2);//retina
    strokeWeight(2);    
    frameRate(30);    
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




void draw() {

    background(0);
    blendMode(ADD);    
    stroke(255);


    float kkk = ((frameCount % 500) / 500.0);
    float kkk2 = ((frameCount % 200) / 200.0);
    float phase = (sin(2 * kkk * PI) + 1.0) / 2.0;
    float phase2 = (sin(2 * kkk2 * PI) + 1.0) / 2.0;


    PVector[] prism = makePrism(width / 6, new PVector(width / 2 - width / 6, height / 2), PI / 3 + lerp(PI - PI, PI + PI, phase));
    PVector[] prism2 = makePrism(width / 6, new PVector(width / 2 + width / 6, height / 2), lerp(-PI / 10, PI / 10, phase2));


    Side[] sides = new Side[6];
    sides[0] = new Side(prism[0], prism[1]);
    sides[1] = new Side(prism[1], prism[2]);
    sides[2] = new Side(prism[2], prism[0]);

    sides[3] = new Side(prism2[0], prism2[1]);
    sides[4] = new Side(prism2[1], prism2[2]);
    sides[5] = new Side(prism2[2], prism2[0]);


    renderPrism(prism);
    renderPrism(prism2);

    //------------------


    float offset = height / (200. * (float)totalRays);
    float offsetY = height / 2. - ((float)totalRays * offset) /2;

    for (int i = 0; i < totalRays; i++) {
        int k = (int)random(totalRays);

        float y0 = offsetY + k * offset + 20;
        PVector r0 = new PVector(0, y0);
        PVector r1 = new PVector(width, y0 - 190);

        float wavelen = (float)(spectrum_start + k * delta_spectrum);

        ArrayList < PVector > points = new ArrayList();
        points.add(r0);
        boolean incoming = true;
        for (int s = 0; s < sides.length; s++) {
            Side side = getClosestIntersect(r0, r1, sides);
            if (side != null) {

                PVector[] r = refractWith(incoming, r0, r1, side, wavelen);
                r0 = r[0];
                r1 = r[1];
                points.add(r[0]);
                incoming = !incoming;
            } else {                 
                //no intersection
            }
        }
        points.add(r1);


        strokeWeight(2);
        noFill();
        int[] clr = waveLengthToRGB(wavelen * 1e3);
        stroke(clr[0], clr[1], clr[2], strokeAlpha);
        beginShape();
        {
            for (PVector p : points) {
                vertex(p.x, p.y);
            }
        }
        endShape();
    }


}


 
PVector[] makePrism(int size, PVector center, float rot){

    PVector[] ret = new PVector[3];

    for (int i = 0; i < 3; i++) {
        float a = rot + i * (2 * PI) / 3;
        ret[i] = new PVector(size * sin(a), size * cos(a));
    }

    for (PVector p: ret) {
        p.add(center);
    }

    return ret;
}



void renderPrism(PVector[] points){
    strokeWeight(3);
    stroke(255);
    fill(255, 30);
    beginShape();
    for (PVector p: points) {
        vertex(p.x, p.y);
    }
    endShape(CLOSE);
}
 

void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative/prizms/pink_floyd__####.png");
}
