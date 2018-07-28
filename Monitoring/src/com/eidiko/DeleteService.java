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

public class DeleteService {
	
	public String deleteService(String domain,String name,String classname,String[] oblist,String file,String host,String port)
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

	            SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(domain,name,classname,oblist,file),url);
	            
	            Node nl=soapResponse.getSOAPPart().getEnvelope().getBody().getFirstChild();	           	            
	            soapConnection.close();
	            System.out.println(nl.getTextContent());
	            return nl.getTextContent();
	        } catch (Exception e) {
	            System.err
	                    .println("Error occurred while sending SOAP Request to Server");
	            e.printStackTrace();
	            return null;
	        }
	}
	private static SOAPMessage createSOAPRequest(String domain,String name,String classname,String[] oblist,String file) throws Exception {
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();
        SOAPPart soapPart = (SOAPPart) soapMessage.getSOAPPart();


        String serverURI = "http://www.datapower.com/schemas/appliance/management/3.0/wsdl/app-mgmt-protocol/DeleteFileRequest";

        // SOAP Envelope
        SOAPEnvelope envelope = soapPart.getEnvelope();

        // SOAP Body
        SOAPBody soapBody = (SOAPBody) envelope.getBody().addNamespaceDeclaration("ns", "http://www.datapower.com/schemas/appliance/management/3.0");
        
        SOAPElement soapBodyElem = soapBody.addChildElement("DeleteServiceRequest","ns");
        SOAPElement soapBodyElem11=soapBodyElem.addChildElement("Domain", "ns");
        
        soapBodyElem11.addTextNode(domain);
        SOAPElement sopaBodyElem22=soapBodyElem.addChildElement("ServiceObjectClass", "ns");
        sopaBodyElem22.addTextNode(classname);
        SOAPElement soapBodyElem33=soapBodyElem.addChildElement("ServiceObjectName","ns");
        soapBodyElem33.addTextNode(name);
        SOAPElement soapBodyElem44=soapBodyElem.addChildElement("ObjectExclusionList","ns");
        
        for(int i=0;i<oblist.length;i++) {
        	SOAPElement soapBodyElem111=soapBodyElem44.addChildElement("Object","ns");
        	soapBodyElem111.addAttribute(new javax.xml.namespace.QName("name"), oblist[i].split(":")[0]);
            soapBodyElem111.addAttribute(new javax.xml.namespace.QName("class-name"), oblist[i].split(":")[1].split(",")[0]);
            soapBodyElem111.addAttribute(new javax.xml.namespace.QName("class-display-name"), oblist[i].split(",")[1]);
        }
        
        SOAPElement soapBodyElem6=soapBodyElem.addChildElement("DeleteReferencedFiles","ns");
        soapBodyElem6.addTextNode(file);
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


