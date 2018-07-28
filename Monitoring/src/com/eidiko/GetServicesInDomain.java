package com.eidiko;

import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;

import org.json.JSONArray;
import org.json.JSONObject;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.NodeList;

public class GetServicesInDomain {
	
	public List<Map<String,String>> getServices(String name,String host,String port)
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

	            SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(name),url);
	            
	            NodeList nl=soapResponse.getSOAPPart().getEnvelope().getBody().getFirstChild().getFirstChild().getChildNodes();
	            soapResponse.writeTo(System.out);
	            System.out.println();
	            List<Map<String,String>> log=new ArrayList<Map<String,String>>();
	            Map<String,String> m;
	           // System.out.println(soapResponse.getSOAPPart().getEnvelope().getBody().getFirstChild().getFirstChild().getAttributes().getNamedItem("name"));
	            for(int i=0; i<nl.getLength();i++)
	            {
	            	m=new HashMap<String,String>();
	            	NamedNodeMap nnm=nl.item(i).getAttributes();
	            	m.put("name",nnm.getNamedItem("name").getTextContent());
	            	m.put("displayname", nnm.getNamedItem("class-display-name").getTextContent());
	            	m.put("classname", nnm.getNamedItem("class-name").getTextContent());
	            	System.out.println(nnm.getNamedItem("name")+","+nnm.getNamedItem("class-display-name"));
	            //System.out.println(nl.item(i).getLocalName() +": "+nl.item(i).getTextContent());
	            	NodeList nm=nl.item(i).getChildNodes();
	            	for(int j=0;j<nm.getLength();j++)
	            	{
	            		System.out.print(nm.item(j).getLocalName() +": "+nm.item(j).getTextContent());
	            		System.out.println("\t");
	            		m.put(nm.item(j).getLocalName(), nm.item(j).getTextContent());
	            	}
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
	private static SOAPMessage createSOAPRequest(String domain) throws Exception {
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();
        SOAPPart soapPart = (SOAPPart) soapMessage.getSOAPPart();


        String serverURI = "http://www.datapower.com/schemas/appliance/management/3.0/wsdl/app-mgmt-protocol/GetServiceListFromDomainRequest";

        // SOAP Envelope
        SOAPEnvelope envelope = soapPart.getEnvelope();

        // SOAP Body
        SOAPBody soapBody = (SOAPBody) envelope.getBody().addNamespaceDeclaration("ns", "http://www.datapower.com/schemas/appliance/management/3.0");
        
        SOAPElement soapBodyElem = soapBody.addChildElement("GetServiceListFromDomainRequest","ns");
        SOAPElement soapBodyElem1=soapBodyElem.addChildElement("Domain", "ns");
        soapBodyElem1.addTextNode(domain);
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



