class Dot{

  PVector speed;
  PVector pos;
  
  public Dot(float theta){
    this.pos = new PVector();
    this.speed = new PVector(4.0*sin(theta), 4.0*cos(theta));
  }

  void move(){
    this.pos.add(speed);
    if (pos.x > width)
      pos.x-=width;
      
    else if (pos.x < 0)
      pos.x += width;
      
    if (pos.y > height)
      pos.y -= height;
    else if (pos.y < 0)
      pos.y += height;
  }
  
  void draw (PGraphics g, float r){
   
     
    g.ellipse( pos.x, pos.y, r, r);   
   
  }
}
