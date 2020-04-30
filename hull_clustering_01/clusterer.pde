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
       dir.setMag(magnitude);
       dir.mult( 1.0 / (r2+eps) );
       v.add(dir);
       //print(v.mag());
       o.v.sub(dir);
     }
  }
  
  void move(){
    if ( v.mag()>4){
      v.setMag(4);
    }
    pos.add(v);
    v.mult(0.5);
  }
  
  void interact_inverse(Node o, float magnitude){
    if(this != o && o!=null){
       PVector dir = PVector.sub(pos, o.pos);
  
       dir.mult( magnitude );
       v.add(dir);
       //print(v.mag());
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
    float nn_repuslion = 110.*width/(float)hull.size();
    float nn_att =  -0.001 * width/(float)hull.size();
    
    //println("nn_repuslion", nn_repuslion);
    //float eps=0.0001;
    //float size = dataset.size();
    float att_magnitude =-100.0 * width * (float)hull.size() / (float)dataset.size();
    
 
    for (Node n: hull){
      for (Node p: hull){
         n.interact_sq(p, nn_repuslion);             
      }
    }
    
    for (Node n: hull){
         n.interact_inverse(n.left, nn_att );
         n.interact_inverse(n.right, nn_att);
    }
    
    
    for (Node n: hull){
      for (PVector p: dataset){
        PVector v1 = PVector.sub(n.pos, p);
         float mgq = v1.magSq();
         v1.setMag(att_magnitude).div(0.001+mgq);
         n.v.add(v1 );
      }
    }
    
    for (Node n: hull){
      
      n.move();
       
    }
    
   
  }
  
  
  
  void draw( ){
    int r = 6;
    
    stroke(c3);
    for (Node n: hull){
      PVector p = n.pos;
      ellipse(p.x, p.y, r, r);
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
    float r = width/3.0;
    float n =  (3 + sqrt( dataset.size()));
    ArrayList<Node> nodes = new ArrayList();
        
    Node  node=new Node();
    nodes.add(node);
    for (int i = 1; i < n; i++ ){
      node= new Node();
      nodes.add(node);      
      node.setLeft (nodes.get(i-1));
    }
    nodes.get(0).setLeft (node);


    float an = 2.0 * PI / n;
    for (int i = 0; i < n; i++ ){
      nodes.get(i).pos = new PVector( r * sin(i*an) , r * cos(i*an));
      nodes.get(i).pos.z=3*randomGaussian();
    }
    return nodes;
}
