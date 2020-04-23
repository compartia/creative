class Letter {
    PVector pos, target, v;

    String c;
    float w;
    boolean infected;
    boolean locked;
    float illnesTime = 0, pathlen;
    Letter focus = this;

    float angle;

    Letter(String c) {
        this.c = c;
        pos = new PVector();

        v = new PVector();
    }

    void updateVelocity(Letter[] letters) {
        if (infected)
            illnesTime += 1;

        if (illnesTime > 850) {
            infected = false;
            locked = false;
            illnesTime = 0;
        }
        if (this.locked)
            return;

        float minmag = height + width;

        for (Letter l : letters) {
            if (l != this) {
                PVector d = PVector.sub(l.pos, pos);
                float mag = d.mag();
                if (mag < minmag && mag > INF_D && l.focus != this) {
                    minmag = mag;
                    focus = l;
                }

                if (mag < INF_D) {
                    if (random(1) < 0.003) {
                        l.infected = infected || l.infected;
                        infected = infected || l.infected;
                    }
                }
            }
        }

        // PURSUE FOCUS
        if (focus != null) {
            PVector d = PVector.sub(focus.pos, pos);
            float mag = d.mag();
            // if(!infected){
            if (mag < width / 2) {
                d.mult(0.07);
                if (infected) {
                    d.mult(1 / (illnesTime + 1));
                }
                if (mag < 1.3 * INF_D)
                    d.mult(0.1);
                v.add(d);
            }
        }

        // EACH OTHER mean stream
        for (Letter l : letters) {
            if (l != this) {
                float d = pos.dist(l.pos);
                float k = 0.9 * 1.0 / (1.0 + d * d);
                if (l.infected) {
                    k *= 0.6;
                }

                v.add(l.v.copy().mult(k));
            }

        }

        // to GRID
        if (frameCount > 0) {
            PVector d = PVector.sub(target, pos);
            if (d.mag() < 0.1) {
                this.locked = true;
            }
            d.mult(0.007);
            if (infected)
                d.mult(1.5);
            v.add(d);
        }

        if (v.mag() > 10) {
            v.setMag(10);
        }
    }

    void move(float al) {
        if (this.locked)
            return;

        PVector addon = PVector.mult(v, 0.32 * al);
        pos.add(addon);
        pathlen += addon.mag();

    }

    void decay() {
        v.mult(0.95); // innertia
    }

    void draw(float al) {
        int phase = (int) (128. * (sin(pathlen / 5.) + 1));
        int phase2 = (int) (128. * (sin(pathlen / 17.) + 1));
        pushStyle();
        if (!infected) {
            fill(phase / 3, phase2, 255 - phase, al * 255);
        } else {
            fill(128 + phase / 2, al * 255);
        }
        pushMatrix();
        translate(pos.x, pos.y);

        float angle_2 = atan2(this.v.y, this.v.x);
        angle = lerp(angle, angle_2, 0.1);

        rotate(PI + angle);

        text(c, -w / 2, +ts / 2);
        popMatrix();
        popStyle();
    }

}
