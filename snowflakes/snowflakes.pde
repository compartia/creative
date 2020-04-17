color[] pal = {
  color(193,24,39),
  color(255,227,0),
  color(31,75,149),
  
  color(174,185,184),
  color(239,237,220),
  color(165,213,236),
};

color[] bits_pal = {
  color(255,0),
  pal[0],
  pal[1],
  pal[2],
  pal[3],
  pal[4] 
};

float hex_aspect = sin(2.*PI/3);
 

void setup() {
  size(640, 640);  
  background(0);
  frameRate(1);
  smooth(2);
  pixelDensity(2);  
}

float p1=0;
float p2=0;

int hash=0;
int BASE=6;

 
 
int[] hashDigits(String data){
  byte[] byteArr = data.getBytes();

  
  String s = new java.math.BigInteger(1, byteArr).toString(BASE);
  int reserve = 3;
  int [] ret = new int[reserve+s.length()];
  ret[0]=1;
  ret[1]=2;
  ret[2]=3;
  for (int i =0; i< s.length(); i++){
    ret[i+reserve] = Integer.parseInt(""+s.charAt(i));
    print(ret[i]);
  }
  return ret;
}

void draw(){
  background(10);
  fill(128);
  String nm=getRandomName();
  text(nm, 20,20);  
  
  println(hash+" "+p1);
  int[] digits = hashDigits(nm);
  
  println("digits = "+digits.length);
  translate(width/2, height/2);
  
  for (int k=0; k<6; k+=1){
    pushMatrix();
    rotate(PI+ k*PI/3);
    {
      drawSector(k, digits);
    }
    popMatrix();
  }
  
  //saveFrame("/Users/artem/work/creative-code/show/1/snow__####.png");
}

int R=170;

void drawSectorHalf(int k, int[] digits, color[] bits_pal){
  float rd =  R/15;
  float th = rd*0.58;
  float skew = 0; //-rd/2 * sin(radians(30));
  
   noStroke();
 
   int pal_offset=digits[ 4 ];
    
    
    int n=0;
    noStroke();
    for (int row=0; row<30; row++){
      for (int j=row/2; j<row; j++){
        if(n<digits.length){
          int ci = digits [ n ];
          
          fill( bits_pal[(ci+pal_offset) % BASE] );
           
          float x = rd +  j*rd - rd*(row % 2)*0.5 - rd * (int)(row/2);
          float y = hex_aspect * (row*rd);
          float angle_add=0;
           
          if(n<150)
            angle_add=ci * PI/3 ; 
          if(j==row-1)
            angle_add=0;
          
          
          pushMatrix();{
            translate(x, y);
            rotate(angle_add-PI/6);
            
           
            //TODO: either make it complex shape, or replace with just a line
            beginShape();
            vertex(-th/2, -rd/2);
            vertex(th/2, -rd/2 +skew);
            vertex(th/2, rd/2 +skew);
            vertex(-th/2, rd/2);
            endShape(CLOSE);
            
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
  noLoop();
}
