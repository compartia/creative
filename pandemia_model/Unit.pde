class MovingObject{
  PVector pos, v, home;
  boolean locked;
  float pathlen;
  //float angle;
}

float repulsion_k=0.2;

class Unit extends MovingObject{
   
  float size=1.5;
  
  float immune_power; //gaussain 0..1 and 1 is more probable; green channel
  
 
  //float infected_cells=0;
  boolean infected=false;
  boolean recovered=false;
  
  int infected_time=0;
  int time=0;
  
  void setInfected(boolean i){
    this.infected=i;
  }
  
  Unit( ){    
    immune_power = abs(randomGaussian());
    pos = new PVector();
    v = new PVector();
    time=1+(int)random(130);
  }
  
  
  void updateImmune(Pandemia model){
    
    if (infected){
      infected_time++;
    }
    
    if (infected_time > model.recovery_time){
      infected = false;  
      recovered = true;
    }
    
    
    
  }
  
  boolean isInfected(){
    return this.infected;
  }
  
  void updateVelocity(Unit[] all, Pandemia model){
    
    
    updateImmune(model);
    

    for(Unit other : all){
      if(other != this  ){
        PVector d = PVector.sub(other.pos, pos);
        float distanceSq = d.magSq();
       
        
        if (other.isInfected() && !this.recovered){
          float infection_probabilty = 0.7/(0.1 + distanceSq);
          if(random(model.infection_distance) < infection_probabilty)
            this.setInfected(true);      
          //if
          //if(distance < model.infection_distance  ){
          //  this.setInfected(!recovered);           
          //}
        }
        
        
        //mutual repulsion
        if(distanceSq < size*size*18){
          d.mult(0.09*repulsion_k / (0.001+distanceSq));
          v.sub(d);
          other.v.add(d);
        }
         
      }
    }
    
     
    
    //EACH OTHER mean stream; Frame dragging
    for(Unit l:all){
      if(l!=this  ){
        float d = pos.dist(l.pos);
        
        if (d<model.range.x/8){
        
           float k = 2.9 * 1.0/(1.0+d*d*d);     
           v.add (l.v.copy().mult(k) );
         }
       }
      
    }
    
    // to GRID     
    PVector d = PVector.sub(home, pos);
    //if(d.mag()<1){
    //  this.locked=true;
    //}else{
    //  this.locked=false;
    //}
    d.mult(0.0007);
    //if(infected())
    //  d.mult(1.5);
    v.add(d);  
    
    
    if(v.mag()>10){
      v.setMag(10);
    }
  }
  
  void move(float al){
    float max_speed=0.6*size;
    //if(!isAlive() )
    //  return;
    float dempfer=1;
    //if(this.locked)
    //  dempfer=0.1;
    
    PVector addon = v.copy();//.setMag(1);
    addon.mult(0.2*(immune_power+0.1) * al * dempfer);
    //float step_len = addon.mag();
    //if(step_len>max_speed){
    //  step_len=max_speed;
    //  addon.setMag(step_len);
    //}
    pos.add( addon);
    pathlen += addon.mag();
    //if(infected){
    //  v.mult(0.85); //innertia
    //}else
   
  }
  
  boolean isAlive(){
    return immune_power>0.1;
  }
  
  void decay(Pandemia model){
    if(isInfected())
      v.mult(0.7);
     v.mult(0.970883); //innertia
          
          
    //if( this.time % 100 == 1){
    //  model.putToken(pos);
    //}
    //this.time++;
    
    //if(((int)pathlen) % 106 == 1)
      if(random(1)<0.001)
        model.putToken(pos.copy());
  }
  
  void draw(float al, Pandemia model){
    float g = isInfected()? 12: 180 + v.y*10; //immune_power*255;
    float r = 20 + 240*((float)infected_time/(float)model.recovery_time);// isInfected() ;
    r*=0.01+(sin(pathlen/100.)+1)*0.4;
    float b =15 * v.mag() + v.x*20;
    pushStyle();
    fill(r, g, b, al*170);
    pushMatrix();
    translate( pos.x ,  pos.y);
    
    noStroke();
    ellipse( 0,0, size, size);
    popMatrix();
    popStyle();
  }
 
  
}
