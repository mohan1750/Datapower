package com.eidiko.servlets;

import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.eidiko.CreateDomain;
import com.eidiko.DeleteDomain;
import com.eidiko.DeleteFile;
import com.eidiko.DeleteService;
import com.eidiko.DomainList;
import com.eidiko.ExportService;
import com.eidiko.FlushStylesheetCache;
import com.eidiko.GetApplianceLog;
import com.eidiko.GetCryptoObjects;
import com.eidiko.GetDeviceSettings;
import com.eidiko.GetDomainConfig;
import com.eidiko.GetDomainStatus;
import com.eidiko.GetErrorReport;
import com.eidiko.GetFile;
import com.eidiko.GetReferencedObjects;
import com.eidiko.GetSeriviceHTTPTransactionTimes;
import com.eidiko.GetSeriviceHTTPTransactions;
import com.eidiko.GetServicesInDomain;
import com.eidiko.PingHost;
import com.eidiko.Quiesce;
import com.eidiko.RebootAppliance;
import com.eidiko.RestartDomain;
import com.eidiko.SearchLogs;
import com.eidiko.SetDomainConfig;
import com.eidiko.StartDomain;
import com.eidiko.StartService;
import com.eidiko.StopDomain;
import com.eidiko.StopService;
import com.eidiko.TCPConnectionTest;
import com.eidiko.TCPTable;
import com.eidiko.Unquiesce;
import com.eidiko.UpdateDomain;
import com.eidiko.XMLManager;

/**
 * Servlet implementation class ControlServlet
 */
@WebServlet("/control")
public class ControlServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
	GetDomainConfig gdc;
	DomainList dl;
	GetDomainStatus ds;
	DeleteFile df;
	DeleteDomain dd;
	GetApplianceLog applog;
	GetCryptoObjects ca;
	GetErrorReport er;
	GetServicesInDomain sid;
	GetReferencedObjects gro;
	RequestDispatcher rd;
	RebootAppliance ra;
	RestartDomain rdom;
	StartDomain sd;
	StopDomain std;
	StartService stserv;
	StopService stopserv;
	Quiesce q;
	Unquiesce uq;
	CreateDomain cd;
	UpdateDomain ud;
	SetDomainConfig sdc;
	GetDeviceSettings gds;
	ExportService es;
	DeleteService dserv;
	SearchLogs sl;
	PingHost ph;
	TCPConnectionTest tct;
	GetFile gf;
	GetSeriviceHTTPTransactions gsht;
	GetSeriviceHTTPTransactionTimes gshtt;
	TCPTable tt;
	XMLManager xm;
	FlushStylesheetCache fsc;
    public ControlServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    public void init()
    {
    	gdc=new GetDomainConfig();
		dl=new DomainList();
		ds=new GetDomainStatus();
		 df=new DeleteFile();
		dd=new DeleteDomain();
		applog=new GetApplianceLog();
		ca=new GetCryptoObjects();
		er=new GetErrorReport();
		sid=new GetServicesInDomain();
		gro=new GetReferencedObjects();
		ra=new RebootAppliance();
		rdom=new RestartDomain();
		sd=new StartDomain();
		std=new StopDomain();
		stserv=new StartService();
		stopserv=new StopService();
		q=new Quiesce();
		uq=new Unquiesce();
		cd=new CreateDomain();
		ud=new UpdateDomain();
		sdc=new SetDomainConfig();
    	gds=new GetDeviceSettings();
    	es=new ExportService();
    	dserv=new DeleteService();
    	sl=new SearchLogs();
    	ph=new PingHost();
    	tct=new TCPConnectionTest();
    	gf=new GetFile();
    	gsht=new GetSeriviceHTTPTransactions();
    	gshtt=new GetSeriviceHTTPTransactionTimes();
    	tt=new TCPTable();
    	xm=new XMLManager();
    	fsc=new FlushStylesheetCache();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String op=request.getParameter("operation");
		
		
		String domain=request.getParameter("domain");
		if(request.getSession().getAttribute("user").equals("admin")) {
		switch(op) {
		case "GetDomainConfig": 
								byte[] config=gdc.getConfig(domain,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
								response.setContentType("application/octet-stream");
						        response.setContentLength(config.length);
						        String headerKey = "Content-Disposition";
						        String headerValue = String.format("attachment; filename=\"%s\"", domain+"Config.zip");
						        response.setHeader(headerKey, headerValue);
						       OutputStream outStream = response.getOutputStream();
						        outStream.write(config);
								break;
		case "GetDeviceSettings": byte[] sett=gds.getDeviceSettings(request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
								  response.setContentType("application/octet-stream");
								  response.setContentLength(sett.length);
								  String headerKey2 = "Content-Disposition";
								  String headerValue2 = String.format("attachment; filename=\"%s\"","Settings.zip");
								  response.setHeader(headerKey2, headerValue2);
								  OutputStream outStream2 = response.getOutputStream();
								  outStream2.write(sett);
								  break;
		case "GetDomainExport": byte[] export=gdc.getConfig(domain,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
								response.setContentType("application/octet-stream");
								response.setContentLength(export.length);
								String headerKey1 = "Content-Disposition";
								String headerValue1 = String.format("attachment; filename=\"%s\"", domain+"Export.zip");
								response.setHeader(headerKey1, headerValue1);
								OutputStream outStream1 = response.getOutputStream();
								
								outStream1.write(export);
								
								break;
		case "GetDomainStatus":
		case "GetDomainList": 	rd=request.getRequestDispatcher("DomainList.jsp");
							    List<String> list=dl.getList(request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
							    request.getSession().setAttribute("domlist", list);
							    rd.forward(request, response);
							    break;	
		case "GetStatus": rd=request.getRequestDispatcher("DomainStatus.jsp");
								List<String> status=ds.GetStatus(domain,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
								request.getSession().setAttribute("domstatus", status);
								rd.forward(request, response);
								break;
		case "DeleteFile":		String location=request.getParameter("location");
								String name=request.getParameter("fname");
								rd=request.getRequestDispatcher("/Login?name=&pass=");
								String out=df.deleteFile(domain, location, name,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
								String res;
								if(out.equals("ok"))
									res="Success Your File Deleted";
								else
									res="Sorry Specified File Doesn't exist in Specified location";
								request.getSession().setAttribute("response", res);
								rd.forward(request, response);
								break;
		case "DeleteDomain":	rd=request.getRequestDispatcher("home.jsp");
								String del=dd.deleteDomain(domain,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
								String result;
								if(del.equals("ok"))
									result="Success Your Domain Deleted";
								else
									result="Sorry Specified Domain Doesn't exist ";
								request.getSession().setAttribute("response", result);
								rd.forward(request, response);
								break;
		case "GetApplianceLog": rd=request.getRequestDispatcher("ApplianceLog.jsp");
								List<Map<String,String>> logs=applog.getLogs(request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
								request.getSession().setAttribute("logs", logs);
								rd.forward(request, response);
								break;
		case "GetCryptoArtifacts": 	rd=request.getRequestDispatcher("CryptoArtifacts.jsp");
									List<HashMap<String,String>> crypto=ca.getCrypto(domain,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("rport").toString());
									request.getSession().setAttribute("domain", domain);
									request.getSession().setAttribute("crypto", crypto);
									rd.forward(request, response);
									break;
		case "GetErrorReport":	
			System.out.println(request.getSession().getAttribute("host")+":"+request.getSession().getAttribute("xport"));
								byte[] report=er.getErrorReport(request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
								response.setContentType("application/octet-stream");
								response.setContentLength(report.length);
								String headerKey4 = "Content-Disposition";
								String headerValue4 = String.format("attachment; filename=\"%s\"", "ErrorReport.zip");
								response.setHeader(headerKey4, headerValue4);
								OutputStream outStream4 = response.getOutputStream();
								request.getSession().setAttribute("response", "Your File was also available in temporary:/// Directory of default domain");
								outStream4.write(report);
		case "GetServiceListFromDomain":rd=request.getRequestDispatcher("DomainServices.jsp");
										String dur=request.getParameter("duration");
										if(dur==null || dur.equals(""))
										{
											dur="oneMinute";
										}
										List<Map<String,String>> services=sid.getServices(domain,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
										List<Map<String,String>> transactions=gsht.getTransactions(domain,dur,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("rport").toString());
										List<Map<String,String>> transactiontimes=gshtt.getTransactions(domain,dur,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("rport").toString());
										request.getSession().setAttribute("domain", domain);
										request.getSession().setAttribute("duration", dur);
										request.getSession().setAttribute("services", services);
										request.getSession().setAttribute("transactions", transactions);
										request.getSession().setAttribute("transactiontimes", transactiontimes);
										rd.forward(request, response);
										break;
		case "GetReferencedObjects": String classname=request.getParameter("classname");
									 String obname=request.getParameter("obname");
									 
									 String html=gro.getInterServices(domain, classname, obname,"true",request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
									 rd=request.getRequestDispatcher("ObjectsInService.jsp");
									 request.getSession().setAttribute("objects", html);
										rd.forward(request, response);
										break;
		case "Reboot": 			String mode=request.getParameter("mode");
								String resp=ra.reboot(mode,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
								String rebres;
								rd=request.getRequestDispatcher("home.jsp");
								if(resp.equals("ok"))
								{
									rebres="Your Request is Under Process Contact Your Admin in case of any problems";
									
								}
								else
								{
									rebres="Sorry your request was not successfull contact System admin";
								}
								request.getSession().setAttribute("response", rebres);
								rd.forward(request, response);
								break;
		case "RestartDomain":   
								String rest=rdom.restartDomain(domain,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
								String resres;
								rd=request.getRequestDispatcher("home.jsp");
								if(rest.equals("ok"))
								{
									resres="Your Domain Restart Request is Under Process Contact Your Admin in case of any problems";
									
								}
								else
								{
									resres="Sorry your request was not successfull contact System admin";
								}
								request.getSession().setAttribute("response", resres);
								rd.forward(request, response);
								break;
		case "StartDomain":  String stdom=sd.startDomain(domain,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
							 String stres;
							 rd=request.getRequestDispatcher("home.jsp");
							 if(stdom.equals("ok"))
							 {
								 stres="Your Domain Start Request is Under Process Contact Your Admin in case of any problems";
								 
							 }
							 else
							 {
								 stres="Sorry your request was not successfull contact System admin";
							 }
							 request.getSession().setAttribute("response", stres);
							 rd.forward(request, response);
							 break;
							
		case "StopDomain": String stopdom=std.stopDomain(domain,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
						   String stopres;
						   rd=request.getRequestDispatcher("home.jsp");
						   if(stopdom.equals("ok"))
						   {
							   stopres="Your Domain Stop Request is Under Process Contact Your Admin in case of any problems";
							   
						   }
						   else
						   {
							   stopres="Sorry your request was not successfull contact System admin";
						   }
						   request.getSession().setAttribute("response", stopres);
						   rd.forward(request, response);
						   break;
		case "StartService": String sername=request.getParameter("servname");
							 String clasname=request.getParameter("classname");
							 String dispname=request.getParameter("dispname");
							 String startserv;
							 String stresp=stserv.startService(domain, sername, clasname, dispname,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
							 rd=request.getRequestDispatcher("/control?operation=GetServiceListFromDomain&domain="+domain+"");
							 if(stresp.equals("ok"))
							   {
								   startserv="Your Service Start Request is Under Process Contact Your Admin in case of any problems";
								   
							   }
							   else
							   {
								   startserv="Sorry your request was not successfull contact System admin";
							   }
							   request.getSession().setAttribute("servresp", startserv);
							   rd.forward(request, response);
							   break;
		case "StopService": String servname=request.getParameter("servname");
							String claname=request.getParameter("classname");
							String disname=request.getParameter("dispname");
							String stpserv;
							String stesp=stopserv.stopService(domain, servname, claname, disname,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
							rd=request.getRequestDispatcher("/control?operation=GetServiceListFromDomain&domain="+domain+"");
							if(stesp.equals("ok"))
							{
								stpserv="Your Service Stop Request is Under Process Contact Your Admin in case of any problems";
								
							}
							else
							{
								stpserv="Sorry your request was not successfull contact System admin";
							}
							request.getSession().setAttribute("servresp", stpserv);
							rd.forward(request, response);
							break;
		case "Quiesce": rd=request.getRequestDispatcher("home.jsp");
						String type=request.getParameter("type");
						String time=request.getParameter("time");
						String qres=q.quiesce(domain, time, type,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
						rd=request.getRequestDispatcher("home.jsp");
						String quresp;
						if(qres.equals("ok"))
						{
							quresp="Your Quiesce Request is Under Process Contact Your Admin in case of any problems";
							
						}
						else
						{
							quresp="Sorry your request was not successfull contact System admin";
						}
						request.getSession().setAttribute("response", quresp);
						rd.forward(request, response);
						break;
		case "Unquiesce":	rd=request.getRequestDispatcher("home.jsp");
							String utype=request.getParameter("type");
							String uqres=uq.unquiesce(domain,utype,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
							rd=request.getRequestDispatcher("home.jsp");
 							String uquresp;
							if(uqres.equals("ok"))
							{
								uquresp="Your Unquiesce Request is Under Process Contact Your Admin in case of any problems";
			
							}
							else
							{
								uquresp="Sorry your request was not successfull contact System admin";
							}
							request.getSession().setAttribute("response", uquresp);
							rd.forward(request, response);
							break;
		case "CreateDomain": rd=request.getRequestDispatcher("home.jsp");
							 String admstate=request.getParameter("adminstate");
							 String cpyfrm=request.getParameter("copyfrom");
							 String cpyto=request.getParameter("copyto");
							 String dlt=request.getParameter("delete");
							 int crtres=cd.createDomain(domain,admstate,cpyfrm,cpyto,dlt,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("rport").toString());
							 String crtresp;
							 if(crtres==201)
							 {
								 crtresp="Your Domain "+domain+"was Created Succesfully";
							 }
							 else
							 {
								 crtresp="Sorry,Request was Unsuccessful";
							 }
							 request.getSession().setAttribute("response", crtresp);
							 rd.forward(request, response);
							 break;
		case "UpdateDomain": rd=request.getRequestDispatcher("home.jsp");
							 String uadmstate=request.getParameter("adminstate");
							 String ucpyfrm=request.getParameter("copyfrom");
							 String ucpyto=request.getParameter("copyto");
							 String udlt=request.getParameter("delete");
							 int updres=ud.updateDomain(domain,uadmstate,ucpyfrm,ucpyto,udlt,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("rport").toString());
							 String updresp;
							 if(updres==200)
							 {
								 updresp="Your Domain "+domain+"was Updated Succesfully";
							 }
							 else
							 {
								 updresp="Sorry,Request was Unsuccessful";
							 }
							 request.getSession().setAttribute("response", updresp);
							 rd.forward(request, response);
							 break;
		case "ExportService":rd=request.getRequestDispatcher("DomainServices.jsp");
							 String eservname=request.getParameter("servname");
							 String eservclass=request.getParameter("classname");
							 System.out.println(eservclass +":"+eservname);
							 byte[] expresp=es.exportService(domain,eservname,eservclass, request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
							 response.setContentType("application/octet-stream");
							 response.setContentLength(expresp.length);
							  String headerKey5 = "Content-Disposition";
							  String headerValue5 = String.format("attachment; filename=\"%s\"",eservname+" Export.zip");
							  response.setHeader(headerKey5, headerValue5);
							  OutputStream outStream5 = response.getOutputStream();
							  outStream5.write(expresp);
							  break;
		case "DeleteService":String delclassname=request.getParameter("classname");
		 					 String delobname=request.getParameter("servname");
		 					 String delresp=gro.getInterServices(domain, delclassname, delobname,"false",request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
		 					 rd=request.getRequestDispatcher("DeleteServices.jsp");
		 					 request.getSession().setAttribute("domain", domain);
		 					 request.getSession().setAttribute("name", delobname);
		 					 request.getSession().setAttribute("classname", delclassname);
		 					 request.getSession().setAttribute("objects", delresp);
		 					 rd.forward(request, response);
		 					 break;
		case "DeleteServiceConf": String delcclassname=request.getParameter("classname");
								  String delcobname=request.getParameter("servname");
								  String[] exserv=request.getParameterValues("exserv");
								  String exfiles=request.getParameter("exfiles");
								  String delcresp=dserv.deleteService(domain,delcobname,delcclassname,exserv, exfiles,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
								  rd=request.getRequestDispatcher("/control?operation=GetServiceListFromDomain&domain="+domain);
								  request.getSession().setAttribute("servresp", "Your "+delcobname+" Service Was Deleted Successfully");
								  rd.forward(request, response);
								  break;
		case "SearchLogs": 	 String searchstr=request.getParameter("str");
							 String filter=request.getParameter("filter");
							 String level=request.getParameter("level");
							 List<String> sresp=sl.search(domain,searchstr,level,filter,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("rport").toString());
							 rd=request.getRequestDispatcher("SearchLogs.jsp");
							 request.getSession().setAttribute("logs", sresp);
							 request.getSession().setAttribute("domain", domain);
							 request.getSession().setAttribute("str", searchstr);
							 System.out.println("Domain is:"+domain);
							 rd.forward(request, response);
							 break;
		case "Ping":		 rd=request.getRequestDispatcher("home.jsp");
							 String ping=request.getParameter("host");
							 String pingout;
							 String pingres=ph.ping(ping,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
							 System.out.println(pingres);
							 if(pingres.contains("OK"))
							 {
								 pingout="Your Ping request to "+ping+"Was Successful";
							 }
							 else
							 {
								 pingout="Your Ping request to "+ping+"Went Something Wrong Check your Datapower Network/Host";
							 }
							 request.getSession().setAttribute("response", pingout);
							 rd.forward(request, response);
							 break;
		case "TCPConnection": rd=request.getRequestDispatcher("home.jsp");
		 					  String tping=request.getParameter("host");
		 					 String tport=request.getParameter("port");
		 					  String tpingout;
		 					  String tpingres=tct.testTcp(tping,tport,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
		 					  System.out.println(tpingres);
		 					  if(tpingres.contains("OK"))
		 					  {
		 						  tpingout="Your TCP Connection request to "+tping+" on port "+tport+"Was Successful";
		 					  }
		 					  else
		 					  {
		 						  tpingout=tpingres;
		 					  }
		 					  request.getSession().setAttribute("response", tpingout);
		 					  rd.forward(request, response);
		 					  break;
		case "Statistics":rd=request.getRequestDispatcher("/stats");
						  System.out.println("Statistics are rendering");
						  rd.forward(request, response);
						  break;
		case "SecureBackup": rd=request.getRequestDispatcher("CryptoArtifacts.jsp");
							 String sname=request.getParameter("name");
							 String sclass=request.getParameter("class");
							 String sdom=request.getSession().getAttribute("domain").toString();
							 byte[] b=es.exportService(request.getSession().getAttribute("domain").toString(), sname, sclass,request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
							 response.setContentType("application/octet-stream");
						        response.setContentLength(b.length);
						        String sheaderKey = "Content-Disposition";
						        String sheaderValue = String.format("attachment; filename=\"%s\"","CryptoObject_"+sname+".zip");
						        response.setHeader(sheaderKey, sheaderValue);
						       OutputStream soutStream = response.getOutputStream();
						        soutStream.write(b);
								break;
		case "TCPTable": 	rd=request.getRequestDispatcher("TCPPortStatus.jsp");
	    						List<HashMap<String,String>> tcpports=tt.getPorts();
	    						request.getSession().setAttribute("portlist", tcpports);
	    						rd.forward(request, response);
	    						break;
		case "XMLManager": 	rd=request.getRequestDispatcher("XMLManagers.jsp");
							List<HashMap<String,String>> xmlmanagers=xm.getXMLManagers(domain);
							request.getSession().setAttribute("xmllist", xmlmanagers);
							request.getSession().setAttribute("domain", domain);
							rd.forward(request, response);
							break;
		case "flush":		rd=request.getRequestDispatcher("/control?operation=XMLManager&domain="+domain);
							String xmlname=request.getParameter("name");
							String cacheres=fsc.flushCache(domain, xmlname, request.getSession().getAttribute("host").toString(),request.getSession().getAttribute("xport").toString());
							if(cacheres.contains("OK"))
							{
								request.getSession().setAttribute("message","Cache Has Been Flushed Successfully for "+xmlname+"XML Manager");
							}
							else
							{
								request.getSession().setAttribute("message","Something Went Wrong While Performing Action to Flush Cache of  "+xmlname+"XML Manager");
							}
							rd.forward(request, response);
							break;
							 
							 
						
				
		}
		}
		else
		{
			rd=request.getRequestDispatcher("index.jsp");
			request.getSession().setAttribute("user", null);
			request.getSession().invalidate();
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
	public void destroy()
	{
		for (Thread t : Thread.getAllStackTraces().keySet()) {
	        if (t.getName().equals("sst")) 
	        {
	        	t.stop();
	        	System.out.println("Thread Stopped");
	        }
	    }
	}
	

}
