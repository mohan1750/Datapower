package com.ibm;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class LogUpdatedServices {
	public boolean logEvent(String id,String time,String desc,String old_service,String new_service,String domain, String provider,String uuid) {
		try {
			GetConnection gc=new GetConnection();
			Connection con=gc.getconn();
		
		PreparedStatement stmt=con.prepareStatement("INSERT INTO updated_services(adminid,timestamp,description,current_service,new_service,domain,provider,uuid) VALUES(?,?,?,?,?,?,?,?);");
		stmt.setString(1, id);
		stmt.setString(2, time);
		stmt.setString(3, desc);
		stmt.setString(4, old_service);
		stmt.setString(5, new_service);
		stmt.setString(6, domain);
		stmt.setString(7, provider);
		stmt.setString(8, uuid);
		int res=stmt.executeUpdate();
		if(res !=0) {
			return true;
		}
		else {
			return false;
		}
		}catch(Exception e) {
			System.out.println("Error Storing updated service"+e.getMessage());
			return false;
		}
	}
}
