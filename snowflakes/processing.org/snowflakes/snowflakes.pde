
int BASE=6; //encoding base; 2 for binary; 10 is max
//@deprecated
int R = 170;// size of flake

boolean SHOW_LEGEND = true;
boolean SHOW_DATA = false;
boolean SHOW_FLAKE = true;

boolean SHOW_ORDER = true;


float hex_aspect = sin(2.*PI/3);


color[] pal = {
  color(193,24,39),
  color(255,227,0),
  color(31,75,149),
  
  color(174,185,184),
  color(239,237,220),
  color(165,213,236),
};

color[] bits_pal = {
  color(255,0), //0
  pal[0], //1
  pal[1], //2
  pal[4], //3
  pal[3], //4
  pal[2]  //5
};



void setup() {
  size(640, 640);  
  background(0);
  frameRate(1);
  smooth(2);
  pixelDensity(2);  
  
  //noLoop();
}

 
void draw(){
  background(10);
  
  String nm = getRandomName();
  int[] digits = hashDigits( nm, BASE );

  if (SHOW_DATA){
    fill(128);    
    text(nm, 20, 20);
  }
    
  if (SHOW_LEGEND){
    drawLegend();
  }
  

  if (SHOW_FLAKE) {
    translate(width/2, height/2);
  
    for (int k=0; k<1; k+=1){
      pushMatrix();
      rotate(  k*PI/3);
      {
        drawSector(k, digits);
      }
      popMatrix();
    }
  }
  
  
  //saveFrame("/Users/artem/work/creative-code/show/1/snow__####.png");
}



void drawPixel(float r, int value, color[] bits_pal, boolean add_hex){
  pushStyle();
  pushMatrix();
  //TODO: either make it complex shape, or replace with just a line

  float skew = 0;
  float th = r * 0.38;
  
  float angle  = PI/2 + value * PI/3  ; 
  
  rotate(angle );

  if(add_hex){
    stroke(255, 50);
    noFill();
    drawHex(0,0, 0.5*r/hex_aspect);
  }


  noStroke();
  fill( bits_pal[  (value) % bits_pal.length  ] );
   beginShape();{
     vertex(-th/2, -r/2);
     vertex(+th/2, -r/2 +skew);
     vertex(+th/2, r/2 +skew);
     vertex(-th/2, r/2);
   }
   endShape(CLOSE);


  popMatrix();
  popStyle();
}

/**
renders 1/12 sector of a hexagon
**/
void drawSectorHalf(int k, int[] digits, color[] bits_pal){
  float rd =  R/15;  
  
  noStroke();

  int pal_offset=digits[ 4 ];
  
  
  int n=0;
  noStroke();
  for (int row=0; row<30; row++){
    for (int j=row/2; j<row; j++){
      if(n<digits.length){
        
        int ci = digits [n]; //digit corresponds to color and rotation 

        // if(n<150)
        //   angle_add=ci * PI/3 ; 
        // if(j==row-1)
        //   angle_add=0;
                  
        pushMatrix();
        {

          // following the grid
          float x = rd +  j*rd   -   rd * (row % 2)*0.5   -   rd * (int)(row/2);
          float y = hex_aspect * (row*rd);
          translate(x, y);
          
          if (SHOW_ORDER){
            fill(255, 100);
            textSize(8);

            text(""+n, 0,0);
          }else{
            drawPixel(rd, ci, bits_pal, false);
          }
          
                    
          
        }
        popMatrix();
                  
      }
      n++;
    }
  
  }
  println(n);
}

void drawSector(int k, int[] digits){
  pushMatrix();
  {
    drawSectorHalf(k, digits, bits_pal);
    scale(-1,1);
    drawSectorHalf(k*2+1, digits, bits_pal);
  }
  popMatrix();  
}

void mouseReleased() {   
  println(frameCount+" ");
  saveFrame("/Users/artem/work/creative/snowflakes/sample_images/snow__####.png");
  
  noLoop();
}
