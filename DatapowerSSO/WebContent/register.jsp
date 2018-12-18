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

    <title>Datapower SSO - Register</title>

    <!-- Bootstrap core CSS-->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" type="text/css" href="css/shieldui.css" />
    <!-- Custom styles for this template-->
    <link href="css/sb-admin.css" rel="stylesheet">

  </head>

  <body class="bg-dark">

    <div class="container">
      <div class="card card-register mx-auto mt-5">
        <div class="card-header">Register Your Admin Account</div>
        <div class="card-body">
          <form name="form1">
          <p style="color: red;" align="center">${error}</p>
            <div class="form-group">
              <div class="form-row">
                <div class="col-md-6">
                  <div class="form-label-group">
                    <input type="text" id="firstName" class="form-control" placeholder="First name" required="required" autofocus="autofocus">
                    <label for="firstName">First name</label>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="form-label-group">
                    <input type="text" id="lastName" class="form-control" placeholder="Last name" required="required">
                    <label for="lastName">Last name</label>
                  </div>
                </div>
              </div>
            </div>
            <div class="form-group">
              <div class="form-row">
                <div class="col-md-6">
                  <div class="form-label-group">
                    <input type="text" id="adminid" class="form-control" placeholder="Admin UserName" required="required" autofocus="autofocus">
                    <label for="adminid">Admin UserName</label>
                  </div>
                </div>
                <div class="col-md-6" data-toggle="tooltip" title="Upload Profile Photo">
                <!-- <label for="exampleRole" class="form-text">Role</label> -->
                <input type="file" id="files" name="files" multiple="multiple" />
                <!-- <div class="form-label-group">   
                <select id="role" name="role" class="form-control" placeholder="">
                    <optgroup>
                        <option value="admin">Administrator</option>
                        <option value="develop">Developer</option>
                        <option value="monitor">Monitor</option>
                    </optgroup>
                </select>
                </div> -->
              </div>
              
            </div>
            </div>
            
            <div class="form-group">
	            <div class="form-row justify-content-md-center">
	            	<div class="col-lg-12">
              <div class="form-label-group">
              	<select id="role" name="role" class="form-control" data-toggle="tooltip" title="Select Role">
                    <optgroup>
                        <option value="admin">Administrator</option>
                        <option value="develop">Developer</option>
                        <option value="monitor">Monitor</option>
                    </optgroup>
                </select>
                </div>
              </div>
	            </div>
            </div>
            <button id="RegisterButton" type="button" class="btn btn-primary btn-block" onclick="return register()">Register</button>
          </form>
          <div class="text-center">
            <a class="d-block small mt-3" href="index.jsp">Login Page</a>
          </div>
        </div>
      </div>
    </div>
    <!-- Add User Modal  -->
	<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalCenterTitle">Admin account Registration status</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form action="#">
          <div class="form-group">
            <div id="response" class="col-form-label"></div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" id="ok">OK</button>
      </div>
    </div>
  </div>
</div>

    <!-- Bootstrap core JavaScript-->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="vendor/jquery-easing/jquery.easing.min.js"></script>
    <script type="text/javascript" src="js/shieldui.js"></script>
	<script type="text/javascript">
    jQuery(function ($) {
        $("#files").shieldUpload();
    });
    $(document).ready(function(){
        $('[data-toggle="tooltip"]').tooltip();
        var myNewURL = "signup";
        window.history.pushState({}, document.title, "/" + myNewURL );
    });
    function register(){

		var firstName=$('#firstName').val();
		var lastName=$('#lastName').val();
		var adminid=$('#adminid').val();
		var role=$('#role').val(); 
		var files = document.getElementById("files").files;
		var pic=null;
		if (files.length > 0) {
			var reader = new FileReader();
		 	   reader.readAsDataURL(files[0]);
		 	   reader.onload = function () {
		  	     pic=reader.result.split(",")[1];
		  	   var formData = {
			            "firstName": firstName,
			            "lastName": lastName,
			            "adminid": adminid,
			            "role": role,
			            "photo": pic
			        };
		  	 	$.ajax({
		            type        : 'POST', // define the type of HTTP verb we want to use (POST for our form)
		            url         : '/register', // the url where we want to POST
		            data        : JSON.stringify(formData), // our data object
		            dataType    : 'json', // what type of data do we expect back from the server
		            contentType: 'application/json',
		            mimeType: 'application/json',
		            encode      : true,
		            statusCode: {
		                202: function() {
		                	$('#response').html("<h4 class=\"alert alert-success\">User with AdminID<b> "+adminid+" </b>Already exists</h4>");
					    	$('#exampleModalCenter').modal();
		                }
		              }
		        })
		            // using the done promise callback
		            .done(function(data) {

		                // log data to the console so we can see
		                console.log(data); 
		                $('#response').html("<h4 class=\"alert alert-success\">User with AdminID<b> "+adminid+" </b>is On-boarded and sent for approval successfully</h4>");
				    	$('#exampleModalCenter').modal();
		                // here we will handle errors and validation messages
		            })
				.fail(function(data) {

			        // show any errors
			        // best to remove for production
			        console.log(data);
			        $('#response').html("<h4 class=\"alert alert-danger\">User Onboarding with AdminID<b> "+adminid+" </b>is Failed</h4>");
			    	$('#exampleModalCenter').modal();
			    });

		        // stop the form from submitting the normal way and refreshing the page
		        event.preventDefault();
			    return false;
		  	   };
		  	   reader.onerror = function (error) {
		  	     console.log('Error: ', error);
		  	   }
		  }
		
		
	};
    $("#ok").click(function(){
		 $('#exampleModalCenter').modal('hide');
		 $(location).attr("href", "index.jsp");
	});
</script>
  </body>

</html>
