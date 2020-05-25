
ArrayList<PVector>  make_bubbles(int n){
  ArrayList<PVector> dps = new ArrayList();
  
  for (int i =0; i< n; i++){
    float radius = width/20.0 + random(width/3.0);
     int size = (int)(200 + random(200));
     PVector c = new PVector( 0.3 * randomGaussian() * width, 0.3 * randomGaussian() * height);
     PVector b = new PVector( radius, radius);
     
     //ArrayList<PVector> bubble =   make_bubble( size, c, b);
     dps.addAll( make_bubble( size, c, b) );
  }
  return dps;
}

ArrayList<PVector>  make_bubble(int size, PVector center, PVector bounds){
  ArrayList<PVector> dps = new ArrayList();
  for (int i =0; i< size; i++){
     PVector k = center.copy();
     k.x +=0.3 * bounds.x * randomGaussian();
     k.y +=0.3 *  bounds.y * randomGaussian();
     dps.add(k);
  }
  return dps;
}
