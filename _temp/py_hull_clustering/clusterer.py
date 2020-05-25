eps=0.01
bg = color(0)
c1 = color(255, 200, 54, 70)
c2 = color(3, 217, 255, 200)
c3 = color(3, 180, 255, 208)

class Node:
    def __init__(self): 
        self.pos = PVector()
        self.v = PVector()
        self.left = None
        self.right = None

  
    def setLeft(self, l):
        self.left = l
        l.right = self

  
    def interact_sq(self,  o,  magnitude):
        if self != o and o is not None:
            dir =  self.pos - o.pos
            r2 = dir.magSq()
            if r2 > 1:
                dir.setMag(magnitude)
                dir /= r2 + eps
                self.v += dir
                o.v -= dir
    

    def interact_inverse(self, o,  magnitude):
        if self != o and o is not None:
            dir = self.pos - o.pos;
                        
            if dir.mag() > 1:
                dir.mult( magnitude )
                self.v += dir    
                o.v -= dir
                
                
    def move(self):
        if self.v.mag() > width * 0.1:
            self.v.setMag( width * 0.1 )
 
        self.pos += self.v
        self.v.mult(0.23)
        
    


class Hull:
    def __init__(self, datapoints):
        self.md = 2
        self.hull = make_hull_2d(datapoints)
        
  
    def move(self,  dataset):
        nn_att = -20. / float(len(self.hull)) 
        nn_repuslion =  0.001*10.* 4.0 /  float(len(self.hull))
    
        
        att_magnitude = -10;#//-0.1 * (float)width * (float)hull.size() / (float)dataset.size()
 
        # for each core
        for n in self.hull:
            
            ## linked
            n.interact_sq (n.left,  nn_att)
            n.interact_sq (n.right, nn_att)
            
            ## each other
            for p in self.hull:
                if (p.pos - n.pos).mag() <  width / 2.0:
                    n.interact_inverse(p, nn_repuslion)            
                    
            ## data points
            for p in dataset:
                d =  n.pos - p
                r2 =  d.magSq() + 1.0
                d /=  4.0 * float(len(dataset))                     
                d/= 0.0001 *r2  
                
                n.v -= d 
            

        for n in self.hull:
            n.move() 
        
 
  
    def draw(self):
        r = 6
    
        stroke(c3)
        strokeWeight(3)
        noFill()
        
        for n in self.hull:
            if n.left is not None:
                line(n.left.pos.x, n.left.pos.y, n.pos.x, n.pos.y)
    
    
        noStroke()
        fill(c2)
        
        for n in self.hull:
            p = n.pos
            ellipse(p.x, p.y, r, r)
    
    
    
  
 
def make_hull_2d( dataset ):
    # //TODO: find radius
    r = width / 4.0
    n =   int(3 + sqrt( len(dataset) ))
    nodes = []
        
    node = Node()
    nodes.append(node)
    for i in range(1, n):     
        node = Node();
        nodes.append(node);       
        node.setLeft ( nodes[i-1] )
 
    nodes[0].setLeft(node)


    an = TWO_PI / n
    for i in range(n):     
        nodes[i].pos = PVector( r * sin(i * an) , r * cos(i * an))
        nodes[i].pos.z= randomGaussian()
    
    return nodes
 
