



int BASE=6; //encoding base; 2 for binary; 10 is max



//@deprecated
float R = 170;// size of flake

boolean SHOW_LEGEND = false;
boolean SHOW_DATA = false;
boolean SHOW_ORDER = false;
boolean SHOW_FLAKE = true;
boolean SHOW_GRID = false;

boolean SAVE_TRAINSET = false;

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
  //pal[3], //4
  pal[2]  //5
};



void setup() {
  //size(512, 512);
  size(1080, 1080);
  background(0);
  frameRate(1);
  smooth(4);
  
  pixelDensity(2);
  if (SAVE_TRAINSET)
    pixelDensity(1);
    
  //if (!SAVE_TRAINSET)
    
  
  //noLoop();
  R = width/3.5;
  testHashing();
}


Table table =  initTrainsetMeta();
 
 
void draw(){
  background(10);
   
  String nm = getRandomName();
     
  if (SHOW_LEGEND){
    drawLegend();
  }
  
  
  if (SHOW_FLAKE) {
    translate(width/2, height/2);
    drawFlake(nm);
  }
  
  
  if(SHOW_GRID){
    pushMatrix();
    int grid_size = 3;
    float cell_size = width/grid_size;
    float aspect = cell_size/width;
    for (int x=0; x<grid_size; x++){
      for (int y=0; y<grid_size; y++){
        pushMatrix();
        float xx = x * cell_size + cell_size/2;
        float yy = y * cell_size + cell_size/2;
        translate(xx, yy);
        scale(aspect);
        drawFlake(getRandomName());
        popMatrix();
      }
    }
    popMatrix();
  }
  
  if(SAVE_TRAINSET){
    if(frameCount<500)
      save_trainset(table, nm, convertStringToBase(nm,   BASE));
    else noLoop();
     
  }
  //saveFrame("/Users/artem/work/creative-code/show/1/snow__####.png");
}


void drawFlake(String nm){
  pushMatrix();
  int[] digits = hashDigits( nm, BASE );
  
  if (SHOW_DATA){
    fill(128);    
    text(nm, 20, 20);
  }
 
 
  for (int k=0; k < 6; k+=1){
    pushMatrix();
    rotate(  k*PI/3);
    {
      drawSector( digits);
    }
    popMatrix();
  }
 
  popMatrix();
  
  //saveFrame("/Users/artem/work/creative-code/show/1/snow__####.png");
}


/**
-=-----------MAIN g ENCODING methog
*/
void drawPixel(float r, int value, color[] bits_pal, boolean add_hex, int i, int j){
  
  //if(i != j) return;
  
  pushStyle();
  pushMatrix();
  
   
  float th = r * 0.5; 
  float angle  = PI/2 + value * PI/3  ; 
  
  
  if (j == i-1){
    angle=0;
  }
  rotate(angle);

  if(add_hex){
    stroke(255, 50);
    noFill();
    drawHex(0, 0, 0.5*r/hex_aspect);
  }

  //pixel color index
  int color_index = value % bits_pal.length;
  
  //if (i*j < 33){
  //  //take next color
  //  int fill_color_index = 1;
  //  if (fill_color_index==color_index)
  //    fill_color_index = (color_index+1) % bits_pal.length;
      
  //  fill( bits_pal[ fill_color_index] );
  //  noStroke();
  //  drawHex(0, 0, 0.5*r/hex_aspect);
  //}
  
  
 //   /  \
 //   |  |
  //stroke( bits_pal[  color_index ] );
  //strokeCap(SQUARE);
  //strokeWeight(th/2.0);
  
  noStroke();
  fill(bits_pal[  color_index ]);
   
  //line(-th,0,0,0);
  rotate(-PI/2);
  drawSegment(r);
  rotate(PI/3);
  scale(-1,1);
  //line(0, 0, th, 0);
  drawSegment(r);
  
   


  popMatrix();
  popStyle();
}

 
void drawSegment(float d){
  float r=d/2;
  float th = r/2.0;
  float s = -0.25*th/hex_aspect;
  beginShape();{
     //TODO: either make it complex shape, or replace with just a line
   vertex(0-s, -th/2);
   vertex(r, -th/2 );
   vertex(r, th/2);
    vertex(0+s, th/2);
  }
   endShape(CLOSE);
}

/**
renders 1/12 sector of a hexagon
**/
void drawSectorHalf( int[] digits, color[] bits_pal){
  float rd =  R/15;  
  
  noStroke();
    
  int n=0;
  noStroke();
  
  for (int row=0; row<30; row++){
    for (int j = row/2; j<row; j++){
      if(n<digits.length){
        
        int ci = digits [n]; //digit corresponds to color and rotation 

        float angle = 0;
        //if(n < digits.length/2)
        //  angle = PI/3 ;
          
   
        pushMatrix(); {

          // following the grid
          float x = rd +  j*rd   -   rd * (row % 2)*0.5   -   rd * (int)(row/2);
          float y = hex_aspect * (row*rd);
          translate(x, y);
          rotate(angle);
          
          if (SHOW_ORDER){
            fill(255, 100);
            textSize(8);
            text(""+n, 0,0);
          } else {
            drawPixel(rd, ci, bits_pal, false, row, j-row/2);
          }                                        
        }
        popMatrix();
                  
      }
      n++;
    }
  
  }
   
}

void drawSector( int[] digits){
  pushMatrix();
  {
    drawSectorHalf( digits, bits_pal);
    scale(-1,1);
    drawSectorHalf( digits, bits_pal);
  }
  popMatrix();  
}

void mouseReleased() {   
  println(frameCount+" ");
  saveFrame("/Users/artem/work/creative/snowflakes/sample_images/snow__####.png");
  
  noLoop();
}
