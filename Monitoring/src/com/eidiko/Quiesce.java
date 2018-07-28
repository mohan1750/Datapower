package com.eidiko;

import java.net.URL;

import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;

import org.w3c.dom.Node;

public class Quiesce {
	
	public String quiesce(String domain,String time,String type,String host,String port)
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

	            SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(domain,time,type),url);
	            
	            Node nl=soapResponse.getSOAPPart().getEnvelope().getBody().getFirstChild().getFirstChild();	           	            
	            soapConnection.close();
	            return nl.getTextContent();
	        } catch (Exception e) {
	            System.err
	                    .println("Error occurred while sending SOAP Request to Server");
	            e.printStackTrace();
	            return null;
	        }
	}
	private static SOAPMessage createSOAPRequest(String domain,String time,String type) throws Exception {
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();
        SOAPPart soapPart = (SOAPPart) soapMessage.getSOAPPart();


        String serverURI = "http://www.datapower.com/schemas/appliance/management/3.0/wsdl/app-mgmt-protocol/DeleteFileRequest";

        // SOAP Envelope
        SOAPEnvelope envelope = soapPart.getEnvelope();

        // SOAP Body
        SOAPBody soapBody = (SOAPBody) envelope.getBody().addNamespaceDeclaration("ns", "http://www.datapower.com/schemas/appliance/management/3.0");
        
        SOAPElement soapBodyElem = soapBody.addChildElement("QuiesceRequest","ns");
        SOAPElement soapBodyElem1;
        SOAPElement soapBodyElem2;
        SOAPElement soapBodyElem3;
        if(type.equals("Domain"))
        {
        	soapBodyElem1=soapBodyElem.addChildElement("Domain", "ns");        	
        	soapBodyElem2=soapBodyElem1.addChildElement("Name", "ns");
        	soapBodyElem2.addTextNode(domain);
        	soapBodyElem3=soapBodyElem1.addChildElement("Timeout", "ns");
        	soapBodyElem3.addTextNode(time);
        	
        }
        else
        {
        	soapBodyElem1=soapBodyElem.addChildElement("Device", "ns");
        	soapBodyElem2=soapBodyElem1.addChildElement("Timeout", "ns");
        	soapBodyElem2.addTextNode(time);
        	
        }
        
        
        
        
        
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


