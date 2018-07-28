<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.List,javax.servlet.*"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
    <%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.google.gson.*" %>
 <%@page import="fusioncharts.FusionCharts" %>
 <%@ page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

</head>
<body>
<script type="text/javascript" src="http://static.fusioncharts.com/code/latest/fusioncharts.js"></script>
<h3 align="right">Welcome ${user} <form action="Logout"><input type="submit" Value="Logout"/></form></h3>
<h1 align="center">Welcome to Datapower Gateways</h1>

<h3>Available Services In ${domain} Domain</h3><a href="home.jsp">Get Back</a>
<p style="color: red;">${servresp}</p>
<table align="left" border="1">

<tr><th>Name</th><th>Service Type</th><th>ClassName</th><th>UserComments</th><th>AdminState</th><th>OperationalState</th><th>ConfigState</th><th>QuiesceState</th><th colspan="4">Operations</th></tr>
<c:forEach items="${services}" var="element">
<tr>
<td><a href="control?domain=${domain}&classname=${element.classname}&obname=${element.name}&user=${user}&pass=${pass}&operation=GetReferencedObjects">${element.name}</a></td>
<td>${element.displayname}</td>
<td>${element.classname}</td>
<td>${element.UserComments}</td>
<td>${element.AdminState}</td>
<td>${element.OpState}</td>
<td>${element.ConfigState}</td>
<td>${element.QuiesceState}</td>
<td><a href="control?operation=StartService&servname=${element.name}&classname=${element.classname}&dispname=${element.displayname}&domain=${domain}">Start</a></td>
<td><a href="control?operation=StopService&servname=${element.name}&classname=${element.classname}&dispname=${element.displayname}&domain=${domain}">Stop</a></td>
<td ><a href="control?operation=ExportService&servname=${element.name}&classname=${element.classname}&domain=${domain}">Export</a></td>
<td ><a href="control?operation=DeleteService&servname=${element.name}&classname=${element.classname}&domain=${domain}">Delete</a></td>
    </tr>
</c:forEach>
</table><br/>

<h1>Service Statistics</h1>
<form action="/control">
<input type="hidden" value="GetServiceListFromDomain" name="operation"/>
<input type="hidden" value="${domain}" name="domain"/>
Show Statistics Last:<select name="duration">
<option value="oneMinute">1 Min</option>
<option value="tenSeconds">10 Sec</option>
<option value="tenMinutes">10 Min</option>
<option value="oneHour">1 Hour</option>
<option value="oneDay">1 Day</option>
</select>
<input type="submit" value="Show"/><div id="refresh" align="right"><a href="/control?operation=GetServiceListFromDomain&domain=${domain}">Refresh</a></div><br/>


</form>
<table>
	<tr><td><div id="transactions"></div></td><td><div id="transactiontimes"></div></td> </tr>
	</table>
	
	<!-- Charts Coding start -->
	<%
     /*
        google-gson

        Gson is a Java library that can be used to convert Java Objects into 
        their JSON representation. It can also be used to convert a JSON string to 
        an equivalent Java object. Gson can work with arbitrary Java objects including
        pre-existing objects that you do not have source-code of.
        link : https://github.com/google/gson    
     */

        Gson gson = new Gson();
        
        
        // Form the SQL query that returns the top 10 most populous countries
        
        // The 'chartobj' map object holds the cpu chart attributes and data.
        Map<String, String> chartobj = new HashMap<String, String>();       
        chartobj.put("caption" , "Service Transactions In Last "+request.getSession().getAttribute("duration"));
        chartobj.put("paletteColors" , "#0075c2");
        chartobj.put("bgColor" , "#ffffff");
        chartobj.put("borderAlpha", "20");
        chartobj.put("xaxisname","Service");
        chartobj.put("yaxisname","Transactions count(no)");
        chartobj.put("numbersuffix"," per min");
        chartobj.put("canvasBorderAlpha", "0");
        chartobj.put("usePlotGradientColor", "0");
        chartobj.put("plotBorderAlpha", "10");
        chartobj.put("showXAxisLine", "1");
        chartobj.put("xAxisLineColor" , "#999999");
        chartobj.put("showValues" , "0");
        chartobj.put("divlineColor" , "#999999");
        chartobj.put("divLineIsDashed" , "1");
        chartobj.put("showAlternateHGridColor" , "0");
        // Chart layout for Memory
		Map<String, String> chartobj2 = new HashMap<String, String>();  
        chartobj2.put("caption" , "Service Transaction times In Last "+request.getSession().getAttribute("duration"));
        chartobj2.put("paletteColors" , "#0075c2");
        chartobj2.put("bgColor" , "#ffffff");
        chartobj2.put("borderAlpha", "20");
        chartobj2.put("xaxisname","Service");
        chartobj2.put("yaxisname","Transaction time");
        chartobj2.put("numbersuffix","ms");
        chartobj2.put("canvasBorderAlpha", "0");
        chartobj2.put("usePlotGradientColor", "0");
        chartobj2.put("plotBorderAlpha", "10");
        chartobj2.put("showXAxisLine", "1");
        chartobj2.put("xAxisLineColor" , "#999999");
        chartobj2.put("showValues" , "0");
        chartobj2.put("divlineColor" , "#999999");
        chartobj2.put("divLineIsDashed" , "1");
        chartobj2.put("showAlternateHGridColor" , "0");
        
        
        
        List<HashMap<String,String>> list1=(List<HashMap<String,String>>)request.getSession().getAttribute("transactions");
        List<HashMap<String,String>> list2=(List<HashMap<String,String>>)request.getSession().getAttribute("transactiontimes");
        
     // For CPU Charts
        ArrayList arrData = new ArrayList();
        for(int i=0;i<list1.size();i++)
        {
            
            arrData.add(list1.get(i));             
        }
        // For Memeory charts
        ArrayList arrData2 = new ArrayList();
        for(int i=0;i<list2.size();i++)
        {
            
            arrData2.add(list2.get(i));             
        }
    
        
        //close the connection.
        

        //create 'dataMap' map object to make a complete FC datasource.
        
         Map<String, String> dataMap = new LinkedHashMap<String, String>();
         Map<String, String> dataMap2 = new LinkedHashMap<String, String>();
        
    /*
        gson.toJson() the data to retrieve the string containing the
        JSON representation of the data in the array.
    */ //Renders CPU Chart
         dataMap.put("chart", gson.toJson(chartobj));
         dataMap.put("data", gson.toJson(arrData));
         //Renders Memory chart
         dataMap2.put("chart", gson.toJson(chartobj2));
         dataMap2.put("data", gson.toJson(arrData2));
         
         
/*
    Create an object for the column chart using the FusionCharts JSP class constructor. 
    Syntax for the constructor -
  new FusionCharts("type of chart", 
  "unique chart id", 
  "width of chart", 
  "height of chart", 
  "div id to render the chart", 
  "type of data", 
  "actual data in string format")
         
    Because we are using JSON data to render the chart, the data format will be `json`. 
    The object `dataMap` holds all the JSON data for the chart, 
    and will be passed as the value for the data source parameter of the constructor.
*/
        FusionCharts column2DChart= new FusionCharts(
                    "column2d",// chartType
                    "chart1",// chartId
                    "600","400",// chartWidth, chartHeight
                    "transactions",// chartContainer
                    "json",// dataFormat
                    gson.toJson(dataMap) //dataSource
                );
    		FusionCharts column2DChart1= new FusionCharts(
                    "column2d",// chartType
                    "chart2",// chartId
                    "600","400",// chartWidth, chartHeight
                    "transactiontimes",// chartContainer
                    "json",// dataFormat
                    gson.toJson(dataMap2) //dataSource
                );
    		
       
        %>
        
<!--    Step 5: Render the chart    -->                
        <%=column2DChart.render()%>
        <%=column2DChart1.render()%>
        
	
	<!-- Charts Coding END -->
	
	
</body>
</html>