/**
TODO: add checksum!
TODO: add in-middle checksum;
*/
String ENCODING="UTF-8";

/**
converts given data into a BASE-encoded string
BASE: 2 for binary
data: any string
*/
String convertStringToBase(String data, int BASE){
  String prefix="";
  for (int k=BASE-1; k>=0; k-- ){
    prefix+=k;
  }
  try{
    byte[] byteArr = data.getBytes(ENCODING);   
    String s = new java.math.BigInteger(1, byteArr).toString(BASE);
    //TODO: pad string with leading zeros
    return prefix + s;
  }
  catch(Exception ex){
    return "000000";
  }    
   
}


String restoreData(String s, int BASE){
  java.math.BigInteger bi = new java.math.BigInteger(s.substring(BASE-1) , BASE);
  byte[] barr = bi.toByteArray();
  
  try{
    return (new String(barr, ENCODING));    
  }
  catch(Exception ex){
     return "error";  
  }  
 
}


int[] hashDigits(String data, int BASE){
  String s = convertStringToBase(  data,  BASE);
  
  int [] ret = new int[ s.length()];
 
  for (int i =0; i< s.length(); i++){
    ret[i] = Integer.parseInt(s.substring(i, i+1));     
  }
  
  return ret;
}



void testHashing(){
  String s = "this is the test string, с кириллицей и радостями";
  String encoded = convertStringToBase(s, BASE);
  println("encoded", encoded);
  String restored = restoreData(encoded, BASE);
  println("restored", restored);
  
  if(!restored.equals(s)){
    println("restored is not equal to original!!", restored);
    throw new IllegalStateException();
  }
  
}
