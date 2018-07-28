package com.eidiko;

import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

public class RestWebService {

	public static void main(String[] args) throws NoSuchAlgorithmException, KeyManagementException {
		// TODO Auto-generated method stub
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		
		 Client client = ClientBuilder.newClient();
		 String post="{\r\n" + 
		 		"	\"Domain\": {\r\n" + 
		 		"		\"name\": \"NEWDOMAIN\",\r\n" + 
		 		"		\"mAdminState\": \"enabled\",\r\n" + 
		 		"		\"NeighborDomain\": {\r\n" + 
		 		"			\"value\": \"default\",\r\n" + 
		 		"			\"href\": \"/mgmt/config/default/Domain/default\"\r\n" + 
		 		"		},\r\n" + 
		 		"		\"FileMap\": {\r\n" + 
		 		"			\"CopyFrom\": \"on\",\r\n" + 
		 		"			\"CopyTo\": \"on\",\r\n" + 
		 		"			\"Delete\": \"on\",\r\n" + 
		 		"			\"Display\": \"on\",\r\n" + 
		 		"			\"Exec\": \"on\",\r\n" + 
		 		"			\"Subdir\": \"on\"\r\n" + 
		 		"		},\r\n" + 
		 		"		\"MonitoringMap\": {\r\n" + 
		 		"			\"Audit\": \"off\",\r\n" + 
		 		"			\"Log\": \"off\"\r\n" + 
		 		"		},\r\n" + 
		 		"		\"ConfigMode\": \"local\",\r\n" + 
		 		"		\"ImportFormat\": \"ZIP\",\r\n" + 
		 		"		\"LocalIPRewrite\": \"on\",\r\n" + 
		 		"		\"MaxChkpoints\": 3\r\n" + 
		 		"	}\r\n" + 
		 		"}";
		 
		 Invocation.Builder build=client.target("https://192.168.81.129:5554/mgmt/status/default/TCPTable").request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
		 Response response = build.get();
		 Response response1=build.post(Entity.entity(post, MediaType.APPLICATION_JSON));
		 Response response2=build.put(Entity.entity(post, MediaType.APPLICATION_JSON));
		 Response response3=build.delete();
		System.out.println(response.readEntity(String.class));
		
		
	}

}
