package com.eidiko;

import java.io.ByteArrayOutputStream;
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

public class GetCryptoObjects {

	public List<HashMap<String,String>> getCrypto(String domain,String host,String port) {
		// TODO Auto-generated method stub
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		
		
		 Client client = ClientBuilder.newClient();
		// String post="{\"Domain\": {\"name\": \""+name+"\",\"mAdminState\": \""+admstate+"\",\"NeighborDomain\": {\"value\": \"default\",\"href\": \"/mgmt/config/default/Domain/default\"},\"FileMap\": {\"CopyFrom\": \""+cpyfrom+"\",\"CopyTo\": \""+cpyto+"\",\"Delete\": \""+dlt+"\",\"Display\": \"on\",\"Exec\": \"on\",\"Subdir\": \"on\"},\"MonitoringMap\": {\"Audit\": \"off\",\"Log\": \"off\"},\"ConfigMode\": \"local\",\"ImportFormat\": \"ZIP\",\"LocalIPRewrite\": \"on\",\"MaxChkpoints\": 3}}";
		// System.out.println(post);
			 Invocation.Builder build=client.target("https://"+host+":"+port+"/mgmt/config/"+domain+"/CryptoCertificate").request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
			 Invocation.Builder build2=client.target("https://"+host+":"+port+"/mgmt/config/"+domain+"/CryptoKey").request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
			 Response response = build.get();
			 Response response2 = build2.get();
		 		String rs=response.readEntity(String.class);
		 		String rs2=response2.readEntity(String.class);
		 		List<HashMap<String,String>> ls=new ArrayList<HashMap<String,String>>();
		 		if(response.getStatus() == 200) {
			 		JSONObject obj = new JSONObject(rs);
			 		//System.out.println(obj.toString());
			 		JSONArray obj2=obj.getJSONArray("CryptoCertificate");
			 		
			 		for(int i=0;i<obj2.length();i++)
			 		{
			 			JSONObject temp =obj2.getJSONObject(i);
			 			String name=temp.getString("name");
			 			String fname=temp.getString("Filename");
			 			HashMap<String,String> m=new HashMap<String,String>();
			 			m.put("name", name);
			 			m.put("classname", "CryptoCertificate");
			 			m.put("display", "Crypto Certificate");
			 			m.put("fname", fname);
			 			ls.add(m);
			 			
			 		}
		 		}
		 		
		 		if(response2.getStatus() == 200) {
			 		JSONObject obj = new JSONObject(rs2);
			 		//System.out.println(obj.toString());
			 		JSONArray obj2=obj.getJSONArray("CryptoKey");
			 		for(int i=0;i<obj2.length();i++)
			 		{
			 			JSONObject temp =obj2.getJSONObject(i);
			 			String name=temp.getString("name");
			 			String fname=temp.getString("Filename");
			 			HashMap<String,String> m=new HashMap<String,String>();
			 			m.put("name", name);
			 			m.put("classname", "CryptoKey");
			 			m.put("display", "Crypto Key");
			 			m.put("fname", fname);
			 			ls.add(m);
			 			
			 		}
		 		}
		 		return ls;

	}

}
