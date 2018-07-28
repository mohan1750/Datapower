package com.eidiko;

import java.io.StringReader;
import java.net.URL;

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

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;


public class HelloMessage {
	public static void main(String args[]) {
	    try {
	        // Create SOAP Connection
	    SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
	    SOAPConnection soapConnection = soapConnectionFactory
	                    .createConnection();

	            URL url = new URL("http://www.webservicex.com/globalweather.asmx");
	            // String url =
	            // "http://192.168.2.119/DISWebService/DISWebService.asmx?op=LoginSystem";

	            SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(),url);
	            SOAPEnvelope envelope=soapResponse.getSOAPPart().getEnvelope();
	          Node nl=  envelope.getBody().getFirstChild().getFirstChild().getFirstChild();
	         // System.out.println(nl.getNodeValue());
	          
	          Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder()
	                  .parse(new InputSource(new StringReader(nl.getTextContent())));
	         
	          
	          NodeList errNodes = doc.getElementsByTagName("Table");
	          for (int i=0 ;i<errNodes.getLength() ;i++) {
	              Element err = (Element)errNodes.item(i);
	              System.out.println( err.getElementsByTagName("Country")
		                   .item(0).getTextContent()+": " +err.getElementsByTagName("City")
	                   .item(0).getTextContent());
	          } 
	       
	           // System.out.println(body);
	            // Process the SOAP Response
	         // soapResponse.writeTo(System.out);
	          

	            soapConnection.close();
	        } catch (Exception e) {
	            System.err
	                    .println("Error occurred while sending SOAP Request to Server");
	            e.printStackTrace();
	        }
	}

	private static SOAPMessage createSOAPRequest() throws Exception {
	        MessageFactory messageFactory = MessageFactory.newInstance();
	        SOAPMessage soapMessage = messageFactory.createMessage();
	        SOAPPart soapPart = (SOAPPart) soapMessage.getSOAPPart();


	        String serverURI = "http://www.webserviceX.NET/GetCitiesByCountry";

	        // SOAP Envelope
	        SOAPEnvelope envelope = soapPart.getEnvelope();

	        // SOAP Body
	        SOAPBody soapBody = (SOAPBody) envelope.getBody().addNamespaceDeclaration("web", "http://www.webserviceX.NET");
	        
	        SOAPElement soapBodyElem = soapBody.addChildElement("GetCitiesByCountry","web");
	        
	  
	        SOAPElement soapBodyElem1 = soapBodyElem.addChildElement("CountryName","web");
	        
	        soapBodyElem1.addTextNode("india");

	        

	        MimeHeaders headers = soapMessage.getMimeHeaders();
	        headers.addHeader("SOAPAction", serverURI );
	      //  headers.addHeader("Content-Type", "text/xml" );
	        soapMessage.saveChanges();

	        /* Print the request message */
	        System.out.print("Request SOAP Message = ");
	        soapMessage.writeTo(System.out);
	        System.out.println();

	        return soapMessage;
	    }

}
