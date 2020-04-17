void drawHex(float x, float y, float r) {
  beginShape();
  for(int i=0; i < 6; i++){
    float angle = i * 2 * PI / 6 ;
    vertex(x + r * cos(angle), y + r * sin(angle) );
  }
  endShape(CLOSE);
}


Table initTrainsetMeta(){
  Table table = new Table();
  table.addColumn("id");
  table.addColumn("filename");
  table.addColumn("data");
  table.addColumn("encoded6");
  
  return table;
}

void save_trainset(Table table, String data, String encoded6){
 
  int imageNumber = frameCount;   
  
  String filename = String.format("/Users/artem/work/creative-code/show/trainset/snow_%04d.jpg", imageNumber);
  saveFrame(filename);
  println(filename);

   
  
  TableRow newRow = table.addRow();
  newRow.setInt("id", imageNumber);
  newRow.setString("filename", filename);
  newRow.setString("data", data);
  newRow.setString("encoded6", encoded6);
  
  
  saveTable(table, "/Users/artem/work/creative-code/show/trainset/metadata.csv");
 

}
