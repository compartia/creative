
String[] names = {"John", "Bill", "Еще Кирилица", "Folamerando"};
String[] lnames = {"Smith", "Кирилица", "Bush", "Mc Something"};
String[] genders = {"m", "f", "?"};


String getRandomName(){
  String ret="";
  ret +=genders[(int)random(genders.length)];
  ret += "|";
  ret += names[(int)random(names.length)];
  ret += "|";
  ret += lnames[(int)random(lnames.length)];
  ret += "|";
  ret += "+";
  for (int i=0; i< 7+random(6); i++)
    ret += (int)random(10);
  return ret;
}
