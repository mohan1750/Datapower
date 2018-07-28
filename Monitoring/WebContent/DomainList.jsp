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
<h1 align="center">Available Datapower Domains</h1>



<h3>Available Domains:</h3><a href="home.jsp">Back</a>
<table align="left" border="1">
<tr><th>Domain</th><th>Status</th><th/><th/></tr>
<c:forEach items="${domlist}" var="element">
<tr><td>${element}</td><td><a href="control?operation=GetStatus&domain=${element}">GetStatus</a></td>
<td><a href="control?operation=StartDomain&domain=${element}">Start</a></td>
<td><a href="control?operation=StopDomain&domain=${element}">Stop</a></td>
</tr>
</c:forEach>
</table>


</body>
</html>