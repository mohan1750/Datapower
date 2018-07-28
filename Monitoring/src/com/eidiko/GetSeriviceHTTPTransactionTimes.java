package com.eidiko;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONArray;
import org.json.JSONObject;

public class GetSeriviceHTTPTransactionTimes {
	public List<Map<String,String>> getTransactions(String domain,String duration,String host,String port)
	{
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		List<Map<String,String>> tx=new ArrayList<Map<String,String>>();
		Client client = ClientBuilder.newClient();
		 Invocation.Builder build=client.target("https://"+host+":"+port+"/mgmt/status/"+domain+"/HTTPMeanTransactionTime2").request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
		Response response=build.get();
		String rs=response.readEntity(String.class);
		if(response.getStatus()==200)
		{
			JSONObject obj = new JSONObject(rs);
			JSONArray arr=obj.getJSONArray("HTTPMeanTransactionTime2");
			for(int i=0;i<arr.length();i++)
			{
				JSONObject obj1 = arr.getJSONObject(i);
				Map<String,String> m=new HashMap<String,String>();
				m.put("label", obj1.getString("proxy"));
				m.put("value", String.valueOf(obj1.getInt(duration)));
				tx.add(m);
			}
			return tx;
		}
		else
		{
			return null;
		}
	}

}
