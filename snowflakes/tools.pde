void drawHex(float x, float y, float r) {
  beginShape();
  for(int i=0; i < 6; i++){
    float angle = i * 2 * PI / 6 ;
    vertex(x + r * cos(angle), y + r * sin(angle) );
  }
  endShape(CLOSE);
}
