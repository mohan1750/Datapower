package com.ibm;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONObject;

public class CreateService {
	public boolean create(String domain, String provider,String auth,String host,String data) {
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		String payload="{\"LoadConfiguration\":{\"file\":{\"path\": \"/local/ondisk/common/config/"+provider+"_Manifest.xml\",\"content\": \""+data+"\"}}}";
		//System.out.println("Posted Service: "+payload);
		JSONObject js=new JSONObject(payload);
		try {
			Client client = ClientBuilder.newClient();
			 Invocation.Builder build=client.target("https://"+host+":5554/mgmt/actionqueue/"+domain).request(MediaType.APPLICATION_JSON).header("Authorization", auth);
			 Response response=build.post(Entity.entity(payload, MediaType.APPLICATION_JSON));
			 System.out.println("Post response code: "+response.getStatus() instanceof String);
			 if(response.getStatus() == 202) {
				 return true;
			 }
			 else {
				 return false;
			 }
		}
		catch(Exception e) {
			System.out.println(e.getMessage());
		}
		return false;
	}

}
