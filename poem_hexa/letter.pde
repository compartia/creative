class Letter{
  PVector pos, target, v;
  
  String c;
  float w;
  boolean infected;
  boolean locked;
  float illnesTime=0;
  Letter focus=this;
  
  float angle;
  
  Letter(String c){
    this.c=c;
    pos = new PVector();
    //target=new PVector();
    v = new PVector();
  }
  
  void updateVelocity(Letter[] letters){
    if(infected)
      illnesTime+=1;
      
    if(illnesTime>850){
      infected=false;
      locked = false;
    }
    if(this.locked)
      return;
    
    float minmag=height+width;
     
    for(Letter l:letters){
      if(l!=this ){
        PVector d = PVector.sub(l.pos, pos);
        float mag = d.mag();
        if(mag<minmag && mag > INF_D && l.focus!=this){
          minmag=mag;
          focus = l;
        }
        
        if(mag<INF_D  ){
          if(random(illnesTime+1)<0.001){
            l.infected=infected ||  l.infected;
            infected=infected ||  l.infected;
          }
        }
      }
    }
    
     
    //PURSUE FOCUS
    if(focus!=null ){
        PVector d = PVector.sub(focus.pos, pos);
        float mag = d.mag();
       
        if(mag < width/2){
            d.mult(0.07);
            if(infected){
            d.mult(1/(illnesTime+1));
            }
    
            v.add(d);
        }
    }
     
    
    
    //EACH OTHER mean stream
    for(Letter l:letters){
      if(l!=this  ){
        float d=pos.dist(l.pos);
        float k = 0.4* 1.0/(1.0+d*d);
        if (l.infected){
          k*=0.5;
        }
         v.add (l.v.copy().mult(k) );
       }
      
    }
    
    // to GRID
    if(frameCount>0){
      PVector d = PVector.sub(target, pos);
      if(d.mag()<0.1){
        this.locked=true;
      }
      d.mult(0.007);
      if(infected)
        d.mult(1.5);
      v.add(d);  
    }
    
    if(v.mag()>10){
      v.setMag(10);
    }
  }
  
  void move(){
    if(this.locked)
      return;
      
    pos.add( PVector.mult(v, 0.17));
 
    v.mult(0.89);  
  }
  
  void draw(){
    pushStyle();
    if(infected){
      fill(0);
    }else{
      fill(255);
    }
    pushMatrix();
    translate( pos.x -  w/2,  pos.y+ts/2);
    
    float angle_2 = atan2(this.v.y, this.v.x);
    angle = lerp( angle, angle_2, 0.1);
    //angle*=0.9;
    rotate(PI+angle); 
    
   
    text( c, 0,0);
    popMatrix();
    popStyle();
  }
 
  
}
