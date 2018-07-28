<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.google.gson.*" %>
<html>
<head>
<style>
div.pos_right {
    position: absolute;
    bottom: 50px;
    right: 0;
}
</style>
</head>
<body>


<script type="text/javascript" src="http://static.fusioncharts.com/code/latest/fusioncharts.js"></script>
<!--
        Include the `fusioncharts.php` file that contains functions  to embed the charts.
-->
        <%@page import="fusioncharts.FusionCharts" %>
<h1 align="center">Datapower Appliance Statistics</h1>
<div id="refresh" align="right"><a href="/stats">Refresh</a></div><br/>
	<div id="refresh" align="right"><a href="home.jsp">Back</a></div>
	<table>
	<tr><td><div id="cpu"></div></td><td><div id="memstat"></div></td> </tr>
	<tr><td><div id="memory"></div></td><td><div id="filestat"></div></td></tr>
	<tr><td><div id="connections"></div></td></tr>
	</table>
    
    

    
     
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
        chartobj.put("caption" , "CPU Load Statistics");
        chartobj.put("paletteColors" , "#0075c2");
        chartobj.put("bgColor" , "#ffffff");
        chartobj.put("borderAlpha", "20");
        chartobj.put("xaxisname","Hour");
        chartobj.put("yaxisname","CPU Load %");
        chartobj.put("numbersuffix","%");
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
        chartobj2.put("caption" , "Memory Usage Statistics");
        chartobj2.put("paletteColors" , "#0075c2");
        chartobj2.put("bgColor" , "#ffffff");
        chartobj2.put("borderAlpha", "20");
        chartobj2.put("xaxisname","Hour");
        chartobj2.put("yaxisname","Memory Usage");
        chartobj2.put("numbersuffix","%");
        chartobj2.put("canvasBorderAlpha", "0");
        chartobj2.put("usePlotGradientColor", "0");
        chartobj2.put("plotBorderAlpha", "10");
        chartobj2.put("showXAxisLine", "1");
        chartobj2.put("xAxisLineColor" , "#999999");
        chartobj2.put("showValues" , "0");
        chartobj2.put("divlineColor" , "#999999");
        chartobj2.put("divLineIsDashed" , "1");
        chartobj2.put("showAlternateHGridColor" , "0");
        
        //Memory Pie Chart Chart Layout
		Map<String, String> chartobj3 = new HashMap<String, String>();  
        chartobj3.put("caption" , "Memory Storage Statistics");
        chartobj3.put("subcaption" , "Current Usage");
        chartobj3.put("startingangle" , "120");
        chartobj3.put("showlabels", "0");
        chartobj3.put("showlegend", "1");
        chartobj3.put("enablemultislicing", "0");
        chartobj3.put("slicingdistance", "15");
        chartobj3.put("showpercentvalues", "1");
        chartobj3.put("showpercentintooltip" , "0");
        chartobj3.put("plottooltext" , "$label as : $datavalue");
        chartobj3.put("theme" , "ocean");
        
      //File System Pie Chart Chart Layout
      		Map<String, String> chartobj4 = new HashMap<String, String>();  
              chartobj4.put("caption" , "File System Storage Statistics");
              chartobj4.put("subcaption" , "Current Storage Space");
              chartobj4.put("startingangle" , "120");
              chartobj4.put("showlabels", "0");
              chartobj4.put("showlegend", "1");
              chartobj4.put("enablemultislicing", "0");
              chartobj4.put("slicingdistance", "15");
              chartobj4.put("showpercentvalues", "1");
              chartobj4.put("showpercentintooltip" , "0");
              chartobj4.put("plottooltext" , "$label of : $datavalue");
              chartobj4.put("theme" , "ocean");
       //For Connections Chart
       
       Map<String, String> chartobj5= new HashMap<String, String>();       
        chartobj5.put("caption" , "Domain Connections Statistics");
        chartobj5.put("paletteColors" , "#0075c2");
        chartobj5.put("bgColor" , "#ffffff");
        chartobj5.put("borderAlpha", "20");
        chartobj5.put("xaxisname","Hour");
        chartobj5.put("yaxisname","Average Connections Accepted");
        chartobj5.put("numbersuffix","/min");
        chartobj5.put("canvasBorderAlpha", "0");
        chartobj5.put("usePlotGradientColor", "0");
        chartobj5.put("plotBorderAlpha", "10");
        chartobj5.put("showXAxisLine", "1");
        chartobj5.put("xAxisLineColor" , "#999999");
        chartobj5.put("showValues" , "0");
        chartobj5.put("divlineColor" , "#999999");
        chartobj5.put("divLineIsDashed" , "1");
        chartobj5.put("showAlternateHGridColor" , "0");
        
        List<HashMap<String,String>> list1=(List<HashMap<String,String>>)request.getSession().getAttribute("cpu");
        List<HashMap<String,String>> list2=(List<HashMap<String,String>>)request.getSession().getAttribute("memory");
        List<HashMap<String,String>> list3=(List<HashMap<String,String>>)request.getSession().getAttribute("memstat");
        List<HashMap<String,String>> list4=(List<HashMap<String,String>>)request.getSession().getAttribute("filestat");
        List<HashMap<String,String>> list5=(List<HashMap<String,String>>)request.getSession().getAttribute("connections");
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
     // For Memeory Usage Pie charts
        ArrayList arrData3 = new ArrayList();
        for(int i=0;i<list3.size();i++)
        {
            
            arrData3.add(list3.get(i));             
        }
     // For File System Usage Pie charts
        ArrayList arrData4 = new ArrayList();
        for(int i=0;i<list4.size();i++)
        {
            
            arrData4.add(list4.get(i));             
        }
        //For Connections Accepted
        ArrayList arrData5 = new ArrayList();
        for(int i=0;i<list5.size();i++)
        {
            
            arrData5.add(list5.get(i));             
        }
        
        //close the connection.
        

        //create 'dataMap' map object to make a complete FC datasource.
        
         Map<String, String> dataMap = new LinkedHashMap<String, String>();
         Map<String, String> dataMap2 = new LinkedHashMap<String, String>();
         Map<String, String> dataMap3 = new LinkedHashMap<String, String>();
         Map<String, String> dataMap4 = new LinkedHashMap<String, String>();
         Map<String, String> dataMap5 = new LinkedHashMap<String, String>();
    /* 
        gson.toJson() the data to retrieve the string containing the
        JSON representation of the data in the array.
    */ //Renders CPU Chart
         dataMap.put("chart", gson.toJson(chartobj));
         dataMap.put("data", gson.toJson(arrData));
         //Renders Memory chart
         dataMap2.put("chart", gson.toJson(chartobj2));
         dataMap2.put("data", gson.toJson(arrData2));
         // Renders Memory Pie Chart
         dataMap3.put("chart", gson.toJson(chartobj3));
         dataMap3.put("data", gson.toJson(arrData3));
         //Renders File System Piee Chart
         dataMap4.put("chart", gson.toJson(chartobj4));
         dataMap4.put("data", gson.toJson(arrData4));
         //Renders Connections Accepted
         dataMap5.put("chart", gson.toJson(chartobj5));
         dataMap5.put("data", gson.toJson(arrData5));
         
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
                    "750","400",// chartWidth, chartHeight
                    "cpu",// chartContainer
                    "json",// dataFormat
                    gson.toJson(dataMap) //dataSource
                );
    		FusionCharts column2DChart1= new FusionCharts(
                    "column2d",// chartType
                    "chart2",// chartId
                    "750","400",// chartWidth, chartHeight
                    "memory",// chartContainer
                    "json",// dataFormat
                    gson.toJson(dataMap2) //dataSource
                );
    		FusionCharts pie3DChart= new FusionCharts(
                    "pie3d",// chartType
                    "chart3",// chartId
                    "750","400",// chartWidth, chartHeight
                    "memstat",// chartContainer
                    "json",// dataFormat
                    gson.toJson(dataMap3) //dataSource
                );
    		FusionCharts pie3DChart1= new FusionCharts(
                    "pie3d",// chartType
                    "chart4",// chartId
                    "750","400",// chartWidth, chartHeight
                    "filestat",// chartContainer
                    "json",// dataFormat
                    gson.toJson(dataMap4) //dataSource
                );
    		FusionCharts column2DChart2= new FusionCharts(
                    "column2d",// chartType
                    "chart5",// chartId
                    "750","400",// chartWidth, chartHeight
                    "connections",// chartContainer
                    "json",// dataFormat
                    gson.toJson(dataMap5) //dataSource
                );
       
        %>
        
<!--    Step 5: Render the chart    -->                
        <%=column2DChart.render()%>
        <%=column2DChart1.render()%>
        <%=pie3DChart.render()%>
        <%=pie3DChart1.render()%>
        <%=column2DChart2.render()%>
        </body>
</html>
