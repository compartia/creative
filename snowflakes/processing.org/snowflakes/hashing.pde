
String convertStringToBase(String data, int BASE){
  
  try{
    byte[] byteArr = data.getBytes("UTF-8");   
    String s = new java.math.BigInteger(1, byteArr).toString(BASE);
    return s;
  }
  catch(Exception ex){}    
  return "000000"; 
}


String restoreData(String s){
  java.math.BigInteger bi = new java.math.BigInteger(s , BASE);
  byte[] barr = bi.toByteArray();
  
  try{
    return (new String(barr, "UTF-8"));    
  }
  catch(Exception ex){
     return "";  
  }  
 
}


int[] hashDigits(String data, int BASE){
  String s = convertStringToBase(  data,  BASE);
  
  int [] ret = new int[ s.length()];
 
  for (int i =0; i< s.length(); i++){
    ret[i] = Integer.parseInt(s.substring(i, i+1));
    print(ret[i]);
  }
  
  return ret;
}
