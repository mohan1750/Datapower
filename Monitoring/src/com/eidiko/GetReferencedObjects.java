package com.eidiko;

import java.io.StringReader;
import java.io.StringWriter;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class GetReferencedObjects {
	
	public String getInterServices(String domain,String classname,String obname,String op,String host,String port)
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

	            SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(domain,classname,obname),url);
	            soapResponse.writeTo(System.out);
	            Node nl=soapResponse.getSOAPPart().getEnvelope().getBody().getFirstChild().getFirstChild();
	            StringWriter sw = new StringWriter();
	            TransformerFactory.newInstance().newTransformer().transform(
	                    new DOMSource(soapResponse.getSOAPPart().getEnvelope().getBody().getFirstChild()),
	                    new StreamResult(sw));
	            System.out.println();
	            System.out.println(sw.toString());
	            Transformation trx=new Transformation();
	            Transformation2 trx2=new Transformation2();
	            Transformation3 trx3=new Transformation3();
	            String html=null;
	            if(op.equals("true"))
	            {
	            	String tres=trx.transform(sw.toString());
		            /*Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder()
			                  .parse(new InputSource(new StringReader(tres))); */
	            	 System.out.println(tres);
		          html= trx2.transform(tres);
	            }
	            else
	            {
	            	html=trx3.transform(sw.toString());
	            }
	            
	            //System.out.println(nl.getTextContent());
	           
	            System.out.println(html);	            
	            soapConnection.close();
	            return html;
	            
	        } catch (Exception e) {
	            System.err
	                    .println("Error occurred while sending SOAP Request to Server");
	            e.printStackTrace();
	            return null;
	        }
	}
	private static SOAPMessage createSOAPRequest(String domain,String location,String name) throws Exception {
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();
        SOAPPart soapPart = (SOAPPart) soapMessage.getSOAPPart();


        String serverURI = "http://www.datapower.com/schemas/appliance/management/3.0/wsdl/app-mgmt-protocol/GetReferencedObjectsRequest";

        // SOAP Envelope
        SOAPEnvelope envelope = soapPart.getEnvelope();

        // SOAP Body
        SOAPBody soapBody = (SOAPBody) envelope.getBody().addNamespaceDeclaration("ns", "http://www.datapower.com/schemas/appliance/management/3.0");
        
        SOAPElement soapBodyElem = soapBody.addChildElement("GetReferencedObjectsRequest","ns");
        SOAPElement soapBodyElem1=soapBodyElem.addChildElement("Domain", "ns");
        SOAPElement soapBodyElem2=soapBodyElem.addChildElement("ObjectClass", "ns");
        SOAPElement soapBodyElem3=soapBodyElem.addChildElement("ObjectName", "ns");
        soapBodyElem1.addTextNode(domain);soapBodyElem2.addTextNode(location);soapBodyElem3.addTextNode(name);       
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


