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
<h1 align="center">Welcome to Datapower Gateways</h1>

<h3>Crypto Certificates in ${domain} Domain</h3><a href="home.jsp">Get Back</a>
<table align="left" border="1">

<tr><th>Crypto Object Name</th><th>Object Class</th><th>Display Class Name</th><th>File Path</th><th>Operation</th></tr>
<c:forEach items="${crypto}" var="element">
<tr>
    <td>${element.name}</td>
    <td>${element.classname}</td>
    <td>${element.display}</td>
    <td>${element.fname}</td>
    <td><a href="/control?operation=SecureBackup&name=${element.name}&class=${element.classname}&display=${element.display}&fname=${element.fname}">Download</a></td>
    </tr>
</c:forEach>
</table>

</body>
</html>