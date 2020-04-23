Side getClosestIntersect(PVector l1, PVector l2,  ArrayList<Side> sides){
    Side best = null;
    float eps = 0.02;
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


float clamp(float lo, float hi, float v) {
        return max(lo, min(hi, v));
    }

    float refractive_index = 1.5220;
    double dispersion = 0.0959e2; // (μm2)

    PVector refract(PVector I, PVector N, float ior) {
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

    // =======================================
    float ri_by_wl(float waveLength, float refractive_index) {

        // according to Cauchy’s equation n= a + (b/λ^2)
        double waveLength2 = waveLength * waveLength;
        double n = refractive_index + dispersion / waveLength2;
        return (float) n;
    }

    PVector[] refractWith(PVector _r0, PVector _r1, Side wall, float waveLength) {

        PVector hit = wall.intersect(_r0, _r1);

        PVector ray_dir = PVector.sub(_r1, _r0);
        PVector wall_dir = wall.dir().rotate(PI / 2);

        float ior = ri_by_wl(waveLength, (float) refractive_index);
        PVector refracted = refract(ray_dir, wall_dir, ior);
        refracted.setMag(width * 2.5);
        refracted.add(hit);

        PVector[] ret = new PVector[2];
        ret[0] = hit;
        ret[1] = refracted;

        return ret;
    }
