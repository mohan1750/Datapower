package com.ibm;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.ibm.beans.UserBean;

import sun.misc.BASE64Decoder;
import sun.misc.IOUtils;

public class GetUser {
	public UserBean getUser(String id) {
		GetConnection gc=new GetConnection();
		String selectSQL = "SELECT * FROM users WHERE adminid=?";
		OutputStream fos = null;
		UserBean ub=new UserBean();
		try {
			Connection con=gc.getconn();
			PreparedStatement stmt=con.prepareStatement(selectSQL);
			stmt.setString(1, id);
			
			ResultSet rs =stmt.executeQuery();
			while (rs.next()) {
                InputStream input = (ByteArrayInputStream)rs.getBinaryStream("photo");
                ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                int nRead;
                byte[] data = new byte[1024];
                while ((nRead = input.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, nRead);
                }
             
                buffer.flush();
                byte[] byteArray = buffer.toByteArray();
                     
                String text = new String(byteArray, StandardCharsets.UTF_8);
                ub.setPhoto(text);
                ub.setAdminid(rs.getString("adminid"));
                ub.setFirstName(rs.getString("firstName"));
                ub.setLastName(rs.getString("lastName"));
                ub.setRole(rs.getString("role"));
                
			
		}
			return ub;
			} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		} 
	}

}
