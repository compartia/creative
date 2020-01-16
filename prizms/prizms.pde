
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

Side getClosestIntersect(PVector l1, PVector l2, Side[] sides){
    Side best = null;
    float eps = 1;
    float bestdist = -1;
    for (Side side : sides) {
        PVector i = side.intersect(l1, l2);
        if (i != null) {
            float dist = i.dist(l1);
            if (dist > eps) {
                if (best == null) {
                    best = side;
                    bestdist = dist;
                } else {
                    if (dist < bestdist) {
                        best = side;
                        bestdist = dist;
                    }
                }
            }
        }
    }

    return best;
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

float clamp(float lo, float  hi, float v){
    return max(lo, min(hi, v));
}

PVector refract(PVector I, PVector N, float ior)
{
    PVector ii = I.copy();
    float cosi = clamp(-1, 1, I.dot(N));
    float etai = 1, etat = ior;
    PVector n = N.copy();
    if (cosi < 0) {
        cosi = -cosi;
    } else {
        float tmp = etai;
        etai = etat;
        etat = tmp;
        n.mult(-1);
    }
    float eta = etai / etat;
    float k = 1 - eta * eta * (1 - cosi * cosi);
    float w = eta * cosi - sqrt(k);
    return k < 0 ? new PVector() : ii.mult(eta).add(n.mult(w));
}

PVector[] refractWith(boolean incoming, PVector _r0, PVector _r1, Side wall, float waveLength){

    PVector hit = wall.intersect(_r0, _r1);

    PVector ray_dir = PVector.sub(_r1, _r0);
    PVector wall_dir = wall.dir().rotate(PI / 2);

    float ior = ri_by_wl(waveLength, (float)refractive_index);
    PVector refracted = refract(ray_dir, wall_dir, ior);
    refracted.setMag(width);
    refracted.add(hit);

    PVector[] ret = new PVector[2];
    ret[0] = hit;
    ret[1] = refracted;

    return ret;
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
 

PVector intersection(PVector line1A, PVector line1B, PVector line2A, PVector line2B){
    PVector sub = PVector.sub(line1B, line1A);
    float a = sub.y / sub.x;
    float b = line1A.y - a * line1A.x;


    PVector sub1 = PVector.sub(line2B, line2A);
    float a1 = sub1.y / sub1.x;
    float b1 = line2A.y - a1 * line2A.x;

    float x = (b1 - b) / (a - a1);
    float y = a * x + b;

    if ((x > min(line1A.x, line1B.x)) && (x < max(line1A.x, line1B.x)) && (y > min(line1A.y, line1B.y)) && (y < max(line1A.y, line1B.y))
        && (x > min(line2A.x, line2B.x)) && (x < max(line2A.x, line2B.x)) && (y > min(line2A.y, line2B.y)) && (y < max(line2A.y, line2B.y))) {
        return new PVector(x, y);
    }
    
    return null;
}





//=======================================
float ri_by_wl(float  waveLength, float refractive_index){
    
    //according to Cauchy’s equation n= a + (b/λ^2)
    double waveLength2 = waveLength * waveLength;
    double n = refractive_index + dispersion / waveLength2;    
    return (float)n; 
}


static private double Gamma = 0.80;
static private double IntensityMax = 255;

/** Taken from Earl F. Glynn's web page:
* <a href="http://www.efg2.com/Lab/ScienceAndEngineering/Spectra.htm">Spectra Lab Report</a>
* */
public static int[] waveLengthToRGB(double Wavelength){
    double factor;
    double Red, Green, Blue;

    if ((Wavelength >= 380) && (Wavelength < 440)) {
        Red = -(Wavelength - 440) / (440 - 380);
        Green = 0.0;
        Blue = 1.0;
    } else if ((Wavelength >= 440) && (Wavelength < 490)) {
        Red = 0.0;
        Green = (Wavelength - 440) / (490 - 440);
        Blue = 1.0;
    } else if ((Wavelength >= 490) && (Wavelength < 510)) {
        Red = 0.0;
        Green = 1.0;
        Blue = -(Wavelength - 510) / (510 - 490);
    } else if ((Wavelength >= 510) && (Wavelength < 580)) {
        Red = (Wavelength - 510) / (580 - 510);
        Green = 1.0;
        Blue = 0.0;
    } else if ((Wavelength >= 580) && (Wavelength < 645)) {
        Red = 1.0;
        Green = -(Wavelength - 645) / (645 - 580);
        Blue = 0.0;
    } else if ((Wavelength >= 645) && (Wavelength < 781)) {
        Red = 1.0;
        Green = 0.0;
        Blue = 0.0;
    } else {
        Red = 0.0;
        Green = 0.0;
        Blue = 0.0;
    };

    // Let the intensity fall off near the vision limits

    if ((Wavelength >= 380) && (Wavelength < 420)) {
        factor = 0.3 + 0.7 * (Wavelength - 380) / (420 - 380);
    } else if ((Wavelength >= 420) && (Wavelength < 701)) {
        factor = 1.0;
    } else if ((Wavelength >= 701) && (Wavelength < 781)) {
        factor = 0.3 + 0.7 * (780 - Wavelength) / (780 - 700);
    } else {
        factor = 0.0;
    };


    int[] rgb = new int[3];

    // Don't want 0^x = 1 for x <> 0
    rgb[0] = Red == 0.0 ? 0 : (int) Math.round(IntensityMax * Math.pow(Red * factor, Gamma));
    rgb[1] = Green == 0.0 ? 0 : (int) Math.round(IntensityMax * Math.pow(Green * factor, Gamma));
    rgb[2] = Blue == 0.0 ? 0 : (int) Math.round(IntensityMax * Math.pow(Blue * factor, Gamma));

    return rgb;
}
