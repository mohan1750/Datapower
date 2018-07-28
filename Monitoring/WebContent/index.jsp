<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
    <%@page import="java.util.*,com.eidiko.StatusStorage,java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<script type="text/javascript">
function check()
{
	var host=document.getElementById("host").value;
	var xport=document.getElementById("xport").value;
	var rport=document.getElementById("rport").value;
	if(host=="" )
		{
		alert("Datapower hostname/IP is mandatory");
		return false;
		}
	else if(xport=="" )
		{
		alert("Datapower XML Management port is mandatory");
		return false;
		}
	else if(rport=="" )
	{
	if(confirm("You cant perform some operations without this port Are you sure to Proceed?")==false)
		{
		
		return false;
		}
	
	}
	
	}
</script>
</head>
<body>
<%
Thread sst=new Thread(new StatusStorage());
sst.setName("sst");
sst.start();
%>
<h1>IBM Datapower Monitoring Console</h1>
<p style="color: red;">${error}</p>
<form action="Login">

<table>
<tr><td>Datapower HostName</td><td><input type="text" id="host" name="host"/></td></tr>
<tr><td>XML Port Number</td><td><input type="text" id="xport" name="xport"/></td></tr>
<tr><td>REST Port Number</td><td><input type="text" id="rport" name="rport"/></td></tr>
<tr><td>Admin UserName</td><td><input type="text" name="name"/></td></tr>
<tr><td>Password</td><td><input type="password" name="pass"/></td></tr>
<tr><td colspan="2"><input type="submit"  value="Login" onclick="return check()"/></td></tr>
</table>
</form>
</body>
</html>