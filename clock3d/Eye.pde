class Eye {
    PShape sun;
    PShape moon;
    PVector pos;
    PVector moonpos;
    float orbitr = 100;
    float r = -1;
    float moon_r;
    
    int mins = 60;
    int hrs = 24;
    //PShape[] moons = new PShape[mins*hrs];
    ArrayList<PVector>  positions = new ArrayList<PVector>();
    ArrayList<PShape>  moons = new ArrayList<PShape>();
    int size = 200;
    
    public Eye(PVector pos, int size) {
        r = this.size / 3;
        this.size=size;
        
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
        
        //for (int i=0; i<moons.length(); i++) {
        //  moons[i] = createShape(SPHERE, moon_r / 20);
        //}
        
        
        float small_r = size/8;
        float big_r = size/2-small_r-small_r/2;
        
        for (int h=0; h < hrs; h++){
          for (int m=0; m < mins; m++){
            float angle_h = m * (TWO_PI / mins);
            float angle_m = h * (TWO_PI / hrs);
            
            float _off = small_r * sin(angle_m);
            float z = small_r * cos(angle_m);
            
            float x = (big_r + _off) * cos(angle_h) ;
            float y = (big_r + _off) * sin(angle_h);
            
            
            PVector ppos = new PVector(x, y, z) ;
            positions.add(ppos);
            moons.add(createShape(SPHERE, size/200));
          }
        }

    }

    public void show(int frame) {
        float angle = loops * TWO_PI * (frame % (animationLen)) / (float) animationLen;
      
        //pushMatrix();{
        //  //translate(pos.x, pos.y, pos.z);
  
        //  //shape(sun);
        //  moonpos.x = orbitr * sin(angle);
        //  moonpos.z = orbitr * cos(angle);
        //  //directionalLight(255, 255, 255, moonpos.x, moonpos.y, moonpos.z);
        //  pointLight(255, 255, 255, 0, 0, 0);
  
        //  translate(moonpos.x, moonpos.y, moonpos.z);
  
        //  shape(moon);
          
        //}                
        //popMatrix();
        pointLight(255, 255, 255, 0, 0, 0);
        pointLight(100, 100, 100, size, -size, size);
        
        for (int i=0; i<moons.size(); i++) {
          pushMatrix();
          rotateX(-PI/8+PI/2 + angle/5);
          rotateZ(angle/2);
          {
            //float _angle = angle + (i * TWO_PI) / moons.size();
            //PVector _moonpos = new PVector(orbitr * sin(_angle), 0, orbitr * cos(_angle));
            PVector _moonpos = positions.get(i);
            translate(_moonpos.x, _moonpos.y, _moonpos.z);
            shape(moons.get(i));
            
          }                
          popMatrix();
        }
    }
}
