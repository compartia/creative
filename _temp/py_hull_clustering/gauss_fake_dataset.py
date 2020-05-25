 

def make_bubble(size, center, bounds):
    dps = []
    for i  in range(size):
        k = center.copy()
        k.x +=0.3 * bounds.x * randomGaussian()
        k.y +=0.3 * bounds.y * randomGaussian()
        dps.append(k)
  
    return dps


def make_bubbles(n):
    dps = []
  
    for  i in range(n):
        radius = width/20.0 + random(width/3.0)
        size = (int)(200 + random(200))
        c = PVector( 0.3 * randomGaussian() * width, 0.3 * randomGaussian() * height)
        b = PVector( radius, radius)
     
        dps += make_bubble( size, c, b) 
  
    return dps

 
