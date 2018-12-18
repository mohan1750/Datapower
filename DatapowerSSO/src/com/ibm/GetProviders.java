package com.ibm;

import java.io.UnsupportedEncodingException;
import java.util.Base64;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;


public class GetProviders {
	public JSONObject getProviders(String user,String pass, String host,String domain) {
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		byte[] b=null;
		try {
		Client client = ClientBuilder.newClient();
			// String post="{\"Domain\": {\"name\": \""+name+"\",\"mAdminState\": \""+admstate+"\",\"NeighborDomain\": {\"value\": \"default\",\"href\": \"/mgmt/config/default/Domain/default\"},\"FileMap\": {\"CopyFrom\": \""+cpyfrom+"\",\"CopyTo\": \""+cpyto+"\",\"Delete\": \""+dlt+"\",\"Display\": \"on\",\"Exec\": \"on\",\"Subdir\": \"on\"},\"MonitoringMap\": {\"Audit\": \"off\",\"Log\": \"off\"},\"ConfigMode\": \"local\",\"ImportFormat\": \"ZIP\",\"LocalIPRewrite\": \"on\",\"MaxChkpoints\": 3}}";
			// System.out.println(post);
		String base64encodedString = "Basic "+Base64.getUrlEncoder().encodeToString(
	            (user+":"+pass).getBytes("utf-8"));
				 Invocation.Builder build=client.target("https://"+host+":5554/mgmt/filestore/"+domain+"/local/ondisk/common/config").request(MediaType.APPLICATION_JSON).header("Authorization", base64encodedString);
				 
				 Response response = build.get();
				 String ress=response.readEntity(String.class);
				 JSONParser parser = new JSONParser();
				 
				 //System.out.println(ress.toString());
				 if(response.getStatus() == 200)
				 {
					 JSONObject jo=(JSONObject) parser.parse(ress);
					 return jo;
				 }
				 else {
					 JSONObject jo=(JSONObject) parser.parse(ress);
					 return jo;
				 }
		}
		catch(Exception e) {
			System.out.println(e.getMessage());
			return null;
		}
	}

}
