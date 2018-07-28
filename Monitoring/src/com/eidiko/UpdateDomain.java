package com.eidiko;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

public class UpdateDomain {
	public int updateDomain(String name,String admstate,String cpyfrom,String cpyto,String dlt,String host,String port)
	{
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		
		 Client client = ClientBuilder.newClient();
		 String post="{\"Domain\": {\"name\": \""+name+"\",\"mAdminState\": \""+admstate+"\",\"FileMap\": {\"CopyFrom\": \""+cpyfrom+"\",\"CopyTo\": \""+cpyto+"\",\"Delete\": \""+dlt+"\",\"Display\": \"on\",\"Exec\": \"on\",\"Subdir\": \"on\"},\"MonitoringMap\": {\"Audit\": \"off\",\"Log\": \"off\"}}}";
		 System.out.println(post);
		 Invocation.Builder build=client.target("https://"+host+":"+port+"/mgmt/config/default/Domain/"+name).request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
		 Response response=build.put(Entity.entity(post, MediaType.APPLICATION_JSON));
		System.out.println(response.readEntity(String.class));
		return  response.getStatus();
	}

}
