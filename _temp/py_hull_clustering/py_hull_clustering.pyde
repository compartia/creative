from gauss_fake_dataset import *
from clusterer import * 






# ArrayList<PVector> datapoints;
# Hull hull;
def setup():   
 
  size(540, 540)
  background(0)
  frameRate(30)
  
  pixelDensity(1)
  background(bg)
  
  global datapoints, hull
  datapoints = make_bubbles( 5 )

  hull = Hull(datapoints)
  
 
 

def draw():
    global datapoints, hull
    background(bg)
    # //datapoints = make_bubbles(3);
    translate(width/2, height/2)
    
    r = 4
    fill(c1)
    noStroke()
    for p in datapoints:
        ellipse(p.x, p.y, r, r)
    
    
    hull.draw()
    hull.move(datapoints)
 



 
