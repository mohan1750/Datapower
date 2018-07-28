package com.eidiko;

import java.net.URL;
import java.util.Base64;

import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;

import org.w3c.dom.NodeList;

public class PingHost {
	
	public String ping(String ping,String host,String port)
	{
		
		try {
			SSLUtilities.trustAllHostnames();
			SSLUtilities.trustAllHttpsCertificates();
	        // Create SOAP Connection
	    SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
	    SOAPConnection soapConnection = soapConnectionFactory
	                    .createConnection();

	    URL url = new URL("https://"+host+":"+port+"/service/mgmt/3.0");
	            // String url =
	            // "http://192.168.2.119/DISWebService/DISWebService.asmx?op=LoginSystem";

	    SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(ping),url);
	            
	            NodeList nl=soapResponse.getSOAPPart().getEnvelope().getBody().getFirstChild().getChildNodes();
	            System.out.println(nl.item(0).getTextContent());
	            String out= nl.item(1).getTextContent();
	            soapConnection.close();
	            return out;
	            
	        } catch (Exception e) {
	            System.err
	                    .println("Error occurred while sending SOAP Request to Server");
	            e.printStackTrace();
	            return null;
	           
	        }
	}
	private static SOAPMessage createSOAPRequest(String ping) throws Exception {
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();
        SOAPPart soapPart = (SOAPPart) soapMessage.getSOAPPart();


        String serverURI = "http://www.datapower.com/schemas/management/wsdl/xml-mgmt/operationRequest";

        // SOAP Envelope
        SOAPEnvelope envelope = soapPart.getEnvelope();

        // SOAP Body
        SOAPBody soapBody = (SOAPBody) envelope.getBody().addNamespaceDeclaration("man", "http://www.datapower.com/schemas/management");
        
        SOAPElement soapBodyElem = soapBody.addChildElement("request","man");
        soapBodyElem.addAttribute(new javax.xml.namespace.QName("domain"), "default");
        SOAPElement soapBodyElem1=soapBodyElem.addChildElement("do-action", "man");
        SOAPElement soapBodyElem2=soapBodyElem1.addChildElement("Ping");
        SOAPElement soapBodyElem3=soapBodyElem2.addChildElement("RemoteHost");
        soapBodyElem3.addTextNode(ping);
        
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


