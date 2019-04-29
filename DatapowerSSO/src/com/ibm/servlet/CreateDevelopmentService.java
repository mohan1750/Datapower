package com.ibm.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Base64;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.XML;

import com.ibm.CreateService;
import com.ibm.TrannsformServiceManifest;
import com.ibm.XmlFormatter;

/**
 * Servlet implementation class CreateDevelopmentService
 */
@WebServlet("/newService")
public class CreateDevelopmentService extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateDevelopmentService() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		ServletContext servletContext = getServletContext();
		String user=servletContext.getAttribute("user").toString();
		String pass=servletContext.getAttribute("pass").toString();
		String host=servletContext.getAttribute("host").toString();
		String base64encodedString = "Basic "+Base64.getUrlEncoder().encodeToString((user+":"+pass).getBytes("utf-8"));
		BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream()));
        String json = "";
        if(br != null){
            json = br.readLine();
        }
        JSONArray obj = new JSONArray(json);
        String provider=request.getHeader("provider");
        String domain=request.getHeader("domain");
        System.out.println("Domain: "+domain+" Provider: "+provider);
        String xml_data = "<entries>"+XML.toString(obj)+"</entries>";
        System.out.println("Transformed XML is:"+xml_data);
        String newResult= new TrannsformServiceManifest().transform(xml_data);
        String prettyXml= new XmlFormatter().format(newResult);
        String base64Payload=Base64.getEncoder().encodeToString(prettyXml.getBytes());
       // System.out.println("Transformed Service manifest: "+base64Payload);
        CreateService cs=new CreateService();
        boolean res=cs.create(domain, provider, base64encodedString, host, base64Payload);
       // System.out.println("Service Created:"+ res);
        if(res) {
        	
        	response.setStatus(HttpServletResponse.SC_CREATED);
        }
        else {
        	response.setStatus(HttpServletResponse.SC_NOT_IMPLEMENTED);
        }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
