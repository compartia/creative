enum Gender{
  m, f, p
}

enum Tense{
  past, present
}

class Verb{
  String base;//инфинитив
  String base_crop;//инфинитив
  boolean trans;//переходный 
  public Verb(String base, boolean trans){
    this.base=base;
    this.base_crop=crop(base);
    this.trans=trans;
  }
  
  private String crop(String base){
    if(base.endsWith("ать")){
      return base.substring(0, base.length()-3);
    }   
    else return base;
  }
  
  public Verb(String base ){
    this(base, true);
  }
  
  public String morph(Gender gender, Tense tense){
    if(tense==Tense.past){
      //разрушил
      //разрушать
      if(gender==Gender.m ){
        return base_crop+"ил";
      }   
    }
    return base;
  }
  
  
  
  
}


String[] places = {
   "в Давосе", "в церкви", "в архиве", "в анализе", "в архивах Ватикана", "в трудах Ницще",
  "на острове Ява", "в СИЗО", "в новостях", 
  "в думе", 
  "в Америке", "в сауне","в Саудовской Арабии", "на Украине", "в кулуарах", "в зеркале",
  "в туалете", 
  "в поэзии", "в мыслях",
  "в конституции"};
  
  
String[] subjects = {
  "депутат", 
  "самоубийца", 
  "ученый", 
  "президент", "адвокат", "космонавт", "студент", "научный сотрудник", "губернатор", "религиозный фанатик",
  "шаман", "йог", "пранаед", "гимнаст", "водолаз", "полицейский", "грабитель",  
  "енот", "слон", 
  "буддист"}; 
  
  
String[] subjects_obj = {
  "депутата", 
  "самоубийцу", 
  "ученого", 
  "президента", "адвоката", "космонавта", "студента", "научного сотрудника", "губернатора", "религиозного фанатика",
  "шамана", "йога", "пранаеда", "гимнаста", "водолаза", "полицейского", "грабителя",  
  "енота", "слона", 
  "буддиста"}; 
  
  
String[] adj = {
  "бешеный", 
  "убитый",
  "оживший",  "инфицированный",  "оживщий",  
  "пьяный", 
  "невменяемый", "зомбированный", "однорукий", "парадоксальный", "человекообразный", "отравленный", "слепой", 
  "глухой", "ортодоксальный",
  "латентный"};  
  
 String[] adverbs =  {
   "нагло","демонстративно","поспешно","незаметно","вульгарно","грубо","отчаянно","случайно","ненарочно"
 };
 
 String[] verbs_trans = {
  "нашел", 
  "обнаружил",
  "вымачивал",  "перевернул", "заметил",  "потерял", "спрятал",  "похитил",    
  "разрушил", "облил кислотой", "облизал", "перекрасил", "обматерил", "съел", "сжег",   
  "уничтожил", "проглотил", 
  "создал", 
  "украл"};
  
String[] starts = {
  "но", "да, но", "отнюдь,", "напрасно,", "зря,",  "хорошо, что",  
  "однако,",
  "а",  "пока",  "когда",  
  "стоит заметить, что", 
  "и"};
  
  
String[] objects = {
  "инфракрасное излучение", 
  "смещение парадигмы",
  "ошибку",  "неточность",  "криптонит",  
  "уран",  "йод", "след кальция", 
  "Бога",  "надежду", "любовь", "тебя", "радость", "след арахиса",
  
  "шифровку", "фалафель", "запрещенный стих", 
  "партию наркотиков", "баклажан", "доллар", "секретный материал",
  "черный куб", "два грамма перхоти", "вирус", "воду", "нефть", 
  "укроп"}; 
  
  
  
  
String randomEl(String[] arr){
  return arr[randomI(arr)];
}

int randomI(String[] arr){
  return  (int)random (arr.length);
} 

String genPrhase() {
  
  boolean me_subject = random(1) < 0.5;
  boolean add_place = random(1) < 0.5;
  boolean add_adverb = random(1) < 0.3;
  boolean add_adj =!me_subject && random(1) < 0.5;
  
  int subject_i = randomI(subjects);
  String subject = me_subject ? "Я" : subjects[subject_i];
  if (add_adj){
    subject = randomEl(adj) + " " + subject;
  }
   
  String place = randomEl(places);
  String verb = randomEl(verbs_trans);
  if(add_adverb){
    verb = randomEl(adverbs) +" "+ verb;
  }
  
  if(add_place){
    verb = verb +" "+ place;
  }
  
  String object = randomEl(objects);
  String ctx= " -- " + subject + " " + verb+ " " + object ;
  
  String punch= "";
  if(true){
    boolean add_start = random(1) < 0.5;
    boolean change_verb = random(1) < 0.5;
    boolean change_subj = random(1) < 0.5;
    boolean negate = random(1) < 0.5;
    
    String punch_subj = "ты";
    String punch_obj = subjects_obj[subject_i];
    
    if(me_subject){
      punch_obj="себя";
    }
      
      
    if(change_subj){
      punch_subj=object;
      if(me_subject){
        punch_obj="тебя";
      }else{
        punch_obj=randomEl(objects);
      }
    }
    String punch_verb = verb;
    
    
    if(change_verb){
      punch_verb=randomEl(verbs_trans);
    }
    
    if (negate){
      punch_verb="не "+punch_verb;
    }
    
    punch = punch_subj+" "+punch_verb+" "+punch_obj;
    
    if(add_start){
      punch = randomEl(starts)+" "+punch;      
    }
    
    punch="\n  -- " + punch;
  }
  
  //" -- "+randomEl(starts) +" " + a5 +" "+randomEl(transverb)+" "+randomEl(noun);
  
  return ctx+punch +"\n";
}

void setup(){
  noLoop();
  for(int i=0; i<25; i++){
    String phrz = genPrhase();
    println(phrz);
  }
}
