package com.eidiko;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONObject;

public class SearchLogs {
	public List<String> search(String domain,String str,String level,String filter,String host,String port) throws IOException{
		SSLUtilities.trustAllHostnames();
		SSLUtilities.trustAllHttpsCertificates();
		String[] files= {"default-log","default-log.1","default-log.2","default-log.3"};
		
		 Client client = ClientBuilder.newClient();
		// String post="{\"Domain\": {\"name\": \""+name+"\",\"mAdminState\": \""+admstate+"\",\"NeighborDomain\": {\"value\": \"default\",\"href\": \"/mgmt/config/default/Domain/default\"},\"FileMap\": {\"CopyFrom\": \""+cpyfrom+"\",\"CopyTo\": \""+cpyto+"\",\"Delete\": \""+dlt+"\",\"Display\": \"on\",\"Exec\": \"on\",\"Subdir\": \"on\"},\"MonitoringMap\": {\"Audit\": \"off\",\"Log\": \"off\"},\"ConfigMode\": \"local\",\"ImportFormat\": \"ZIP\",\"LocalIPRewrite\": \"on\",\"MaxChkpoints\": 3}}";
		// System.out.println(post);
		 ByteArrayOutputStream outputStream = new ByteArrayOutputStream( );
		 for(int i=0;i<files.length;i++)
		 {
			 Invocation.Builder build=client.target("https://"+host+":"+port+"/mgmt/filestore/"+domain+"/logtemp/"+files[i]).request(MediaType.APPLICATION_JSON).header("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
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
			 
			 if(result.get(i).contains(str)&&(result.get(i).indexOf(level)<result.get(i).length()/2)&&result.get(i).contains(level)&&str!="")
			 {
				switch(filter)
				{
				case "All":out.add(result.get(i));
						   break;
				case "Today": 								 
								 int date=Integer.parseInt(result.get(i).substring(6,8));
								 int month=Integer.parseInt(result.get(i).substring(4,6));
								 int year=Integer.parseInt(result.get(i).substring(0,4));
								 Calendar calendar = new GregorianCalendar();
								 int sysdate=calendar.get(Calendar.DAY_OF_MONTH);
								 int sysmonth=calendar.get(Calendar.MONTH);
								 int sysyear=calendar.get(Calendar.YEAR);
								// System.out.println(date+" "+month+" "+year);
								// System.out.println(sysdate+" "+sysmonth+" "+sysyear);
					 			 if(date==sysdate && month==sysmonth+1 && year==sysyear)
					 			 {
					 				out.add(result.get(i));
					 				System.out.println(result.get(i));
					 			 }
							
							 
				 			 break;
				case "1Hour": Calendar calendar2 = new GregorianCalendar();
				 				int syshour=calendar2.get(Calendar.HOUR_OF_DAY);
				 				int sysmin=calendar2.get(Calendar.MINUTE);
				 				int syssec=calendar2.get(Calendar.SECOND);
				 				int sysdate1=calendar2.get(Calendar.DAY_OF_MONTH);
								 int sysmonth1=calendar2.get(Calendar.MONTH);
								 int sysyear1=calendar2.get(Calendar.YEAR);
								 Calendar calendar3 = new GregorianCalendar(sysdate1,sysmonth1,sysyear1,syshour,sysmin,syssec);
				 				int hour=Integer.parseInt(result.get(i).substring(9,11));
				 				int min=Integer.parseInt(result.get(i).substring(11,13));
				 				int sec=Integer.parseInt(result.get(i).substring(13,15));
				 				int date1=Integer.parseInt(result.get(i).substring(6,8));
								 int month1=Integer.parseInt(result.get(i).substring(4,6));
								 int year1=Integer.parseInt(result.get(i).substring(0,4));
								 Calendar calendar4 = new GregorianCalendar(date1,month1,year1,hour,min,sec); 
								 calendar4.add(Calendar.MINUTE, 330);
								 
								 int diff = ((syshour-calendar4.get(Calendar.HOUR_OF_DAY))*60)+(sysmin-calendar4.get(Calendar.MINUTE));
								// System.out.println(syshour+" "+sysmin+" "+syssec);
								// System.out.println(hour+" "+min+" "+sec);
								 if(date1==sysdate1 && month1==sysmonth1+1 && year1==sysyear1) {
				 				if((diff <= 60)&& (diff >=0))
				 				{
				 					//System.out.println(diff);
				 					out.add(result.get(i));
				 				}}
				 				break;
				case "10 Mins": Calendar calendar21 = new GregorianCalendar();
 								int syshour1=calendar21.get(Calendar.HOUR_OF_DAY);
 								int sysmin1=calendar21.get(Calendar.MINUTE);
 								int syssec1=calendar21.get(Calendar.SECOND);
 								int sysdate11=calendar21.get(Calendar.DAY_OF_MONTH);
 								int sysmonth11=calendar21.get(Calendar.MONTH);	
 								int sysyear11=calendar21.get(Calendar.YEAR);
 								Calendar calendar31 = new GregorianCalendar(sysdate11,sysmonth11,sysyear11,syshour1,sysmin1,syssec1);
 								int hour1=Integer.parseInt(result.get(i).substring(9,11)); 								
 								int min1=Integer.parseInt(result.get(i).substring(11,13));
 								int sec1=Integer.parseInt(result.get(i).substring(13,15));
 								int date11=Integer.parseInt(result.get(i).substring(6,8));
 								int month11=Integer.parseInt(result.get(i).substring(4,6));
 								int year11=Integer.parseInt(result.get(i).substring(0,4));
 								Calendar calendar41 = new GregorianCalendar(date11,month11,year11,hour1,min1,sec1); 
 								calendar41.add(Calendar.MINUTE, 330);
 								int diff1 = ((syshour1-calendar41.get(Calendar.HOUR_OF_DAY))*60)+(sysmin1-calendar41.get(Calendar.MINUTE));
 								if(date11==sysdate11 && month11==sysmonth11+1 && year11==sysyear11) {
 								if((diff1 <= 10)&& (diff1 >=0))
 								{
 									result.get(i).replace(String.valueOf(hour1)+String.valueOf(min1)+String.valueOf(sec1),String.valueOf(calendar41.get(Calendar.HOUR_OF_DAY))+String.valueOf(calendar41.get(Calendar.MINUTE))+String.valueOf(calendar41.get(Calendar.SECOND)));
 									out.add(result.get(i));
 									
 									
 								}}
 								break;
				 
				}
				
			 }
			 
		 }
		// System.out.println(out);
		 Collections.reverse(out);
		 return out;
		 
		 
		 
	}

}
