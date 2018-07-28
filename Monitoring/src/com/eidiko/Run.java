package com.eidiko;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class Run {

	public static void main(String[] args) throws IOException, InterruptedException {
		// TODO Auto-generated method stub
	Runtime rt = Runtime.getRuntime();
	    
	Process clientProcess = rt.exec(" cmd /k C:/Users/bandaru/Desktop/process.bat");
	
	 /*ProcessBuilder pb = new ProcessBuilder();
	 
	 List<String> l=new ArrayList<String>();
	 l.add("set ANT_HOME %cd%/apache-ant-1.9.9");
	 l.add("ant -f deploy.ant.xml -Dhost=192.168.3.161 -Duid=admin -Dpwd=sarasu10 -Ddomain=rajesh123 domain-create save");
	 pb.command(l);
	// pb.directory(new File("datapower-configuration-manager-master"));
	 Process p = pb.start();*/
	 
	 //System.out.println(p.getOutputStream());
	 
	 
	}

}
