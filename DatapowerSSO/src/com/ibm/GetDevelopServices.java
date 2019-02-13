package com.ibm;

import java.util.Base64;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.XML;
import org.json.simple.parser.JSONParser;

public class GetDevelopServices {
	public static int PRETTY_PRINT_INDENT_FACTOR = 4;
	public JSONArray getServices(String user,String pass,String host,String domain,String provider) {
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		byte[] b=null;
		try {
		Client client = ClientBuilder.newClient();
			// String post="{\"Domain\": {\"name\": \""+name+"\",\"mAdminState\": \""+admstate+"\",\"NeighborDomain\": {\"value\": \"default\",\"href\": \"/mgmt/config/default/Domain/default\"},\"FileMap\": {\"CopyFrom\": \""+cpyfrom+"\",\"CopyTo\": \""+cpyto+"\",\"Delete\": \""+dlt+"\",\"Display\": \"on\",\"Exec\": \"on\",\"Subdir\": \"on\"},\"MonitoringMap\": {\"Audit\": \"off\",\"Log\": \"off\"},\"ConfigMode\": \"local\",\"ImportFormat\": \"ZIP\",\"LocalIPRewrite\": \"on\",\"MaxChkpoints\": 3}}";
			// System.out.println(post);
		String base64encodedString = "Basic "+Base64.getUrlEncoder().encodeToString((user+":"+pass).getBytes("utf-8"));
				 Invocation.Builder build=client.target("https://"+host+":5554/mgmt/filestore/"+domain+"/local/ondisk/common/config/"+provider+"_Manifest.xml").request(MediaType.APPLICATION_JSON).header("Authorization", base64encodedString);
				 
				 Response response = build.get();
				 String ress=response.readEntity(String.class);
				 //System.out.println("File content: "+ress);
				 JSONParser parser = new JSONParser();
				 if(response.getStatus() == 200)
				 {
					 JSONObject obj = (JSONObject)parser.parse(ress);
					String file=(String) obj.get("file");
					 String xml=new String(Base64.getDecoder().decode(file));
					 org.json.JSONObject xmlJSONObj=XML.toJSONObject(xml);
					 String jsonPrettyPrintString = xmlJSONObj.toString(PRETTY_PRINT_INDENT_FACTOR);
					 JSONObject obj2=(JSONObject) parser.parse(jsonPrettyPrintString);
			            JSONObject obj3=(JSONObject)obj2.get("entries");
			            JSONArray entries=(JSONArray)obj3.get("entry");
			            return entries;
					 /*System.out.println(obj);
					 String file=obj.getString("file");
					 b=Base64.getDecoder().decode(file);
					 String xml=new String(b);
					 JSONObject xmlJSONObj = XML.toJSONObject(xml);
			            String jsonPrettyPrintString = xmlJSONObj.toString(PRETTY_PRINT_INDENT_FACTOR);
			            JSONObject obj2=(JSONObject) parser.parse(jsonPrettyPrintString);
			            JSONObject obj3=obj2.getJSONObject("entries");
			            JSONArray entries=obj3.getJSONArray("entry");
			            return entries;*/
				 }
				 else {
					 return null;
				 }
		}
		catch(Exception e) {
			System.out.println(e.getMessage());
			return null;
		}
	}

}
