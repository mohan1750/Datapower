package com.ibm;

import java.io.File;
import java.io.StringReader;

import org.custommonkey.xmlunit.Transform;
import org.xml.sax.InputSource;

public class TrannsformServiceManifest {

	public String transform(String msg) {
		File tranformer = new File(getClass().getClassLoader().getResource("/resources/ServiceTransform.xsl").getFile());
		File inputXML = new File("src/resources/Input.xml");
		// File expectedXML = new File(
		// "src/test/resources/expected/TODO.xml");
		try {
		Transform myTransform = new Transform(new InputSource(new StringReader(
				msg)), tranformer);
		
		
		String result=myTransform.getResultString();
		return result;
	}
		catch(Exception e) {
			System.out.println(e.getMessage());
			return "";
		}

}
}
