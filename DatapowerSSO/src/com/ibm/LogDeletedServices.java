package com.ibm;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class LogDeletedServices{
	public boolean logEvent(String id,String time,String desc,String service,String domain, String provider) {
		try {
			GetConnection gc=new GetConnection();
		Connection con=gc.getconn();
		PreparedStatement stmt=con.prepareStatement("INSERT INTO deleted_services(adminid,timestamp,description,service,domain,provider) VALUES(?,?,?,?,?,?);");
		stmt.setString(1, id);
		stmt.setString(2, time);
		stmt.setString(3, desc);
		stmt.setString(4, service);
		stmt.setString(5, domain);
		stmt.setString(6, provider);
		int res=stmt.executeUpdate();
		if(res !=0) {
			return true;
		}
		else {
			return false;
		}
		}catch(Exception e) {
			System.out.println("Error Storing deleted service"+e.getMessage());
			return false;
		}
	}
	
}