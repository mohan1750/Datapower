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

<form action="/control">
<input type="hidden" name="operation" value="DeleteServiceConf"/>
Domain:<input type="text" name="domain" value="${domain}" readonly="readonly"/><br/>
Name:<input type="text" name="servname" value="${name}" readonly="readonly"/><br/>
ClassName:<input type="text" name="classname" value="${classname}" readonly="readonly"/><br/>
<p style="color: red;">${objects}</p>
<input type="submit" value="Delete"/> <a href="DomainServices.jsp">Cancel</a>
</form>
</body>
</html>
