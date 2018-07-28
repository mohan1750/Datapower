package com.eidiko;

import java.io.File;
import java.io.StringReader;
import java.util.List;

import org.custommonkey.xmlunit.Transform;
import org.xml.sax.InputSource;

public class Transformation2 {

	public String  transform(String msg)  {
		File tranformer = new File(
				"../workspace/Monitoring/src/resources/XML_HTML_XSL.xsl");
		File inputXML = new File(
				"src/resources/Input.xml");
		// File expectedXML = new File(
		// "src/test/resources/expected/TODO.xml");
		try {
		Transform myTransform = new Transform(new InputSource(new StringReader(
				msg)), tranformer);
		
		
		
		String result=myTransform.getResultString();
		return result;
		}
		catch(Exception e) {
			e.printStackTrace();
			return null;
		}
		// TODO Auto-generated method stub

	}

}
