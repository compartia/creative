
import geomerative.*;
int numPoints = 2500;
String svgFile = "letter-G-fira.svg";
float al = 16;
color gold1 = color(217, 204, 158, al);
color gold2 = color(252, 166, 68, al);

color gold3 = color(166, 227, 215, al / 2);

color bg1 = color(14, 16, 33, al);
color bg2 = color(48, 39, 37, al);
color bg3 = color(0, 0, 0, al);

color c1=color(0);
color c2=color(255, 200, 150, al);

color c3=color(3, 217, 200, al);
color c4=color(3, 80, 200, al);

color c5=color(30, 40, 50, 18);

color c6=color(218, 255, 54, 8);
color c7=color(48, 44, 56, 28);

    // --------------
boolean ignoringStyles = true;
RShape shp;
RPoint[] points;
RPoint[] tangents;

    // --------------

void setup() {   
 
  size(1080, 1080);
  background(0);
  frameRate(30);
   
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

void draw() {

    scale(0.7);
    translate(width / 2, height / 1.7);

    drawShapes();
}

void drawShapes() {
    noFill();
    stroke(255, 50);

    for (int i = 0; i < points.length; i++) {
        pushMatrix();
        translate(points[i].x, points[i].y);

        for (int k = 0; k < 2; k++) {

            color gold = lerpColor(gold1, gold1, 0.5 * (sin(12 * 6 * tangents[i].x) + 1));

            color bg = lerpColor(bg1, bg3, random(1));
            bg = lerpColor(bg, bg2, random(1));

            stroke(bg);
            float rnd = abs(randomGaussian()) / 3;
            line(randomGaussian() * width, randomGaussian() * height, 0, 0);

            stroke(gold);
            line(0, 0, rnd * 400, rnd * 400);
        }
        popMatrix();
    }

}

void mouseReleased() {

    println(frameCount + " ");
    saveFrame("letter_####.png");
}
