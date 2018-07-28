package com.eidiko;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONArray;
import org.json.JSONObject;

public class TCPTable {
	public List<HashMap<String,String>> getPorts(){
	 Client client = ClientBuilder.newClient();
	 SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
	
		 Invocation.Builder build=client.target("https://192.168.81.129:5554/mgmt/status/default/TCPTable").request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
		 Response response = build.get();
	 		String rs=response.readEntity(String.class);
		//System.out.println(rs);
	 		if(response.getStatus() == 200) {
	 		JSONObject obj = new JSONObject(rs);
	 		List<HashMap<String,String>> l=new ArrayList<HashMap<String,String>>();
	 		//System.out.println(obj.toString());
	 		JSONArray obj2=obj.getJSONArray("TCPTable");
	 		for(int i=0;i<obj2.length();i++)
	 		{
	 			JSONObject temp=obj2.getJSONObject(i);
	 			HashMap<String,String> m=new HashMap<String,String>();
	 			m.put("localIP", temp.getString("localIP"));
	 			m.put("localPort", String.valueOf(temp.getInt("localPort")));
	 			m.put("remoteIP", temp.getString("remoteIP"));
	 			m.put("remotePort", String.valueOf(temp.getInt("remotePort")));
	 			m.put("state", temp.getString("state"));
	 			m.put("serviceDomain", temp.getString("serviceDomain"));
	 			m.put("serviceClass", temp.getString("serviceClass"));
	 			m.put("serviceName", temp.getString("serviceName"));
	 			l.add(m);
	 			
	 		}
	 		return l;
	 		
	 		
	 		
	 		
	 		}
	 		return null;
	}

}
