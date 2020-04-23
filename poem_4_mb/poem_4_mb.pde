String poem="На белой бумаге черная итальянская магия\n"+
"грабит банки чернил и памяти.\n"+
"Вселенная, пленница символов,\n"+
"исполняет любовь под дуду алхимии.\n"+
"Теперь не имеет значения, любовь истинна или\n"+
"она -- лишь симптом, эдакий Стокгольмский синдром.\n"+
"Абракадабра мантры в действии. Ом шанти ом!\n"+

"Когда плотность чудес, как в кино,\n"+
"неофобия просит одно: детоксикации! --\n"+
"за шевелюру -- на дно --\n"+
"фокус Мюнхгаузена, только в противофазе --\n"+
"спрятать остатки себя в облаках каракатиц,\n"+
"в кольцах аккреции черных сердец,\n"+
"за горизонтом соитий уравнивать денствия, ныть\n"+
"в энергетически-выгодной потенциальной низине,\n"+
"в омуте амнезии.\n"+
"Ты могла сделать меня цветком,\n"+ 
"но я становлюсь раффлезией.\n"+

"Память доступна на запись и чтение,\n"+
"удаление же запрещено эпистемой,\n"+
"смажь соком из глаз макияж, обнажи\n"+ 
"татуаж, покажи, обратима ли\n"+
"декогеренция побратимов?\n"+
 
"На том берегу войда, стих\n"+
"запутан с тобою, и, пусть\n"+
"на какую-то часть он мертв или пуст, но на другую —\n"+
"сил полон и Луна существует, пока на нее воет\n"+
"солипсист-воин в электромагнитном поле.\n"+

"Настройка моего приемника не очень\n"+
"точна, но я думаю, что реальность --\n"+
"это радиоволна\n"+
"и, она, разумеется, не одна.\n"+
"На всех частотах\n"+
"миротворец Хью Эверетт (пользуюсь случаем)\n"+
"передает привет.\n"+
 
"Пока похоже, что это игра, --\n"+
"шахматный шутер от первого лица,\n"+
"в лабиринтах кроссвордов\n"+
"зомби - фигуры (и пунктуация),\n"+
"белый слон уже ест афро-американского короля,\n"+
"Но, верю я, в одной из вселенных возможна ничья.\n";



String prep = poem.replaceAll("--","—").replaceAll(" "," ") ;
float ts=25;

PFont f;
String[] lines;
float[] shifts;
int visiblelines;
float lineHeight=1.62;
void setup(){
  
  lines = prep.split("\n");
  shifts=new float[lines.length];
  
  //noLoop();
  
  size(864, 1080);
  //size(560, 560);
  background(255);
  pixelDensity(2);
  frameRate(30);
  //smooth(4);
  
  ts=height/38;
  f = createFont("Literata-VariableFont_wght.ttf",ts,true);
  
  
  textFont(f,ts);
  textSize(ts);
  
  visiblelines =(int) ((float)height/(ts*lineHeight))-1;
  //
}
float pos=100;
float speed = 1.0/180.0;


 
int motionblur_steps=24;

void drawShadLine(String line){
  //rotate(radians(-30));
  float x=0;
  for(int i=0; i<line.length(); i++){
    String cc= line.substring(i,i+1);
    float w = textWidth(cc);
    int alph=255-i*4;
    fill(255, alph);
    text(cc, x, 0);
    x+=w;
  }
}


float drawLine(int k){
  
  float x = 0;
  
  
  for(int i=0; i<lines.length; i++){
    String line = lines[ (k+i) % lines.length ].replaceAll("\n", " ");
    if(!line.endsWith(" ")) line+=" ";
    float w = textWidth(line);
    
     
    noStroke();
    
    pushMatrix();
    translate(x, 0);
    drawShadLine(line );
    //fill(255,0,0);
    //text(line, 0, 0);
    stroke(255, 40);
    //line(0, ts/2, w, ts/2);
    //line(0, -ts/2, w, -ts/2);
    popMatrix();
    
    
    
    //line(x,0,x,-10);
    x += w;
  }
  
  return 0;
}

int framesPerMotion=60;
int currentLine=0;
int endframe=0;
void draw(){
  endframe = framesPerMotion * lines.length;
  boolean snap =  (frameCount % framesPerMotion) == 0;
  float motionPhase =  (frameCount % framesPerMotion) / ((float) framesPerMotion);
  
    
  background(0);
  //fill(255, 140);
  for(int i=0; i<visiblelines; i++){
    String ln = lines[ (i+currentLine)% lines.length  ].replaceAll("\n", " ");
    
    float lw= textWidth(ln);
    if(snap){
      shifts[i]+=lw; 
    }
    
    pushMatrix();
    float smoother =  (1.0-  0.5*(cos(PI * motionPhase)+1));
     
    
    //smoother += 0.02 * sin(motionPhase*6);
    float off_x = - lw * smoother - shifts[i] ;// 0.2 * width * sin( frameCount/22.0); 
    translate(ts*4 + off_x,  (i+1.5)*ts*lineHeight);
    drawLine(i);
    popMatrix();
    //String line = lines[i];
    //float w = textWidth(line);
    //float y = ts * 1.5 * i;
    //float x = ts*4;
    //text(lines[i], x, y);
  }
  
  if(snap){    
    currentLine++;
  }
  
  ////scale(0.5);
  
  //pos+=0.5;
  //background(0);
  //textSize(ts);
  //translate(0, ts);
  //rotate(radians(-3 -0.9 * sin ((float)frameCount/50.0) ));
  
  //blendMode(ADD);
   
  //noStroke();
  
  //fill(30, 2 + 256/motionblur_steps);
  
  //for (int mb=0; mb<motionblur_steps; mb++){
  //  int r = 255 - mb*256/motionblur_steps;
  //  int b = 256-r;
  //  fill(r, b, b, 1 + 1.3*256/motionblur_steps);
    
  //  pos = pos - (float)width*speed/(float)motionblur_steps;
    
  //  for (float y=-ts*3; y<height+ts*5; y+=ts*1.5){
  //    float offset_x = y*12  -(0.1*width)*sin(4*y/height) ;
       
  //    float speed_v = 1.3 + sin(y/2.2)*0.2 + sin(y/3)*0.3  ;//1.6 + sin(y/3)*0.3 + sin(y/7)*0.4;
      
      
  //    text(prep, pos * speed_v - offset_x, y  );
  //  }
  //}
  
  if(frameCount<3000)
    saveFrame("/Users/artem/work/creative-code/poem_out_hr_black/poem__####.png");
}


void mouseReleased() {
  looping = !looping; 
  if (looping) {
    loop();
  } else {
    noLoop();
  }
  println(frameCount, pos, lines.length, endframe);
  saveFrame("/Users/artem/work/creative-code/poem_1/poem__####.png");
}
