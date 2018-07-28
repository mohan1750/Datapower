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
<script src="jquery.js"></script>
<script>
function converttobase64() {
	  var files = document.getElementById("infile").files;
	  
	  if (files.length > 0) {
	    getBase64(files[0]);
	    return false;
	  }
	};
	function show(value)
	{
		var op=document.getElementById("op").value;
		if(new RegExp("Domain").test(value))
			{
			document.getElementById("dom").style.display="inline";
			document.getElementById("files").style.display="none";
			document.getElementById("firms").style.display="none";
			}
		else if(new RegExp("File").test(value))
			{
			document.getElementById("dom").style.display="inline";
			document.getElementById("files").style.display="inline";
			document.getElementById("firms").style.display="none";
			}
		else if(new RegExp("Firm").test(value))
		{
		document.getElementById("dom").style.display="none";
		document.getElementById("files").style.display="none";
		document.getElementById("firms").style.display="inline";
		}
		else
			{
			document.getElementById("dom").style.display="none";
			document.getElementById("files").style.display="none";
			document.getElementById("firms").style.display="none";
			}
	}

	function getBase64(file) {
	   var reader = new FileReader();
	   reader.readAsDataURL(file);
	   reader.onload = function () {
	     var domain=document.getElementById("domain").value;
	     
	     document.getElementById("base64").value=reader.result.split(",")[1];	
	     document.form1.submit();
	   };
	   reader.onerror = function (error) {
	     console.log('Error: ', error);
	   }
	};
	$("#form1").submit(function(e)
			{
			 
			    var formObj = $(this);
			    var formURL = formObj.attr("action");
			    var formData = new FormData(this);
			    $.ajax({
			        url: formURL,
			    type: 'POST',
			        data:  formData,
			    mimeType:"multipart/form-data",
			    contentType: false,
			        cache: false,
			        processData:false,
			    success: function(data, textStatus, jqXHR)
			    {
			 
			    },
			     error: function(jqXHR, textStatus, errorThrown) 
			     {
			     }          
			    });
			    e.preventDefault(); //Prevent Default action. 
			    e.unbind();
			}); 
			$("#form1").submit();

</script>
</head>
<body>
<h3 align="right">Welcome ${user} <form action="Logout"><input type="submit" Value="Logout"/></form></h3>
<h1 align="center">Set Configuration</h1>



<form name="form1" action="upload" enctype="multipart/form-data"  method="post">
Operation:<select id="op" name="op" onchange="return show(this.value)">
<option value="SetFirmware">SetFirmware</option>
<option value="SetDeviceSettings">SetDeviceSettings</option>
<option value="SetDomainConfig">SetDomainConfig</option>
<option value="SetDomainExport">SetDomainExport</option>
<option value="SetFile">SetFile</option>
</select><a href="home.jsp">Back</a><br/>
<div id="dom" style="display:none">Domain:<input type="text" name="domain" id="domain"/><br/></div>
<div id="files" style="display:none">Location:<input type="text" name="loc" id="loc"/><br/>FileName:<input type="text" name="fname" id="fname"/><br/></div>
<div id="firms" style="display:inline">AcceptLicense:<select name="accept"><option value="true">true</option><option value="false">false</option></select></div>

<input type="hidden" id="base64" value="Base64 String" name="base64" readonly="readonly"/>
<br/>
</form>
File:<input type="file" id="infile" name="file"/><br/>
<input type="button" id="button" value="Upload" onclick="converttobase64()"/><br/>

</body>
</html>