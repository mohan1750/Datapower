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

public class XMLManager {
	public List<HashMap<String,String>> getXMLManagers(String domain){
		Client client = ClientBuilder.newClient();
		 SSLUtilities.trustAllHostnames();
			SSLUtilities.trustAllHttpsCertificates();
		
			 Invocation.Builder build=client.target("https://192.168.81.129:5554/mgmt/config/"+domain+"/XMLManager").request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
			 Response response = build.get();
		 		String rs=response.readEntity(String.class);
			//System.out.println(rs);
		 		if(response.getStatus() == 200) {
		 		JSONObject obj = new JSONObject(rs);
		 		List<HashMap<String,String>> l=new ArrayList<HashMap<String,String>>();
		 		//System.out.println(obj.toString());
		 		JSONArray obj2=obj.getJSONArray("XMLManager");
		 		for(int i=0;i<obj2.length();i++)
		 		{
		 			JSONObject temp=obj2.getJSONObject(i);
		 			HashMap<String,String> m=new HashMap<String,String>();
		 			m.put("name", temp.getString("name"));
		 			m.put("state", temp.getString("mAdminState"));
		 			m.put("CacheSize", String.valueOf(temp.getInt("CacheSize")));
		 			m.put("MaxNodeSize", String.valueOf(temp.getLong("ParserLimitsMaxNodeSize")));
		 			m.put("MaxNodeNames", String.valueOf(temp.getLong("ParserLimitsMaxLocalNames")));
		 			JSONObject t=temp.getJSONObject("UserAgent");
		 			m.put("UserAgent", t.getString("value"));
		 			l.add(m);
		 			
		 		}
		 		return l;
		 		
		 		
		 		
		 		
		 		}
		 		return null;
		
	}

}
