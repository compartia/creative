public class Pandemia{
  
  int recovery_time = 200;
  int asymptomatic_time = recovery_time/2;

  ArrayList<PVector> dots;
  ArrayList<PVector> attractors;
  ArrayList<PVector> tokens=new ArrayList();
  
  PVector range;
  Unit[] units;
  
  float screen_side_len; 
  
  float I_start = 0.1;//initially infected 
  
  float infection_distance = 5;
  
  public Pandemia(PVector range){
    
    this.range=range;
    dots = this.makeDots();
    
    
    this.makeUnits(dots.size());
    makeAttractors(7);
    
    screen_side_len = sqrt(range.x * range.y);
  }
  
  void makeAttractors(int amount){
    attractors=new ArrayList();
    for(int i=0; i<amount; i++){    
      PVector pos = new PVector(randomGaussian() * range.x *0.23, randomGaussian() * range.y*0.23);              
      attractors.add(pos); 
    }
  }
 
  private void makeUnits(int amount){
    units=new Unit[amount];
     
    for(int i=0; i<amount; i++){   
      Unit u = new Unit();      
      u.pos = dots.get( (i+1) % amount).copy();
      u.pos.x+=randomGaussian()*60;
      u.pos.y+=randomGaussian()*60;
      u.home =  new PVector(randomGaussian() * range.x *0.33, randomGaussian() * range.y*0.33);              
              
      units[i] = u;
    }
    
    for(int i=0; i<1+(float)amount*I_start; i++)    
      units[1].setInfected(true);
    
  }
  
  private ArrayList<PVector> makeDots(  ){
    float width = range.x;
    float height = range.y;
    
    int N=4;
    float offset =  min(width, height)/10.0;
    float dist  = min(width, height)/(float)N;
    
    float base_radius=N*dist;//(width/N)/sin(radians(60))/2;
    print(base_radius);
    float dotsX=dist;//width/dist;
    float dotsY=dist;//height/dist;
    float dx = 2*base_radius * sin(radians(60));
    float dy = base_radius/2 + 2*base_radius * cos(radians(60));
  
    float dot_dx=dx/dotsX;
    float dot_dy=dy/dotsY;
    
    //float dotsR=12;
     
    ArrayList<PVector> list = new ArrayList();
   
    
    int yc=0;
    for(float y=-height/2+offset; y< height/2-offset; y+=dot_dy){
      float o = yc%2 ==0? 0 : dot_dx/2;
      
      for(float x=-width/2+offset; x< width/2-offset; x+=dot_dx){    
         
        PVector pv = new PVector(  x+o,   y);       
        list.add(pv);
                      
      }
      yc++;
    }
    
    return list;
     
    
  }
  
  void putToken(PVector token){    
    if(tokens.size()>200){
      tokens.remove(0);
    }
    tokens.add(token);
  }
  
  void moveToAttractors(Unit u){
    //for (PVector a : this.tokens){
    //  PVector d = PVector.sub(a, u.pos);
    //  //float distance = d.mag();
                   
    //  d.mult( (10. / (0.001+d.magSq())) - 0.0002 );
    //  //d.mult(0.6/d.magSq());
    //  u.v.add(d);                
    //}
    
    
    for (PVector a : this.tokens){
      PVector d = PVector.sub(a , u.pos);
      float distanceSq = d.magSq();
      
      if(distanceSq<50*50 && distanceSq>10*10){
                   
        d.mult( (0.5 / ( distanceSq))   );
        //d.mult(0.6/d.magSq());
        u.v.add(d);     
        //return;
    
      }
    }
    
    
  }
  
  void draw(){
    pushStyle();
    noFill();
    stroke(255);
    rect(-range.x/2,-range.y/2, range.x, range.y);
      
    noStroke();
    
    
    
    for (Unit u:units){
      u.updateVelocity(units, this);    
      moveToAttractors(u);
    }
    
    
    
    for (Unit u:units){
      
      for (int al=0; al<motion_blur_steps; al++){
        u.move(1./motion_blur_steps);
        u.draw(1./motion_blur_steps, this);
      }    
      
      u.decay(this );
    }
    
    fitUnits();
    
    popStyle();
    
    //noStroke();
    //fill(255,0,0, 70);
    //for (PVector a : this.tokens){
    //  ellipse(a.x, a.y, 8,8);
    //}
   
 
  }


  private void fitUnits(){
    float side_x = range.x/2 - 9;
    float side_y = range.y/2 - 9;
    
    float refl=-1;
    
    for (Unit u:units){
      if(u.pos.x > side_x){
        u.pos.x = side_x;
        u.v.x *= refl;
      }
      
      if(u.pos.x < -side_x){
        u.pos.x =- side_x;
        u.v.x *= refl;
      }
      
      if(u.pos.y > side_y){
        u.pos.y = side_y;
        u.v.y *= refl;
      }
      
      if(u.pos.y < -side_y){
        u.pos.y = -side_y;
        u.v.y *= refl;
      }
      
          
    }
  }
}
