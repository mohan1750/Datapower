package com.ibm;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class Appliances {
	public List<String> getAppliances(){
		GetConnection gc=new GetConnection();
		try {
			Connection con=gc.getconn();
			Statement stmt=con.createStatement();
			ResultSet rs=stmt.executeQuery("SELECT name FROM appliances");
			List<String> list=new ArrayList<String>();
			while(rs.next())
			{
				list.add(rs.getString("name"));
				
			}
			return list;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		} 
	}

}
