package com.ibm;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
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
			Statement stme4=con.createStatement();
			ResultSet rs=stme.executeQuery("SELECT name from sqlite_master WHERE type='table' AND name='appliances'");
			ResultSet rs2=stme2.executeQuery("SELECT name from sqlite_master WHERE type='table' AND name='users'");
			ResultSet rs3= stme3.executeQuery("SELECT name from sqlite_master WHERE type='table' AND name='deleted_services'");
			ResultSet rs4= stme4.executeQuery("SELECT name from sqlite_master WHERE type='table' AND name='updated_services'");
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
			if(!rs3.next())
			{
				System.out.println("Creating new deleted services Table");
				Statement stmt2=con.createStatement();
				stmt2.execute("CREATE TABLE deleted_services(adminid TEXT NOT NULL,timestamp TEXT NOT NULL,description TEXT,service TEXT NOT NULL,domain TEXT NOT NULL,provider TEXT NOT NULL);");
				System.out.println("Table Created");
				
				
			}
			if(!rs4.next())
			{
				System.out.println("Creating new updated services Table");
				Statement stmt3=con.createStatement();
				stmt3.execute("CREATE TABLE updated_services(adminid TEXT NOT NULL,timestamp TEXT,description TEXT,current_service TEXT,new_service TEXT,domain TEXT NOT NULL,provider TEXT NOT NULL,uuid TEXT NOT NULL);");
				System.out.println("Table Created");
				
				
			}
			else {
				System.out.println("Tables already exists");
			}
			con.close();
			
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		

	}
	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		TableCreator tc= new TableCreator();
		//tc.createTables();
		Class.forName("org.sqlite.JDBC");
		Connection con=DriverManager.getConnection("jdbc:sqlite:Datapower1.db");
		Statement stmt2=con.createStatement();
		stmt2.execute("DROP TABLE updated_services;");
	}

}
