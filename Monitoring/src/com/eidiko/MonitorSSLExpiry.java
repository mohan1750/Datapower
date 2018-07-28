package com.eidiko;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONObject;

public class MonitorSSLExpiry extends Thread {
	private String dphost;
	private String dpport;
	public MonitorSSLExpiry(String dphost, String dpport)
	{
		this.dphost=dphost;
		this.dpport=dpport;
	}
	public void run()
	{
		try {
			checkSSLExpiry(dphost,dpport);
			Thread.sleep(60*1000);
			this.run();
		}
		catch(Exception e) {
			System.out.println(e.getMessage());
		}
	}
	public void checkSSLExpiry(String dphost,String dpport) throws IOException, AddressException, MessagingException{
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		String[] files= {"default-log","default-log.1","default-log.2","default-log.3"};
		
		 Client client = ClientBuilder.newClient();
		// String post="{\"Domain\": {\"name\": \""+name+"\",\"mAdminState\": \""+admstate+"\",\"NeighborDomain\": {\"value\": \"default\",\"href\": \"/mgmt/config/default/Domain/default\"},\"FileMap\": {\"CopyFrom\": \""+cpyfrom+"\",\"CopyTo\": \""+cpyto+"\",\"Delete\": \""+dlt+"\",\"Display\": \"on\",\"Exec\": \"on\",\"Subdir\": \"on\"},\"MonitoringMap\": {\"Audit\": \"off\",\"Log\": \"off\"},\"ConfigMode\": \"local\",\"ImportFormat\": \"ZIP\",\"LocalIPRewrite\": \"on\",\"MaxChkpoints\": 3}}";
		// System.out.println(post);
		 ByteArrayOutputStream outputStream = new ByteArrayOutputStream( );
		 for(int i=0;i<files.length;i++)
		 {
			 Invocation.Builder build=client.target("https://"+dphost+":"+dpport+"/mgmt/filestore/default/logtemp/"+files[i]).request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
				// Response response=build.post(Entity.entity(post, MediaType.APPLICATION_JSON));
			 		Response response = build.get();
			 		String rs=response.readEntity(String.class);
				//System.out.println(rs);
			 		if(response.getStatus() == 200) {
			 		JSONObject obj = new JSONObject(rs);
			 		//System.out.println(obj.toString());
			 		String res=obj.getString("file");
			 		//System.out.println(res);
			 		byte[] stream=Base64.getDecoder().decode(res);
			 		outputStream.write(stream);
			 		}			 		//System.out.println(stream.length);
		 }
		 //System.out.println(outputStream.toByteArray().length);
		 List<String> result=Arrays.asList(outputStream.toString("UTF-8").split("\\n"));
		 List<String> out=new ArrayList<String>();
		 for(int i=0;i<result.size();i++)
		 {
			 
			 if(result.get(i).contains("0x806000e1"))
			 {
			
				 TrustManager[] trustAllCerts = new TrustManager[]{
						 new X509TrustManager() {
						     public java.security.cert.X509Certificate[] getAcceptedIssuers() {
						         return null;
						     }
						     public void checkClientTrusted(
						         java.security.cert.X509Certificate[] certs, String authType) {
						     }
						     public void checkServerTrusted(
						         java.security.cert.X509Certificate[] certs, String authType) {
						     }
						 }};

						    try {
						     SSLContext sc = SSLContext.getInstance("SSL");
						     sc.init(null, trustAllCerts, new java.security.SecureRandom());
						     HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
						     } catch (Exception e) {
						     }
				 
				 
				 
				 String emailid="nagamohan.borra@gmail.com";

				 String myname="Datapower Admin";

				 String host="", user="", pass="";

				 host ="smtp.gmail.com"; //"smtp.gmail.com";

				 user ="nagamohan.eidiko@gmail.com"; //"YourEmailId@gmail.com" // email id to send the emails

				 pass ="mohan@1750"; //Your gmail password

				 String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";

				 String to =emailid; // out going email id

				 String from ="admin@datapower.com"; //Email id of the recipient
				 String subject="SSL Cert Expiration ALert";
				 //String subject ="welcome";

				 String messageText =result.get(i);
				 boolean sessionDebug = true;

				 Properties props = System.getProperties();
				 props.put("mail.host", host);
				 props.put("mail.transport.protocol.", "smtp");
				 props.put("mail.smtp.auth", "true");
				 props.put("mail.smtp.", "true");
				 props.put("mail.smtp.port", "465");
				 props.put("mail.smtp.socketFactory.fallback", "false");
				 props.put("mail.smtp.socketFactory.class", SSL_FACTORY);
				 Session mailSession = Session.getDefaultInstance(props, null);
				 mailSession.setDebug(sessionDebug);
				 Message msg = new MimeMessage(mailSession);
				 msg.setFrom(new InternetAddress(from));
				 InternetAddress[] address = {new InternetAddress(to)};
				 msg.setRecipients(Message.RecipientType.TO, address);
				 msg.setSubject(subject);
				 msg.setContent(messageText, "text/html"); // use setText if you want to send text
				 Transport transport = mailSession.getTransport("smtp");
				 transport.connect(host, user, pass);
				 try {
				 transport.sendMessage(msg, msg.getAllRecipients());
				 System.out.println("alert successfully sent"); }
				 catch(Exception e) {
					 System.out.println("failed to send alert"); // assume it was sent
				 }
				}
				
			 }
			 
		 }
		// System.out.println(out);	 
	public void destroy()
	{
		try {
			System.gc();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

