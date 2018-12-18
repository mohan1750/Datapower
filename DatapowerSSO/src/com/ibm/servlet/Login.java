package com.ibm.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.ibm.GetUser;
import com.ibm.UserLogin;
import com.ibm.beans.UserBean;

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
    public void init( ServletConfig config ) throws ServletException
    {
        super.init( config );

        getServletContext().setAttribute( "user", "");
        getServletContext().setAttribute( "pass", "");
        getServletContext().setAttribute( "host", "");
		// save counter to the application scope
        
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String name=request.getParameter("name");
		String pass = request.getParameter("pass");
		String host=request.getParameter("host");
		String role=request.getParameter("role");
		ServletContext servletContext= getServletContext();
		servletContext.setAttribute("user", name);
		servletContext.setAttribute("pass", pass);
		servletContext.setAttribute("host", host);
		RequestDispatcher rd;
		if((!name.equals("") && !pass.equals("")))
		{
			/*rd=request.getRequestDispatcher("home.jsp");
			request.getSession().setAttribute("user", name);
			request.getSession().setAttribute("pass", pass);
			request.getSession().setAttribute("host", host);
			request.getSession().setAttribute("xport", xport);
			request.getSession().setAttribute("response", "");
			request.getSession().setAttribute("logs", "");
			request.getSession().setAttribute("domain", "");
			request.getSession().setAttribute("str", "");
			request.getSession().setAttribute("message", "");
			request.getSession().setAttribute("rport", rport);*/
			boolean dpres=new UserLogin().checkUser(name, pass, host);
			System.out.println("User result"+dpres);
			UserBean ub=new GetUser().getUser(name);
			if(dpres ) {
				if((ub.getAdminid() != null) && ub.getAdminid().equals(name) && ub.getRole().equals(role)) {
					
					System.out.println(servletContext.getAttribute("host"));
					if(role.equals("admin")) {
					rd=request.getRequestDispatcher("home.jsp");
					}
					else if(role.equals("develop")) {
						System.out.println(servletContext.getAttribute("host"));
						rd=request.getRequestDispatcher("develop.jsp");
					}
					else {
						System.out.println(servletContext.getAttribute("host"));
						rd=request.getRequestDispatcher("stats.jsp");
					}
					rd.forward(request, response);
					
				}
				else if((ub.getRole() != null) && !(ub.getRole().equals(role)) &&ub.getAdminid().equals(name)) {
					rd=request.getRequestDispatcher("index.jsp");
					request.setAttribute("error", "Selected role is not valid");
					rd.forward(request, response);
				}
				else {
					rd=request.getRequestDispatcher("register.jsp");
					request.setAttribute("error", "You have not registered in SSO Console");
					rd.forward(request, response);
				}
			}
			else {
				rd=request.getRequestDispatcher("index.jsp");
				request.setAttribute("error", "Invalid Credentials");
				rd.forward(request, response);
			}
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
