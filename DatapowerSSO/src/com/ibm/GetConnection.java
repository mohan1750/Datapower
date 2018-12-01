package com.ibm;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class GetConnection {
	public Connection getconn() throws ClassNotFoundException, SQLException {
		Class.forName("org.sqlite.JDBC");
		
		Connection con=DriverManager.getConnection("jdbc:sqlite:Datapower1.db");
		
		TableCreator tc=new TableCreator();
		tc.createTables();
		return con;
		
	}

}
