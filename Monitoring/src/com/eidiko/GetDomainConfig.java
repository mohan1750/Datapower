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

public class GetDomainConfig {
	
	public byte[] getConfig(String domain,String host,String port)
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

	            SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(domain),url);
	            NodeList nl=soapResponse.getSOAPPart().getEnvelope().getBody().getFirstChild().getChildNodes();
	            soapResponse.writeTo(System.out);
	            System.out.println();
	            System.out.println(soapResponse.getSOAPPart().getEnvelope().getBody().getFirstChild().getFirstChild().getAttributes().getNamedItem("domain"));
	            for(int i=0; i<nl.getLength();i++)
	            {
	            System.out.println(nl.item(i).getLocalName() +": "+nl.item(i).getTextContent());
	            }
	           byte[] out= Base64.getDecoder().decode(nl.item(0).getTextContent());
	           
	            
	            soapConnection.close();
	            return out;
	        } catch (Exception e) {
	            System.err
	                    .println("Error occurred while sending SOAP Request to Server");
	            e.printStackTrace();
	            return null;
	        }
	}
	private static SOAPMessage createSOAPRequest(String name) throws Exception {
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();
        SOAPPart soapPart = (SOAPPart) soapMessage.getSOAPPart();


        String serverURI = "http://www.datapower.com/schemas/appliance/management/3.0/wsdl/app-mgmt-protocol/GetDomainConfigRequest";

        // SOAP Envelope
        SOAPEnvelope envelope = soapPart.getEnvelope();

        // SOAP Body
        SOAPBody soapBody = (SOAPBody) envelope.getBody().addNamespaceDeclaration("ns", "http://www.datapower.com/schemas/appliance/management/3.0");
        
        SOAPElement soapBodyElem = soapBody.addChildElement("GetDomainConfigRequest","ns");
        SOAPElement soapBodyElem1=soapBodyElem.addChildElement("Domain", "ns");
        soapBodyElem1.addTextNode(name);
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

