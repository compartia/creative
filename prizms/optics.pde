static private double Gamma = 0.80;
static private double IntensityMax = 255;


float clamp(float lo, float  hi, float v){
    return max(lo, min(hi, v));
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




//=======================================
float ri_by_wl(float  waveLength, float refractive_index){
    
    //according to Cauchy’s equation n= a + (b/λ^2)
    double waveLength2 = waveLength * waveLength;
    double n = refractive_index + dispersion / waveLength2;    
    return (float)n; 
}



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
