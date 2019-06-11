package com.ibm.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Date;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ibm.LogDeletedServices;

/**
 * Servlet implementation class NotifyDeleteServices
 */
@WebServlet("/notifydelete")
public class NotifyDeleteServices extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NotifyDeleteServices() {
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
		LogDeletedServices lds=new LogDeletedServices();
		String desc=request.getHeader("desc");
		String provider=request.getHeader("provider");
        String domain=request.getHeader("domain");
		BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream()));
        String json = "";
        if(br != null){
            json = br.readLine();
        }
        System.out.println("Deleted Service is:"+json);
		boolean res=lds.logEvent(user, new Date().toInstant().toString(), desc, json,domain,provider);
		if(res) {
			System.out.println("Delete event logged");
			response.setStatus(HttpServletResponse.SC_OK);
		}
		else {
			System.out.println("Delete event failed to logged");
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
