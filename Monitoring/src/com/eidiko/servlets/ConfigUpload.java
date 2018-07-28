package com.eidiko.servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;

import com.eidiko.SetDeviceSettings;
import com.eidiko.SetDomainConfig;
import com.eidiko.SetFile;
import com.eidiko.SetFirmware;

/**
 * Servlet implementation class ConfigUpload
 */
@WebServlet("/upload")
public class ConfigUpload extends HttpServlet {
	private static final long serialVersionUID = 1L;
	SetDomainConfig sdc;  
	SetFirmware sfm;
	SetFile sf;
	SetDeviceSettings sds;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConfigUpload() {
        super();
        // TODO Auto-generated constructor stub
    }
    public void init()
    {
    	sdc=new SetDomainConfig();
    	sfm=new SetFirmware();
    	sf=new SetFile();
    	sds=new SetDeviceSettings();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
RequestDispatcher rd;
		DiskFileUpload upload = new DiskFileUpload();
		List<FileItem> items=null;
		try {
			items = upload.parseRequest(request);
		} catch (FileUploadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // request is HttpServletRequest
		String domains=null,base64=null,loc=null,fname=null,accept=null,op=null;
		// iterate through form fields
		for(FileItem item:items) {
		    if(item.isFormField()) { // text fields, etc...
		        String fieldName = item.getFieldName();
		        String value = item.getString();
		        if(fieldName.equals("domain"))
		        {
		        	domains=value;
		        }
		        else if(fieldName.equals("base64"))
		        {
		        	base64=value;
		        }
		        else if(fieldName.equals("loc"))
		        {
		        	loc=value;
		        }
		        else if(fieldName.equals("fname"))
		        {
		        	fname=value;
		        }
		        else if(fieldName.equals("accept"))
		        {
		        	accept=value;
		        }
		        else if(fieldName.equals("op"))
		        {
		        	op=value;
		        }
		    } 
		}
		switch(op)
		{
		case "SetDomainConfig":rd=request.getRequestDispatcher("home.jsp");
							   String setdomresp=sdc.setDomainConfig(domains, base64,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
							   String sdcresp;
							   if(setdomresp.equals("ok"))
							   {
								   sdcresp="Your Configuration was loaded Succesfully Contact Your Admin in case of any problems";
								   
							   }
							   else
							   {
								   sdcresp="Sorry your Configuration Upload was not successfull contact System admin";
							   }
							   request.getSession().setAttribute("response", sdcresp);
							   rd.forward(request, response);
							   break;
		case "SetFirmware":rd=request.getRequestDispatcher("home.jsp");
						   String setfirmresp=sfm.setFirmware(accept, base64,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
						   String sfmresp;
						   if(setfirmresp.equals("ok"))
						   {
							   sfmresp="Your Configuration was loaded Succesfully Contact Your Admin in case of any problems";
							   
						   }
						   else
						   {
							   sfmresp="Sorry your Configuration Upload was not successfull contact System admin";
						   }
						   request.getSession().setAttribute("response", sfmresp);
						   rd.forward(request, response);
						   break;
		case "SetDomainExport":rd=request.getRequestDispatcher("SetConfig.jsp");
								rd.forward(request, response);
								
		case "SetDeviceSettings":rd=request.getRequestDispatcher("home.jsp");
								 String sdsresp=sds.setDeviceSettings(base64, request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
								 String setresp;
								 if(sdsresp.equals("ok"))
								 {
									 setresp="Your Device Settings has been Uploaded";
								 }
								 else
								 {
									 setresp="Sorry your Seetings Upload was not successfull contact System admin";
								 }
								 request.getSession().setAttribute("response", setresp);
								   rd.forward(request, response);
								   break;
								   
		case "SetFile":rd=request.getRequestDispatcher("home.jsp");
					   String setfresp=sf.setFile(domains, loc, fname, base64,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
					   String setfiresp;
					   if(setfresp.equals("ok"))
					   {
						   setfiresp="Your File was Uploaded Succesfully Contact Your Admin in case of any problems";
					   }
					   else
					   {
						   setfiresp="Sorry your File Upload was not successfull contact System admin";
					   }
					   request.getSession().setAttribute("response", setfiresp);
					   rd.forward(request, response);
					   break;
		}
		
	}

}
