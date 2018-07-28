package com.eidiko;

import java.io.ByteArrayOutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONObject;

import sun.misc.GC;

public class StatusStorage extends Thread {
	Connection con;
	TableCreator tc=new TableCreator();
	int count1=0;
	int pings1=0;
	int count2=0;
	int pings2=0;
	int count3=0;
	int pings3=0;
	public void run()
	{
		try {
			tc.createTables();
			pings1=+1;
			pings2=+1;
			pings3=+1;
			int res=processCPU();
			int res2=processMemory();
			int res3=storeConns();
			if(res !=-1)
			{
				
				Calendar calendar = Calendar.getInstance();
				int hours = calendar.get(Calendar.HOUR_OF_DAY);
				System.out.println(hours);				
				int minutes = calendar.get(Calendar.MINUTE);
				System.out.println(minutes);
				System.out.println("CPU Load"+res);
				count1=+res;
				
				this.insert(hours, Math.round(count1/pings1),"cpu");
				if(59-minutes==0)
				{
					
					count1=0;
					pings1=0;
						
				}
			}
			else
			{
				pings1=-1;
			}
			if(res2 !=-1)
			{
				
				Calendar calendar = Calendar.getInstance();
				int hours2 = calendar.get(Calendar.HOUR_OF_DAY);
				int minutes2= calendar.get(Calendar.MINUTE);
				System.out.println("Memory Usage "+res2);
				count2=+res2;
				this.insert(hours2, Math.round(count2/pings2),"memory");
				if(59-minutes2==0)
				{
					count2=0;
					pings2=0;
						
				}
			}
			else
			{
				pings2=-1;
			}
			if(res3 !=-1)
			{
				
				Calendar calendar = Calendar.getInstance();
				int hours3 = calendar.get(Calendar.HOUR_OF_DAY);
				int minutes3= calendar.get(Calendar.MINUTE);
				System.out.println("Connections Accepted "+res3);
				count3=+res3;
				this.insert(hours3, Math.round(count3/pings3),"conns");
				if(59-minutes3==0)
				{
					count3=0;
					pings3=0;
						
				}
			}
			else
			{
				pings3=-1;
			}
			Thread.sleep(60*1000);
			this.run();
	 		
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public int processCPU()  throws ClassNotFoundException, SQLException {
		// TODO Auto-generated method stub
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		
		
		 Client client = ClientBuilder.newClient();
		// String post="{\"Domain\": {\"name\": \""+name+"\",\"mAdminState\": \""+admstate+"\",\"NeighborDomain\": {\"value\": \"default\",\"href\": \"/mgmt/config/default/Domain/default\"},\"FileMap\": {\"CopyFrom\": \""+cpyfrom+"\",\"CopyTo\": \""+cpyto+"\",\"Delete\": \""+dlt+"\",\"Display\": \"on\",\"Exec\": \"on\",\"Subdir\": \"on\"},\"MonitoringMap\": {\"Audit\": \"off\",\"Log\": \"off\"},\"ConfigMode\": \"local\",\"ImportFormat\": \"ZIP\",\"LocalIPRewrite\": \"on\",\"MaxChkpoints\": 3}}";
		// System.out.println(post);
		
			 Invocation.Builder build=client.target("https://192.168.81.129:5554/mgmt/status/default/CPUUsage").request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
			 Response response = build.get();
		 		String rs=response.readEntity(String.class);
			//System.out.println(rs);
		 		if(response.getStatus() == 200) {
		 		JSONObject obj = new JSONObject(rs);
		 		//System.out.println(obj.toString());
		 		JSONObject obj2=obj.getJSONObject("CPUUsage");
		 		int res=obj2.getInt("oneMinute");
		 		return res;
		 		
		 		
		 		
		 		}
		 		return -1;

	}
	public int storeConns()  throws ClassNotFoundException, SQLException {
		// TODO Auto-generated method stub
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		
		
		 Client client = ClientBuilder.newClient();
		// String post="{\"Domain\": {\"name\": \""+name+"\",\"mAdminState\": \""+admstate+"\",\"NeighborDomain\": {\"value\": \"default\",\"href\": \"/mgmt/config/default/Domain/default\"},\"FileMap\": {\"CopyFrom\": \""+cpyfrom+"\",\"CopyTo\": \""+cpyto+"\",\"Delete\": \""+dlt+"\",\"Display\": \"on\",\"Exec\": \"on\",\"Subdir\": \"on\"},\"MonitoringMap\": {\"Audit\": \"off\",\"Log\": \"off\"},\"ConfigMode\": \"local\",\"ImportFormat\": \"ZIP\",\"LocalIPRewrite\": \"on\",\"MaxChkpoints\": 3}}";
		// System.out.println(post);
		
			 Invocation.Builder build=client.target("https://192.168.81.129:5554/mgmt/status/default/ConnectionsAccepted").request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
			 Response response = build.get();
		 		String rs=response.readEntity(String.class);
			//System.out.println(rs);
		 		if(response.getStatus() == 200) {
		 		JSONObject obj = new JSONObject(rs);
		 		//System.out.println(obj.toString());
		 		JSONObject obj2=obj.getJSONObject("ConnectionsAccepted");
		 		int res=obj2.getInt("oneMinute");
		 		return res;
		 		
		 		
		 		
		 		}
		 		return -1;

	}
	public int processMemory()  throws ClassNotFoundException, SQLException {
		// TODO Auto-generated method stub
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		
		
		 Client client = ClientBuilder.newClient();
		// String post="{\"Domain\": {\"name\": \""+name+"\",\"mAdminState\": \""+admstate+"\",\"NeighborDomain\": {\"value\": \"default\",\"href\": \"/mgmt/config/default/Domain/default\"},\"FileMap\": {\"CopyFrom\": \""+cpyfrom+"\",\"CopyTo\": \""+cpyto+"\",\"Delete\": \""+dlt+"\",\"Display\": \"on\",\"Exec\": \"on\",\"Subdir\": \"on\"},\"MonitoringMap\": {\"Audit\": \"off\",\"Log\": \"off\"},\"ConfigMode\": \"local\",\"ImportFormat\": \"ZIP\",\"LocalIPRewrite\": \"on\",\"MaxChkpoints\": 3}}";
		// System.out.println(post);
		 ByteArrayOutputStream outputStream = new ByteArrayOutputStream( );
			 Invocation.Builder build=client.target("https://192.168.81.129:5554/mgmt/status/default/MemoryStatus").request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
			 Response response = build.get();
		 		String rs=response.readEntity(String.class);
			//System.out.println(rs);
		 		if(response.getStatus() == 200) {
		 		JSONObject obj = new JSONObject(rs);
		 		//System.out.println(obj.toString());
		 		JSONObject obj2=obj.getJSONObject("MemoryStatus");
		 		int res=obj2.getInt("Usage");
		 		return res;
		 		
		 		
		 		
		 		}
		 		return -1;

	}
	public List<HashMap<String,String>> processMem()  throws ClassNotFoundException, SQLException {
		// TODO Auto-generated method stub
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		
		
		 Client client = ClientBuilder.newClient();
		// String post="{\"Domain\": {\"name\": \""+name+"\",\"mAdminState\": \""+admstate+"\",\"NeighborDomain\": {\"value\": \"default\",\"href\": \"/mgmt/config/default/Domain/default\"},\"FileMap\": {\"CopyFrom\": \""+cpyfrom+"\",\"CopyTo\": \""+cpyto+"\",\"Delete\": \""+dlt+"\",\"Display\": \"on\",\"Exec\": \"on\",\"Subdir\": \"on\"},\"MonitoringMap\": {\"Audit\": \"off\",\"Log\": \"off\"},\"ConfigMode\": \"local\",\"ImportFormat\": \"ZIP\",\"LocalIPRewrite\": \"on\",\"MaxChkpoints\": 3}}";
		// System.out.println(post);
		 ByteArrayOutputStream outputStream = new ByteArrayOutputStream( );
			 Invocation.Builder build=client.target("https://192.168.81.129:5554/mgmt/status/default/MemoryStatus").request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
			 Response response = build.get();
		 		String rs=response.readEntity(String.class);
			//System.out.println(rs);
		 		if(response.getStatus() == 200) {
		 		JSONObject obj = new JSONObject(rs);
		 		//System.out.println(obj.toString());
		 		JSONObject obj2=obj.getJSONObject("MemoryStatus");
		 		long used=obj2.getLong("UsedMemory");
		 		long free=obj2.getLong("FreeMemory");
		 		long hold=obj2.getLong("HoldMemory");
		 		long reserv=obj2.getLong("ReservedMemory");
		 		List<String> l=new ArrayList<String>();
		 		List<String> l2=new ArrayList<String>();
		 		l.add("UsedMemory");l.add("FreeMemory");l.add("HoldMemory");l.add("ReservedMemory");
		 		l2.add(String.valueOf(used*1000));l2.add(String.valueOf(free*1000));l2.add(String.valueOf(hold*1000));l2.add(String.valueOf(reserv*1000));
		 		List<HashMap<String,String>> ll=new ArrayList<HashMap<String,String>>();
		 		for(int i=0;i<l.size();i++)
		 		{
		 			HashMap<String,String> m=new HashMap<String,String>();
		 			m.put("label", l.get(i));
		 			m.put("value", l2.get(i));
		 			ll.add(m);
		 		}
		 		return ll;
		 		
		 		
		 		
		 		}
		 		return null;

	}
	public List<HashMap<String,String>> processFilesSystem()  throws ClassNotFoundException, SQLException {
		// TODO Auto-generated method stub
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		
		
		 Client client = ClientBuilder.newClient();
		// String post="{\"Domain\": {\"name\": \""+name+"\",\"mAdminState\": \""+admstate+"\",\"NeighborDomain\": {\"value\": \"default\",\"href\": \"/mgmt/config/default/Domain/default\"},\"FileMap\": {\"CopyFrom\": \""+cpyfrom+"\",\"CopyTo\": \""+cpyto+"\",\"Delete\": \""+dlt+"\",\"Display\": \"on\",\"Exec\": \"on\",\"Subdir\": \"on\"},\"MonitoringMap\": {\"Audit\": \"off\",\"Log\": \"off\"},\"ConfigMode\": \"local\",\"ImportFormat\": \"ZIP\",\"LocalIPRewrite\": \"on\",\"MaxChkpoints\": 3}}";
		// System.out.println(post);
		 ByteArrayOutputStream outputStream = new ByteArrayOutputStream( );
			 Invocation.Builder build=client.target("https://192.168.81.129:5554/mgmt/status/default/FilesystemStatus").request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
			 Response response = build.get();
		 		String rs=response.readEntity(String.class);
			//System.out.println(rs);
		 		if(response.getStatus() == 200) {
		 		JSONObject obj = new JSONObject(rs);
		 		//System.out.println(obj.toString());
		 		JSONObject obj2=obj.getJSONObject("FilesystemStatus");
		 		long freeenc=obj2.getLong("FreeEncrypted");
		 		long totalenc=obj2.getLong("TotalEncrypted");
		 		long freetemp=obj2.getLong("FreeTemporary");
		 		long totaltemp=obj2.getLong("TotalTemporary");
		 		long freeint=obj2.getLong("FreeInternal");
		 		long totalint=obj2.getLong("TotalInternal");
		 		List<String> l=new ArrayList<String>();
		 		List<String> l2=new ArrayList<String>();
		 		l.add("FreeEncrypted");l.add("TotalEncrypted");l.add("FreeTemporary");l.add("TotalTemporary");l.add("FreeInternal");l.add("TotalInternal");
		 		l2.add(String.valueOf(freeenc*1000*1000));l2.add(String.valueOf(totalenc*1000*1000));l2.add(String.valueOf(freetemp*1000*1000));l2.add(String.valueOf(totaltemp*1000*1000));l2.add(String.valueOf(freeint*1000*1000));l2.add(String.valueOf(totalint*1000*1000));
		 		List<HashMap<String,String>> ll=new ArrayList<HashMap<String,String>>();
		 		for(int i=0;i<l.size();i++)
		 		{
		 			HashMap<String,String> m=new HashMap<String,String>();
		 			m.put("label", l.get(i));
		 			m.put("value", l2.get(i));
		 			ll.add(m);
		 		}
		 		return ll;
		 		
		 		
		 		
		 		}
		 		return null;

	}
	public void insert(int hour,int rate,String type) 
	{
		PreparedStatement stmt;
		try {
		if(type=="cpu")
		{
			Connection conss=this.getConn();
			stmt=conss.prepareStatement("INSERT INTO cpu VALUES(?,?);");
			stmt.setInt(1, hour);
			stmt.setInt(2, rate);
			stmt.execute();
			conss.close();
		}
		if(type=="conns")
		{
			Connection conss=this.getConn();
			stmt=this.getConn().prepareStatement("INSERT INTO connections VALUES(?,?);");
			stmt.setInt(1, hour);
			stmt.setInt(2, rate);
			stmt.execute();
			conss.close();
		}
		if(type=="memory")
		{
			Connection conss=this.getConn();
			stmt=this.getConn().prepareStatement("INSERT INTO memory VALUES(?,?);");
			stmt.setInt(1, hour);
			stmt.setInt(2, rate);
			System.out.println("Stored value:"+rate);
			stmt.execute();
			displayStats("memory");
			conss.close();
		
		}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	public List<HashMap<String,String>> displayStats(String table) throws SQLException, ClassNotFoundException
	{
		Connection conss=this.getConn();
		Statement stmt=conss.createStatement();
		System.out.println("Started");
		ResultSet rs2=stmt.executeQuery("SELECT hour,avg(percent) FROM "+table+" GROUP BY hour");
		List<HashMap<String,String>> list=new ArrayList<HashMap<String,String>>();
		
		while(rs2.next())
		{
			HashMap<String,String> m=new HashMap<String,String>();
			m.put("label", String.valueOf(rs2.getInt("hour"))+":00");
			m.put("value", String.valueOf(rs2.getInt(2))+"%");
			list.add(m);
		}
		conss.close();
		return list;
		
	}
	
	public Connection getConn() throws ClassNotFoundException, SQLException
	{
		Class.forName("org.sqlite.JDBC");
		
		Connection con=DriverManager.getConnection("jdbc:sqlite:Datapower.db");		
		
		
		return con;
		
	}
	public void destroy()
	{
		try {
			con.commit();
			con.close();
			System.gc();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
