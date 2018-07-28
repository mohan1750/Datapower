package com.eidiko.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.eidiko.StatusStorage;

/**
 * Servlet implementation class Statistics
 */
@WebServlet("/stats")
public class Statistics extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Statistics() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		StatusStorage ss=new StatusStorage();
		try {
			Connection con=ss.getConn();
			Statement stmt=con.createStatement();
			System.out.println("Started");
			List<HashMap<String,String>> cpulist=ss.displayStats("cpu");
			List<HashMap<String,String>> memlist=ss.displayStats("memory");
			List<HashMap<String,String>> connlist=ss.displayStats("connections");
			List<HashMap<String,String>> memstat=ss.processMem();
			List<HashMap<String,String>> filestat=ss.processFilesSystem();
			System.out.println(memlist);
			request.getSession().setAttribute("cpu", cpulist);
			request.getSession().setAttribute("memory", memlist);
			request.getSession().setAttribute("memstat", memstat);
			request.getSession().setAttribute("filestat", filestat);
			request.getSession().setAttribute("connections", connlist);
			RequestDispatcher rd=request.getRequestDispatcher("statistics.jsp");
			rd.forward(request, response);
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
