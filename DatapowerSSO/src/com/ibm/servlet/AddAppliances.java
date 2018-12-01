package com.ibm.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.ibm.AddAppliance;

/**
 * Servlet implementation class AddAppliances
 */
@WebServlet("/addappliances")
public class AddAppliances extends HttpServlet {
	private static final long serialVersionUID = 1L;
     AddAppliance aa;  
    /**
     * @see HttpServlet#HttpServlet()
     */
	public void init()
	{
		aa= new AddAppliance();
		
	}
    public AddAppliances() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String applname=request.getParameter("appl");
		int res=aa.add(applname);
		PrintWriter out = response.getWriter();
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		JSONObject jo=new JSONObject();
		jo.put("status", res);
		if(res != 0) {
			out.print(jo);
			response.setStatus(200, "OK");
		}
		else {
			out.print(jo);
			response.setStatus(500, "Processing Error");
		}
		out.flush();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
