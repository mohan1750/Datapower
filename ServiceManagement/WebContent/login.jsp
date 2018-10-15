<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
body, h1,h2,h3,h4,h5,h6 {font-family: "Montserrat", sans-serif}
.w3-row-padding img {margin-bottom: 12px}
/* Set the width of the sidebar to 120px */
.w3-sidebar {width: 120px;background: #222;}
/* Add a left margin to the "page content" that matches the width of the sidebar (120px) */
#main {margin-left: 120px}
/* Remove margins from "page content" on small screens */
@media only screen and (max-width: 600px) {#main {margin-left: 0}}
</style>
</head>
<body class="w3-black">

<div class="w3-padding" id="main">
<h1 class="w3-jumbo w3-center"><span class="w3-hide-small">Datapower Login</span> </h1>
<p class="w3-text-red">${error}</p>
<form action="Login">
      <p>DataPower HostName<input class="w3-input w3-padding-16" type="text" placeholder="Datapower Host" required id="host" name="host"></p>
      <p>XML Port Number<input class="w3-input w3-padding-16" type="text" placeholder="XML Management Interface Port" required id="xport" name="xport"></p>
      <p>REST Port Number<input class="w3-input w3-padding-16" type="text" placeholder="REST Management Interface Port" required id="rport" name="rport"></p>
      <p>UserName<input class="w3-input w3-padding-16" type="text" placeholder="Datapower Admin Username" required name="name" id="name"></p>
      <p>Password<input class="w3-input w3-padding-16" type="text" placeholder="Datapower Admin Password" required name="pass" id="pass"></p>
      <p>
        <button class="w3-button w3-light-grey w3-padding-large w3-btn:hover" type="submit" onclick="return check()">
          <i class="fa fa-paper-plane"></i> Login
        </button>
      </p>
</form>
</div>
</body>
</html>