
import geomerative.*;
int numPoints = 2500;
String svgFile="/Users/artem/Downloads/Untitled drawing.svg";
//String svgFile = "/Users/artem/Google Drive/stellator/designs/izmes/MINIMALIST.svg";
float al=16;
color gold1 = color(217, 204, 158, al);
color gold2 = color(252, 166, 68, al);
//color gold1 = color(0, 216, 40, 10);
//color gold2 = color(224, 0, 0, 50);
color gold3 = color(166, 227, 215, al/2);

color bg1 = color(14, 16, 33, al);
color bg2 = color(48, 39, 37, al);
color bg3 = color(0, 0, 0, al);

color c1=color(0);
color c2=color(255, 200, 150, al);

color c3=color(3, 217, 200, al);
color c4=color(3, 80, 200, al);

color c5=color(30, 40, 50, 18);

color c6=color(218, 255, 54, al);
color c7=color(48, 44, 56, 28);

//--------------
boolean ignoringStyles = true;
RShape shp;
RPoint[] points;
RPoint[] tangents;

//--------------

void setup() {   
 
  size(1080, 1080);
  background(0);
  frameRate(30);
  //smooth(0);
  pixelDensity(2);   
  background(48, 44, 56);
  
  RG.init(this);
  RG.ignoreStyles(ignoringStyles);
  
  shp = RG.loadShape(svgFile);
  shp = RG.centerIn(shp, g, 100);
  
  points = null;
  tangents = null;
  
  for(int i=0; i<numPoints; i++){
    RPoint point = shp.getPoint(float(i)/float(numPoints));
    RPoint tangent = shp.getTangent(float(i)/float(numPoints));
    if(points == null){
      points = new RPoint[1];
      tangents = new RPoint[1];
      
      points[0] = point;
      tangents[0] = tangent;
    }else{
      points = (RPoint[])append(points, point);
      tangents = (RPoint[])append(tangents, tangent);
    }
  }

}
 
 

void draw(){
   //blendMode(ADD);
  scale(0.9);
  translate(width*0.6, height*0.45);
  
  //drawCircleBlured(getGraphics());
  drawShapes();
}


void drawShapes(){
  noFill();
  stroke(255, 50);
  
  //line(0,0,200,2000);
  for(int i=0;i<points.length;i++){
    pushMatrix();
    translate(points[i].x, points[i].y);
    RPoint tangent = tangents[i];
    
    for (int k=0; k<2; k++){
      noFill();
        
      
      color bg = lerpColor(bg1, bg3, random(1));
      bg = lerpColor(bg, bg2, random(1));
      
      
      stroke(bg);
 
      //line(randomGaussian()*width/2, randomGaussian()*width/2, randomGaussian(), randomGaussian()  );
      
      
     
       
    }
    
    for (int k=0; k<200; k++){
      noFill();
      color gold = lerpColor(gold1, gold1, 0.5*(sin(12*6*tangents[i].x)+1));
      
      
      color bg = lerpColor(bg1, bg3, random(1));
      bg = lerpColor(bg, bg2, random(1));
      
      //float rnd = abs(randomGaussian());
      //float rnd2 = abs(rnd + randomGaussian());
      //float xx = 0 + tangents[i].x*rnd + randomGaussian()*.5;
      //float yy = 0 + tangents[i].y*rnd2 + randomGaussian()*.5;// abs(randomGaussian())*45;
      
      //if (tangents[i].x+randomGaussian()*100>0)
      //  line(xx, yy, xx, yy);
      stroke(bg);
      float x2 = 70*abs(randomGaussian());
      //float y2 = 170*abs(randomGaussian());
      line(0, x2, 0, x2);
      //stroke(c4);
      //line(randomGaussian(), -x2, randomGaussian(), -x2);
      //float rnd = abs(randomGaussian())/3;
      //ellipse(0,0, randomGaussian()*width/3, randomGaussian()*width/3  );
      //line(randomGaussian()*width, randomGaussian()*width, randomGaussian(), randomGaussian()  );
      
      
      stroke(c6);
      line(-x2, 0, -x2, 0);
      
      stroke(c3);
      float x3 = 20*abs(randomGaussian());
      line(-x3, 0, -x3, 0);
       
    }
    popMatrix();
  }
  
}
 
 

void mouseReleased() {
   
  println(frameCount+" ");
  saveFrame("/Users/artem/work/creative-code/letters/gauss__####.png");
}
 



 
