package com.ibm;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class AddAppliance {
	public int add(String name) {
		GetConnection gc=new GetConnection();
		try {
			Connection con=gc.getconn();
			PreparedStatement stmt=con.prepareStatement("INSERT INTO appliances(name) VALUES(?);");
			stmt.setString(1, name);
			int res=stmt.executeUpdate();
			return res;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return 0;
		} 
	}

}
