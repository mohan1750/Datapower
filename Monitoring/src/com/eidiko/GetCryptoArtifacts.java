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

import org.w3c.dom.NodeList;

public class GetCryptoArtifacts {
	
	public List<Map<String,String>> getCrypto(String name,String host,String port)
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
	            //System.out.println();
	           // System.out.println(soapResponse.getSOAPPart().getEnvelope().getBody().getFirstChild().getFirstChild().getAttributes().getNamedItem("domain"));
	            List<Map<String,String>> crypto=new ArrayList<Map<String,String>>();
	            Map<String,String> m;
	            for(int i=0; i<nl.getLength();i++)
	            { m=new HashMap<String,String>();
	            	m.put("location", nl.item(i).getAttributes().getNamedItem("location").getTextContent());
	            	m.put("name", nl.item(i).getTextContent());
	            	crypto.add(m);
	            System.out.println(nl.item(i).getLocalName() +": "+nl.item(i).getTextContent()+" in "+nl.item(i).getAttributes().getNamedItem("location"));
	            }
	            
	            soapConnection.close();
	            return crypto;
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


        String serverURI = "http://www.datapower.com/schemas/appliance/management/3.0/wsdl/app-mgmt-protocol/GetCryptoArtifactsRequest";

        // SOAP Envelope
        SOAPEnvelope envelope = soapPart.getEnvelope();

        // SOAP Body
        SOAPBody soapBody = (SOAPBody) envelope.getBody().addNamespaceDeclaration("ns", "http://www.datapower.com/schemas/appliance/management/3.0");
        
        SOAPElement soapBodyElem = soapBody.addChildElement("GetCryptoArtifactsRequest","ns");
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

