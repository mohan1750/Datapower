<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">

  <head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" href="img/ibm-icon.ico"/>
    <meta name="description" content="">
    <meta name="author" content="">

    <title>IBM Datapower Login</title>

    <!-- Bootstrap core CSS-->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template-->
    <link href="css/sb-admin.css" rel="stylesheet">

  </head>

  <body class="bg-dark">

    <div class="container">
      <div class="card card-login mx-auto mt-5">
        <div class="card-header">IBM Datapower Login</div>
        <div class="card-body">
          <form>
                <div class="form-group">
                        
                    <label for="exampleHost" class="form-text">Appliance</label>
                    <select id="host" name="host" class="form-control" placeholder="">
                        <optgroup>
                        	<option value="">---Select---</option>
                        </optgroup>
                    </select>
                    
                  </div>
            <div class="form-group">
                <div class="form-label-group">
                  <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
                  <input type="text" id="inputUserName" class="form-control" placeholder="Password" required data-error-msg="Please enter your User name.">
                  <label for="inputUserName">Username</label>
                </div>
              </div>
              <div class="form-group">
                <div class="form-label-group">
                  <input type="password" id="inputPassword" class="form-control" placeholder="Password" required data-error-msg="Please enter your Password">
                  <label for="inputPassword">Password</label>
                </div>
              </div>
              <div class="form-group">
                <label for="exampleRole" class="form-text">User Role</label>   
                <select id="role" name="role" class="form-control" placeholder="">
                    <optgroup>
                        <option value="admin">Administrator</option>
                        <option value="develop">Developer</option>
                        <option value="monitor">Monitor</option>
                    </optgroup>
                </select>
                </div>
                 <a class="btn btn-primary btn-block form-control" href="home.jsp">Login</a>
          </form>
              </div>

           
          <div class="text-center">
            <a class="d-block small mt-3" href="register.jsp">Register Here</a>
            <a class="d-block small" href="forgot-password.jsp">Forgot Password?</a>
          </div>
        </div>
      </div>
    </div>
	
	<!-- Add Appliance Modal  -->
	<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalCenterTitle">Add New Datapower Appliance</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form action="#">
          <div class="form-group">
            <div id="response" class="col-form-label"></div>
            <label for="newhost" class="col-form-label">Appliance Hostname:</label>
            <input type="text" class="form-control" id="newhost">
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" id="Addbutton">Add</button>
      </div>
    </div>
  </div>
</div>

    <!-- Bootstrap core JavaScript-->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="vendor/jquery-easing/jquery.easing.min.js"></script>
	<script>
	$(document).ready(function () {
		history.pushState(null, null, location.href);
	    window.onpopstate = function () {
	        history.go(1);
	    };
            
            var url = "/appliances";

            $.getJSON(url, function (data) {
                $.each(data, function (index, value) {
                    // APPEND OR INSERT DATA TO SELECT ELEMENT.
                    $('#host').append('<option value="' + value + '">' + value + '</option>');
                });
                $('#host').append('<option value="new">Add New Appliance</option>');
            });
        });
	$("#host").change(function () {
	    var str = "";
	    str=$('#host').val();
	    if(str.localeCompare('new') == 0){
	    	$('#exampleModalCenter').modal();
	    }
	  })
	  .change();
	$("#Addbutton").click(function(){
		var appl=$('#newhost').val();
		 $.ajax({url: "/addappliances?appl="+appl, success: function(result){
			 $('#response').html("<h4 class=\"alert alert-success\">Appliance with hostname<b> "+appl+" </b>is added successfully</h4>");
        } 
        //$('#response').html("<h4 class=\"alert alert-success\">Appliance with hostname<b> "+appl+" </b>is added successfully</h4>");
		});
		 $('#exampleModalCenter').modal('hide');
		 location.reload();
	});
	</script>
  </body>

</html>
