package com.eidiko;

import java.util.Base64;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONObject;

public class GetFile {
	public byte[] getFile(String domain,String host,String port,String rport,String name,String location)
	{
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		byte[] b=null;
		Client client = ClientBuilder.newClient();
			// String post="{\"Domain\": {\"name\": \""+name+"\",\"mAdminState\": \""+admstate+"\",\"NeighborDomain\": {\"value\": \"default\",\"href\": \"/mgmt/config/default/Domain/default\"},\"FileMap\": {\"CopyFrom\": \""+cpyfrom+"\",\"CopyTo\": \""+cpyto+"\",\"Delete\": \""+dlt+"\",\"Display\": \"on\",\"Exec\": \"on\",\"Subdir\": \"on\"},\"MonitoringMap\": {\"Audit\": \"off\",\"Log\": \"off\"},\"ConfigMode\": \"local\",\"ImportFormat\": \"ZIP\",\"LocalIPRewrite\": \"on\",\"MaxChkpoints\": 3}}";
			// System.out.println(post);
				 Invocation.Builder build=client.target("https://"+host+":"+rport+"/mgmt/filestore/"+domain+"/"+location+"/"+name).request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
				 
				 Response response = build.get();
				 String ress=response.readEntity(String.class);
				 System.out.println(ress.toString());
				 if(response.getStatus() == 200)
				 {
					 JSONObject obj = new JSONObject(ress);
					 System.out.println(obj);
					 String file=obj.getString("file");
					 b=Base64.getDecoder().decode(file);
				 }
		
		return b;
		 
	}

}
