
void drawLegend(){
  
  float r = 30;
  pushStyle();
  
  translate(r, r*3);
  
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
  popStyle();
}
