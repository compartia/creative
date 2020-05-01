float eps=0.01;

class Node{
  PVector pos = new PVector();
  PVector v = new PVector();
  Node left;
  Node right;
  
  void setLeft(Node l){
    this.left = l;
    l.right = this;
  }
  
  void interact_sq(Node o, float magnitude){
    if(this != o && o!=null){
       PVector dir = PVector.sub(pos, o.pos);
       float r2 = dir.magSq();
       if (r2>1){
         dir.setMag(magnitude);
         dir.mult( 1.0 / (r2+eps) );
         v.add(dir);
         //print(v.mag());
         o.v.sub(dir);
       }
     }
  }
  
  void move(){
    if ( v.mag()>width*0.1){
      v.setMag(width*0.1);
    }
    pos.add(v);
    v.mult(0.23);
  }
  
  void interact_inverse(Node o, float magnitude){
    if(this != o && o!=null){
       PVector dir = PVector.sub(pos, o.pos);
  
       dir.mult( magnitude );
       if(dir.mag() > 1)
         v.add(dir);       
         o.v.sub(dir);
     }
  }
}

class Hull{
  ArrayList<Node> hull;
  float md = 2;
  public Hull(ArrayList<PVector> dataset ){
    this.hull = make_hull_2d(datapoints);
  }
  
  
  void move(ArrayList<PVector> dataset){
    float nn_att = -20. / (float)hull.size();
    float nn_repuslion =  0.001*10.* 4.0 /   hull.size();
    
    
    //println("nn_repuslion", nn_repuslion);
    //float eps=0.0001;
    //float size = dataset.size();
    float att_magnitude = -10;//-0.1 * (float)width * (float)hull.size() / (float)dataset.size();
    
 
    for (Node n: hull){
      for (Node p: hull){
          if (PVector.sub(p.pos, n.pos).mag() < width/2.0)
        n.interact_inverse(p, nn_repuslion);             
      }
    }
    
    for (Node n: hull){
         n.interact_sq(n.left, nn_att );
         n.interact_sq(n.right, nn_att);
    }
    
    
    for (Node n: hull){
      for (PVector p: dataset){
         PVector d = PVector.sub(n.pos, p);
         float r2 =  d.magSq()+ 1;
         d=d.div(4*dataset.size());
         
         d.div(0.0001*r2);
         n.v.sub(d );
         
      }
    }
    
    for (Node n: hull){
      
      n.move();
       
    }
    
   
  }
  
  
  
  void draw( ){
    int r = 6;
    
    stroke(c3);
    strokeWeight(3);
    noFill();
    for (Node n: hull){
      if(n.left!=null)
        line(n.left.pos.x, n.left.pos.y, n.pos.x, n.pos.y);
    }
    
    noStroke();
    fill(c2);
    for (Node n: hull){
      PVector p = n.pos;
      ellipse(p.x, p.y, r, r);
    }
    
    
    
   
  }


}

 
ArrayList<Node> make_hull_2d(ArrayList<PVector> dataset ){
    //TODO: find radius
    float r = width/4.0;
    float n =  150;//2*(3 + sqrt( dataset.size())) ;
    ArrayList<Node> nodes = new ArrayList();
        
    Node  node=new Node();
    nodes.add(node);
    for (int i = 1; i < n; i++ ){
      node= new Node();
      nodes.add(node); 
      
      //if (random(1)<0.995)
        node.setLeft (nodes.get(i-1));
    }
    nodes.get(0).setLeft (node);


    float an = 2.0 * PI / n;
    for (int i = 0; i < n; i++ ){
      nodes.get(i).pos = new PVector( r * sin(i*an) , r * cos(i*an));
      nodes.get(i).pos.z= randomGaussian();
    }
    return nodes;
}
