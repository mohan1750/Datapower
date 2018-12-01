package com.ibm;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class TableCreator {

	public  void createTables() {
		// TODO Auto-generated method stub
		try {
			Class.forName("org.sqlite.JDBC");
			Connection con=DriverManager.getConnection("jdbc:sqlite:Datapower1.db");
			Statement stme=con.createStatement();
			Statement stme2=con.createStatement();
			Statement stme3=con.createStatement();
			ResultSet rs=stme.executeQuery("SELECT name from sqlite_master WHERE type='table' AND name='appliances'");
			ResultSet rs2=stme2.executeQuery("SELECT name from sqlite_master WHERE type='table' AND name='users'");
			//ResultSet rs3=stme3.executeQuery("SELECT name from sqlite_master WHERE type='table' AND name='roles'");
			//System.out.println(rs3.toString());
			if(!rs.next())
			{
				System.out.println("Creating appliances Table");
				Statement stmt2=con.createStatement();
				
				stmt2.execute("CREATE TABLE appliances(name TEXT NOT NULL);");
				System.out.println("Table Created");
				
				
			}
			if(!rs2.next())
			{
				System.out.println("Creating new users Table");
				Statement stmt2=con.createStatement();
				stmt2.execute("CREATE TABLE users(adminid TEXT NOT NULL,firstName TEXT NOT NULL,lastName TEXT,role TEXT NOT NULL,status TEXT,photo BLOB);");
				System.out.println("Table Created");
				
				
			}
			/*if(!rs3.next())
			{
				System.out.println("Creating new connections Table");
				Statement stmt2=con.createStatement();
				stmt2.execute("CREATE TABLE connections(hour integer,percent integer);");
				System.out.println("Table Created");
				
				
			}*/
			con.close();
			
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		

	}
	/*public static void main(String[] args) {
		TableCreator tc= new TableCreator();
		tc.createTables();
	}*/

}
