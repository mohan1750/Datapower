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
<h1 align="center">Available XML Managers in ${domain} Domain</h1>



<a href="home.jsp">Back</a>
<p style="color: red;">${message}</p>
<table align="left" border="1">
<tr><th>Name</th><th>State</th><th>CacheSize</th><th>MaxNodeSize</th><th>MaxNodeNames</th><th>UserAgent</th><th>Operations</th></tr>
<c:forEach items="${xmllist}" var="element">
<tr>
<td>${element.name}</td>
<td>${element.state}</td>
<td>${element.CacheSize}</td>
<td>${element.MaxNodeSize}</td>
<td>${element.MaxNodeNames}</td>
<td>${element.UserAgent}</td>
<td><a href="/control?operation=flush&name=${element.name}&domain=${domain}">FlushCache</a></td>
</tr>
</c:forEach>
</table>


</body>
</html>