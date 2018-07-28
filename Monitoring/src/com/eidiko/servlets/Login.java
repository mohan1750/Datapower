package com.eidiko.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.eidiko.DeviceInfo;
import com.eidiko.StatusStorage;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @throws SQLException 
     * @throws ClassNotFoundException 
     * @see HttpServlet#HttpServlet()
     */
    public Login() throws ClassNotFoundException, SQLException {
        super();
        
        
        // TODO Auto-generated constructor stub
    }
    

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String name=request.getParameter("name");
		String pass = request.getParameter("pass");
		String host=request.getParameter("host");
		String xport=request.getParameter("xport");
		String rport=request.getParameter("rport");
		RequestDispatcher rd;
		if((name.equals("admin") && pass.equals("sarasu10")))
		{
			rd=request.getRequestDispatcher("home.jsp");
			request.getSession().setAttribute("user", name);
			request.getSession().setAttribute("pass", pass);
			request.getSession().setAttribute("host", host);
			request.getSession().setAttribute("xport", xport);
			request.getSession().setAttribute("response", "");
			request.getSession().setAttribute("logs", "");
			request.getSession().setAttribute("domain", "");
			request.getSession().setAttribute("str", "");
			request.getSession().setAttribute("message", "");
			request.getSession().setAttribute("rport", rport);
			List<List<String>> l=new DeviceInfo().info(host,xport);
			/*List<String> other=new ArrayList<String>();other.add("Device:Datapower");
			List<String> feature=new ArrayList<String>();feature.add("TAM");
			List<String> operation=new ArrayList<String>();operation.add("Ping");operation.add("GetDomainConfig");*/
			HttpSession hs=request.getSession();
			/*hs.setAttribute("other", other);
			hs.setAttribute("feature", feature );
			hs.setAttribute("operation", operation);*/
			hs.setAttribute("other", l.get(0));
			hs.setAttribute("feature",l.get(1));
			hs.setAttribute("operation", l.get(2));
			rd.forward(request, response);
		}	
		else
		{
			rd=request.getRequestDispatcher("index.jsp");
			request.setAttribute("error", "You Aren't Authorized");
			rd.forward(request, response);
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
