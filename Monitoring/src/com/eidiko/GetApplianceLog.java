package com.eidiko;

import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;

import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.NodeList;

public class GetApplianceLog {
	
	public List<Map<String,String>> getLogs(String host,String port)
	{
		
		try {
			SSLUtilities.trustAllHostnames();
			SSLUtilities.trustAllHttpsCertificates();
	        // Create SOAP Connection
	    SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
	    SOAPConnection soapConnection = soapConnectionFactory
	                    .createConnection();

	    URL url = new URL("https://"+host+":"+port+"/service/mgmt/amp/3.0");
	            // String url =
	            // "http://192.168.2.119/DISWebService/DISWebService.asmx?op=LoginSystem";

	            SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(),url);
	            NodeList nl=soapResponse.getSOAPPart().getEnvelope().getBody().getFirstChild().getFirstChild().getChildNodes();
	            soapResponse.writeTo(System.out);
	            List<Map<String,String>> log=new ArrayList<Map<String,String>>();
	            Map<String,String> m;
	            for(int i=0; i<nl.getLength();i++)
	            {
	            	m=new HashMap<String,String>();
	            	NamedNodeMap nnm=nl.item(i).getAttributes();
	            	m.put("domain", nl.item(i).getFirstChild().getFirstChild().getTextContent());
	            	m.put("creationTime", nnm.getNamedItem("creationTime").getTextContent());
	            	m.put("message", nnm.getNamedItem("msg").getTextContent());
	            	System.out.println(nnm.getNamedItem("creationTime")+","+nnm.getNamedItem("msg"));
	            	
	            System.out.println("Domain" +": "+nl.item(i).getFirstChild().getFirstChild().getTextContent());
	            log.add(m);
	            }
	            
	            soapConnection.close();
	            return log;
	        } catch (Exception e) {
	            System.err
	                    .println("Error occurred while sending SOAP Request to Server");
	            e.printStackTrace();
	            return null;
	        }
	}
	private static SOAPMessage createSOAPRequest() throws Exception {
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();
        SOAPPart soapPart = (SOAPPart) soapMessage.getSOAPPart();


        String serverURI = "http://www.datapower.com/schemas/appliance/management/3.0/wsdl/app-mgmt-protocol/GetLogRequest";

        // SOAP Envelope
        SOAPEnvelope envelope = soapPart.getEnvelope();

        // SOAP Body
        SOAPBody soapBody = (SOAPBody) envelope.getBody().addNamespaceDeclaration("ns", "http://www.datapower.com/schemas/appliance/management/3.0");
        
        SOAPElement soapBodyElem = soapBody.addChildElement("GetLogRequest","ns");
        
        MimeHeaders headers = soapMessage.getMimeHeaders();
        headers.addHeader("SOAPAction", serverURI );
        headers.addHeader("Authorization", "Basic YWRtaW46c2FyYXN1MTA=");
      //  headers.addHeader("Content-Type", "text/xml" );
        soapMessage.saveChanges();

        /* Print the request message */
        System.out.print("Request SOAP Message = ");
        soapMessage.writeTo(System.out);
        System.out.println();

        return soapMessage;
    }

}
