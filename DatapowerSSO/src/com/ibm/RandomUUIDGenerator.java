package com.ibm;

public class RandomUUIDGenerator {
	public String getAlphaNumericString() 
    { 
  
        // chose a Character random from this String 
        String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                    + "0123456789"
                                    + "abcdefghijklmnopqrstuvxyz"; 
  
        // create StringBuffer size of AlphaNumericString 
        StringBuilder sb = new StringBuilder(16); 
  
        for (int i = 0; i < 16; i++) { 
  
            // generate a random number between 
            // 0 to AlphaNumericString variable length 
            int index 
                = (int)(AlphaNumericString.length() 
                        * Math.random()); 
  
            // add Character one by one in end of sb 
            sb.append(AlphaNumericString 
                          .charAt(index)); 
        } 
  
        return sb.toString(); 
    }
	/*public static void main(String[] args) 
    { 
		RandomUUIDGenerator tug=new RandomUUIDGenerator();
        // Get the size 16 
        
  
        // Get and display the alphanumeric string 
        System.out.println(tug.getAlphaNumericString()); 
    }*/
}
