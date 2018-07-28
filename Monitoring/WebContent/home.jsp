<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.List,javax.servlet.*"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
    <%@page import="java.util.*,com.eidiko.MonitorSSLExpiry" %>
 <%@ page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
Thread mse=new Thread(new MonitorSSLExpiry(session.getAttribute("host").toString(),session.getAttribute("xport").toString()));
mse.setName("mse");
mse.start();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<script type="text/javascript">
 function check(value)
 {
	 	hideAll();
	 	var set=new RegExp("Set");
		var get=new RegExp("Get");
		if(set.test(value))
			{
				if(!get.test(value))
					{location.replace("SetConfig.jsp");}
			
			}
		if(value == 'GetDeviceInfo'){
			document.getElementById("ping").style.display="none";
		}
	switch(value)
	{
	case "Ping":document.getElementById("ping").style.display="inline";break;
	case "TCPConnection":document.getElementById("tcp").style.display="inline";break;
	case "SearchLogs":location.replace("SearchLogs.jsp");break;
	case "GetDeviceInfo":location.replace("home.jsp");break;
	case "CreateDomain":
	case "UpdateDomain":document.getElementById("domain").style.display="inline";document.getElementById("dom").style.display="inline";break;
	case "DeleteFile": document.getElementById("domain").style.display="inline";document.getElementById("file").style.display="inline";break;
	case "DeleteService":document.getElementById("domain").style.display="inline";document.getElementById("service").style.display="inline";break;
	case "GetReferencedObjects":document.getElementById("domain").style.display="inline";document.getElementById("service").style.display="inline";break;
	case "StopService":document.getElementById("domain").style.display="inline";document.getElementById("service").style.display="inline";break;
	case "StartService":document.getElementById("domain").style.display="inline";document.getElementById("service").style.display="inline";break;
	case "GetServiceListFromDomain":document.getElementById("domain").style.display="inline";break;
	case "GetInterDependentServices": document.getElementById("domain").style.display="inline";document.getElementById("service").style.display="inline";break;
	case "GetServiceListFromExport":document.getElementById("domain").style.display="inline";document.getElementById("file").style.display="inline";break;
	case "CompareConfig": document.getElementById("files").style.display="inline";break;
	case "GetCryptoArtifacts":
	case "RestartDomain":
	case "StopDomain":
	case "StartDomain":
	case "DeleteDomain":
	case "GetDomainConfig":
	case "GetDomainExport":document.getElementById("domain").style.display="inline";break;
	case "Quiesce": document.getElementById("ques").style.display="inline";document.getElementById("times").style.display="inline";break;
	case "Unquiesce":document.getElementById("ques").style.display="inline";break;
	case "Reboot":document.getElementById("modes").style.display="inline";break;
	case "GetErrorReport":
	case "Statistics":
	case "GetDomainList": 
	case "GetDomainStatus":document.getElementById("opselect").submit(); break;
	}
	
	return false;
 };
 function hideAll()
 {
	 document.getElementById("domain").style.display="none";
	 document.getElementById("file").style.display="none";
	 document.getElementById("service").style.display="none";
	 document.getElementById("dom").style.display="none";
	 document.getElementById("tcp").style.display="none";
	 document.getElementById("ping").style.display="none";
	 document.getElementById("times").style.display="none";
	 document.getElementById("ques").style.display="none";
	 document.getElementById("modes").style.display="none";
 };
 function swit(value)
 {
 
 if(value == "Domain")
	 {
	 document.getElementById("domain").style.display="inline";
	 
	 }
 else
	 {
	 document.getElementById("domain").style.display="none";
	 }
 return false;
 };
  function converttobase64() {
	  var files = document.getElementById("infile").files;
	  
	  if (files.length > 0) {
	    getBase64(files[0]);
	    return false;
	  }
	};

	function getBase64(file) {
	   var reader = new FileReader();
	   reader.readAsDataURL(file);
	   reader.onload = function () {
	     
	     document.getElementById("base64").value=reader.result.split(",")[1];
	   };
	   reader.onerror = function (error) {
	     console.log('Error: ', error);
	   }
	};
</script>
</head>
<body>
<h3 align="right">Welcome ${user} <form action="Logout"><input type="submit" Value="Logout"/></form></h3>
<h1 align="center">Welcome to Datapower Gateways</h1>
<table height="100%" width="100%"><tr>



<p style="color: blue;">${response}</p>

<td width="30%">
<h3>Device Details:</h3>
<table align="left" border="1">
<c:forEach items="${other}" var="element">
<tr>
<td>${fn:substringBefore(element, ':')}</td>
    <td>${fn:substringAfter(element, ':')}</td>
    </tr>
</c:forEach>
</table>
</td>
<td width="30%">
<h3>Device Features:</h3>
<table align="left" border="1">
<c:forEach items="${feature}" var="element">
<tr>
<td><c:out value="${element}"/></td>   
</c:forEach>
</table>
</td>
<td width="40%">
<h3>Device Operations:</h3>
<form action="control" id="opselect">
<select id="op" name="operation" onchange="return check(this.value)">
<c:forEach items="${operation}" var="element">
<option value="${element}"><c:out value="${element}"/></option>
   
</c:forEach>
<option value="GetApplianceLog">GetApplianceLog</option>
<option value="CreateDomain">CreateDomain</option>
<option value="UpdateDomain">UpdateDomain</option>
<option value="SearchLogs">SearchLogs</option>
<option value="Statistics">Statistics</option>
<option value="TCPConnection">TCPConnection</option>
<option value="TCPTable">TCPPortStatus</option>
<option value="XMLManager">XMLManager</option>
</select >
<div id="domain" style="display:none">
Domain:<input  type="text"  name="domain"/><br/>
</div>
<div id="file" style="display:none">

Location:<input  type="text"  name="location"/><br/>
FileName:<input  type="text"  name="fname"/><br/>
File:<input type="file" name="file"/>
</div>
<div id="modes" style="display:none">
<select name="mode">
<option value="reboot">reboot</option>
<option value="reload">reload</option>
</select><br/>
</div>
<div id="service" style="display:none">
ServiceName:<input  type="text"  name="servname"/><br/>
Class:<select id="classname" name="classname">
<option value="MultiProtocolGateway">MultiProtocolGateway</option>
<option value="WSGateway">WSGateway</option>
<option value="XMLFirewallService">XMLFirewallService</option>
<option value="XSLProxyService">XSLProxyService</option>
<option value="WebAppFW">WebAppFW</option>
<option value="HTTPService">HTTPService</option>
</select><br/>
DisplayClassName:
<select id="dispname" name="dispname">
<option value="Multi-Protocol Gateway">Multi-Protocol Gateway</option>
<option value="Web Service Proxy">Web Service Proxy</option>
<option value="XML Firewall Service">XML Firewall Service</option>
<option value="XSL Proxy Service">XSL Proxy Service</option>
<option value="Web Application Firewall">Web Application Firewall</option>
<option value="HTTP Service">HTTP Service</option>
</select><br/>
</div>
<div id="ques" style="display:none">
Quiescie/Unquiesce:<select id="type" name="type" onchange="return swit(this.value)">
<option value="Device">Device</option>
<option value="Domain">Domain</option>
</select><br/>
<div id="times" style="display:inline">Timeout:<input type="text" id="time" name="time" />sec</div>
</div>
<div id="dom" style="display:none">
AdminState:<select name="adminstate">
<option value="disabled">disabled</option>
<option value="enabled">enabled</option>
</select>
CopyFrom:<select name="copyfrom">
<option value="on">on</option>
<option value="off">off</option>
</select>
CopyTo:<select name="copyto">
<option value="on">on</option>
<option value="off">off</option>
</select>
Delete:<select name="delete">
<option value="on">on</option>
<option value="off">off</option>
</select>
</div>
<div id="ping" style="display:inline">Remote Host:<input type="text" name="host"/></div>
<div id="tcp" style="display:none">Remote Host:<input type="text" name="host"/><br/>Remote Port:<input type="text" name="port"/></div>
<input type="text" id="base64" value="Base64 String" name="base64" style="display: none;"/>
<br/>
<input type="submit" Value="Try"/>
</form>
</td>
</tr></table>
</body>
</html>