
void drawLegend(){
  scale (1.4);
  float r = 30;
  pushStyle();
  
  translate(r, r*2);
  
  pushMatrix();
  fill(128);
  textSize(14);
  text("Digits:", 0, 0);
  
  translate(0, r);
  for (int d=0; d<BASE; d++){  
    pushMatrix();
    translate(r*d+r/2, 0);
     
    drawPixel(r*0.7, d, bits_pal, true);
    fill(128);
    text(""+d, 0, r);
    popMatrix();
  }
  
  popMatrix();
  
  pushMatrix();
  translate(0, r*3);
  
  textSize(14);
  text("Order of digits:", 0, 0);
  translate(0, r/2);
  scale(1.4);
  int[] digits = hashDigits( "any random string 12345678", BASE );
  SHOW_ORDER = true;
  drawSectorHalf( digits, bits_pal);
  translate(r*5, 0 );
  SHOW_ORDER = false;
  drawSectorHalf( digits, bits_pal);
  popMatrix();
  
  popStyle();
}
