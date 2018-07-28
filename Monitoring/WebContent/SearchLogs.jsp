<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*,javax.servlet.*,java.text.*"%>
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
<h1 align="center">Search Logs</h1>

<form action="/control">
<input type="hidden" value="SearchLogs" name="operation"/>
Domain: <input type="text" name="domain" value="${domain}"/>&ensp;
SearchString: <input type="text" name="str" value="${str}"/>&ensp;
Log Level: <select name="level"><option>error</option><option>warning</option><option>debug</option><option>info</option></select>&ensp;
Filter Last: <select name="filter"><option>All</option><option>Today</option><option>1Hour</option><option>10 Mins</option></select>&ensp;
<input type="submit" value="Search"/>&ensp;<a href="home.jsp">Back</a>
</form>
<p style="color: green;">${fn:length(logs)} records Found :</p><br/>
<table id="logtable" border="1">
<tr><th>Date</th><th>Time</th><th>Domain</th><th>Error/EventCode</th><th>Log Category</th><th>Log Level</th><th>ObjectType</th><th>ObjectName</th><th>TransactionID</th><th>Error Message</th></tr>
<c:forEach items="${logs}" var="log" >
<c:set var = "string" value = "${fn:split(log, ' ')}"/>
<c:set var="date" value="${fn:substring(string[0],6,8)}-${fn:substring(string[0],4,6)}-${fn:substring(string[0],0,4)}"/>
<c:choose><c:when test = "${domain == 'default'}">
<c:set var = "domains" value = "${fn:substringAfter(fn:split(string[1],']')[0],'[')}"/>
<c:set var = "errorcode" value = "${fn:substringAfter(fn:split(string[1],']')[1],'[')}"/>
<c:set var = "cat" value = "${fn:substringAfter(fn:split(string[1],']')[2],'[')}"/>
<c:set var = "level" value = "${fn:substringAfter(fn:split(string[1],']')[3],'[')}"/>
</c:when><c:otherwise>
<c:set var = "domains" value = "${domain}"/>
<c:set var = "errorcode" value = "${fn:substringAfter(fn:split(string[1],']')[0],'[')}"/>
<c:set var = "cat" value = "${fn:substringAfter(fn:split(string[1],']')[1],'[')}"/>
<c:set var = "level" value = "${fn:substringAfter(fn:split(string[1],']')[2],'[')}"/>
</c:otherwise></c:choose>

<tr>
<td>${fn:substring(string[0],6,8)}-${fn:substring(string[0],4,6)}-${fn:substring(string[0],0,4)}</td>
<td>${fn:substring(string[0],9,11)}:${fn:substring(string[0],11,13)}:${fn:substring(string[0],13,15)}:${fn:substring(string[0],16,19)}</td>
 <td>${domains}</td>
<td>${errorcode}</td>
<td>${cat}</td>
<td>${level}</td>
<td>${fn:substringBefore(fn:substringBefore(string[2],':'),'(')}</td>
<td>${fn:substringBefore(fn:substringAfter(fn:substringBefore(string[2],':'),'('),')')}</td>
<td>${fn:substringBefore(fn:substringAfter(fn:substringBefore(string[3],':'),'tid('),')')}</td>
<td>${fn:substringAfter(log,string[3])}</td>
</tr>

</c:forEach>
</table>
</body>
</html>
