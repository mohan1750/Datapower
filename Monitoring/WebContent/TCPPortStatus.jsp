<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.List,javax.servlet.*"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
 <%@ page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<h3 align="right">Welcome ${user} <form action="Logout"><input type="submit" Value="Logout"/></form></h3>
<h1 align="center">Available Datapower Service Port Statistics</h1>



<h3>Available TCP Ports in All Domains</h3><a href="home.jsp">Back</a>
<table align="left" border="1">
<tr><th>LocalIP</th><th>LocalPort</th><th>RemoteIP</th><th>RemotePort</th><th>OperationalState</th><th>ServiceDomain</th><th>ServiceType</th><th>ServiceName</th></tr>
<c:forEach items="${portlist}" var="element">
<tr>
<td>${element.localIP}</td>
<td>${element.localPort}</td>
<td>${element.remoteIP}</td>
<td>${element.remotePort}</td>
<td>${element.state}</td>
<td>${element.serviceDomain}</td>
<td>${element.serviceClass}</td>
<td>${element.serviceName}</td>
</tr>
</c:forEach>
</table>


</body>
</html>