String poem="На белой бумаге черная итальянская магия "+
"грабит банки чернил и памяти. "+
"Вселенная, пленница символов, "+
"исполняет любовь под дуду алхимии. "+
"Теперь не имеет значения, любовь истинна или "+
"она -- лишь симптом, эдакий Стокгольмский синдром. "+
"Абракадабра мантры в действии. Ом шанти ом! "+

"Когда плотность чудес, как в кино, "+
"неофобия просит одно: детоксикации! -- "+
"за шевелюру -- на дно -- "+
"фокус Мюнхгаузена, только в противофазе -- "+
"спрятать остатки себя в облаках каракатиц, "+
"в кольцах аккреции черных сердец, "+
"за горизонтом соитий уравнивать денствия, ныть "+
"в энергетически-выгодной потенциальной низине, "+
"в омуте амнезии. "+
"Ты могла сделать меня цветком, но я становлюсь раффлезией. "+

"Память доступна на запись и чтение, "+
"удаление же запрещено эпистемой, "+
"смажь соком из глаз макияж, обнажи "+ 
"татуаж, покажи, обратима ли "+
"декогеренция побратимов? "+
 
"На том берегу войда, стих "+
"запутан с тобою, и, пусть "+
"на какую-то часть он мертв или пуст, но на другую — "+
"сил полон и Луна существует, пока на нее воет "+
"солипсист-воин в электромагнитном поле. "+

"Настройка моего приемника не очень "+
"точна, но я думаю, что реальность -- "+
"это радиоволна "+
"и, она, разумеется, не одна. "+
"На всех частотах "+
"миротворец Хью Эверетт (пользуюсь случаем) "+
"передает привет. "+
 
"Пока похоже, что это игра, -- "+
"шахматный шутер от первого лица, "+
"в лабиринтах кроссвордов "+
"зомби - фигуры (и пунктуация), "+
"белый слон уже ест афро-американского короля, "+
"Но, верю я, в одной из вселенных возможна ничья. ";




float ts=25;

PFont f;   
void setup(){
  
  //noLoop();
  
  size(864, 1080);   
  background(255);
  pixelDensity(2);
  frameRate(30);
  smooth(4);
  
  ts=height/40;
  f = createFont("Literata-VariableFont_wght.ttf",ts,true);
  
  
  textFont(f,ts);
  textSize(ts);
  //
}
float pos=100;
float speed = 1.0/230.0;
String prep = poem.replaceAll("\n"," ").replaceAll("--","—").replaceAll(" "," ") ;

 
int motionblur_steps=20;
void draw(){
  pos+=0.5;
  background(0);
  textSize(ts);
  translate(0, ts);
  rotate(radians(-3 -0.9 * sin ((float)frameCount/50.0) ));
  
  blendMode(ADD);
   
  noStroke();
  
  fill(30, 2 + 256/motionblur_steps);
  
  for (int mb=0; mb<motionblur_steps; mb++){
    int r = mb*256/motionblur_steps;
    int b = 256-r;
    fill(r, b, b, 2 + 256/motionblur_steps);
    
    pos = pos - (float)width*speed/(float)motionblur_steps;
    
    for (float y=-ts*3; y<height+ts*5; y+=ts*1.5){
      float offset_x = y*12  -(0.1*width)*sin(4*y/height) ;
       
      float speed_v = 1.3 + sin(y/2.2)*0.2 + sin(y/3)*0.3  ;//1.6 + sin(y/3)*0.3 + sin(y/7)*0.4;
      
      
      text(prep, pos * speed_v - offset_x, y  );
    }
  }
  
  //saveFrame("/Users/artem/work/creative-code/poem_out_hr_mb/poem__####.png");
}


void mouseReleased() {
  looping = !looping; 
  if (looping) {
    loop();
  } else {
    noLoop();
  }
  println(frameCount, pos);
  saveFrame("/Users/artem/work/creative-code/poem_1/poem__####.png");
}