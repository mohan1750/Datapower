package com.ibm;

import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.sql.rowset.serial.SerialBlob;
import com.ibm.beans.UserBean;

import sun.misc.BASE64Decoder;

public class RegisterUser {
	public int addUser(UserBean ub) {
		GetConnection gc=new GetConnection();
		try {
			BASE64Decoder decoder = new BASE64Decoder();
		    byte[] imageByte = decoder.decodeBuffer(ub.getPhoto());
			Connection con=gc.getconn();
			PreparedStatement stmt=con.prepareStatement("INSERT INTO users VALUES(?,?,?,?,?,?);");
			stmt.setString(1, ub.getAdminid());
			stmt.setString(2, ub.getFirstName());
			stmt.setString(3, ub.getLastName());
			stmt.setString(4, ub.getRole());
			stmt.setString(5, "pending");
			stmt.setBytes(6, imageByte);
			int res=stmt.executeUpdate();
			return res;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return 0;
		} 
	}

}
