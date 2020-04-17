



int[] hashDigits(String data, int BASE){
  byte[] byteArr = data.getBytes();
  
  String s = new java.math.BigInteger(1, byteArr).toString(BASE);
  
  int reserve = 3;
  int [] ret = new int[reserve+s.length()];
  ret[0]=1;
  ret[1]=2;
  ret[2]=3;
  for (int i =0; i< s.length(); i++){
    ret[i+reserve] = Integer.parseInt(s.substring(i, i+1));
    print(ret[i]);
  }
  return ret;
}
