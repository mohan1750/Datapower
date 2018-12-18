package com.ibm.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ibm.GetUser;
import com.ibm.RegisterUser;
import com.ibm.beans.UserBean;

/**
 * Servlet implementation class RegisterHandler
 */
@WebServlet("/register")
public class RegisterHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterHandler() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream()));
        String json = "";
        if(br != null){
            json = br.readLine();
        }
 
        // 2. initiate jackson mapper
        ObjectMapper mapper = new ObjectMapper();
 
        // 3. Convert received JSON to Article
        UserBean ub = mapper.readValue(json, UserBean.class);
        PrintWriter out = response.getWriter();
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
        JSONObject jo=new JSONObject();
		jo.put("status", "response");
        RegisterUser ru=new RegisterUser();
        GetUser gu=new GetUser();
        UserBean ubr=gu.getUser(ub.getAdminid());
        //System.out.println("User exists: "+ubr.getPhoto());
        if(ubr.getAdminid()!= null && ubr.getAdminid().equals(ub.getAdminid())) {
        	out.print(jo);
			response.setStatus(202, "Duplicate Record");
        }
        else {
        	int res=ru.addUser(ub);
            
            if(res != 0) {
    			out.print(jo);
    			response.setStatus(200, "OK");
    		}
    		else {
    			out.print(jo);
    			response.setStatus(500, "Processing Error");
    		}
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
