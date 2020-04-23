

class Letter {
    PVector pos, def;
    String c;

    Letter(String c) {
        this.c = c;
    }

    void animate() {
        //to override
    }

}
    
class Glyph extends Letter {
    int stillFrames = 0;
    Letter target;
    float deg = 0;

    float phase = 0;

    PVector speed = new PVector();

    Glyph(String c) {
        super(c);
    }

    void draw() {

        PVector lastpos = pos.copy();
        float lastdeg = deg;
        animate();
 

        fill(255, 20);
        blendMode(ADD);
        int SS = 12;
        for (int k = 0; k < SS; k++) {
            float subframe = (float) k / (float) SS;
            PVector v = PVector.lerp(pos, lastpos, subframe);
            pushMatrix();{

                float x = 10. * sin((float) frameCount / 50. + 5 * pos.y / width);
                float y = 20. * cos((float) frameCount / 30. + 5 * pos.x / width);
                
                translate(v.x + x, v.y + y);
                rotate(radians(lerp(deg, lastdeg, subframe)));

           
                text(c, 0, 0);
           
            }             
            popMatrix();
        }
    }

    void setNewTarget(Letter t) {
        target = t;
    }

    void animate() {

        if (target != null) {
            PVector dspeed = PVector.sub(target.pos, pos).mult(0.02);
            float dist = pos.dist(target.pos);
            if (dspeed.mag() > 20)
                dspeed.setMag(20);
           

            speed.add(dspeed);
            deg += dist;

            if (dist < 0.4) {
                stillFrames++;
            } else {
                stillFrames = 0;
            }
        } else {
            stillFrames--;
            float rnd = 1;
            speed.x += randomGaussian() * rnd;
            speed.y += randomGaussian() * rnd;
        }

        deg *= 0.75;
        speed.mult(0.72);
        pos = pos.add(speed);
 

    }

    boolean canReuse() {
        return target == null || stillFrames > minFramesStill;
    }

}
