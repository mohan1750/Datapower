<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="shortcut icon" href="img/ibm-icon.ico" />
<meta name="description" content="">
<meta name="author" content="">

<title>IBM Datapower Developer Console</title>

<!-- Bootstrap core CSS-->
<script src="js/jquery-3.3.1.min.js"></script>
    <script src="js/gijgo.min.js" type="text/javascript"></script>
    <link href="css/gijgo.min.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="vendor/bootstrap/css/bootstrap.min.css">
     <link href="css/font-awesome.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.css" rel="stylesheet" type="text/css"> 

    <!-- Page level plugin CSS-->
    <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="css/sb-admin.css" rel="stylesheet">
</head>

<body id="page-top">

	<nav class="navbar navbar-expand navbar-dark bg-dark static-top">

		<a class="navbar-brand mr-1" href="index.html">IBM Datapower</a>

		<button class="btn btn-link btn-sm text-white order-1 order-sm-0"
			id="sidebarToggle" href="#">
			<i class="fas fa-bars"></i>
		</button>

		<!-- Navbar Search -->
		<form
			class="d-none d-md-inline-block form-inline ml-auto mr-0 mr-md-3 my-2 my-md-0">
			<div class="input-group">
				<input type="text" class="form-control" placeholder="Search for..."
					aria-label="Search" aria-describedby="basic-addon2">
				<div class="input-group-append">
					<button class="btn btn-primary" type="button">
						<i class="fas fa-search"></i>
					</button>
				</div>
			</div>
		</form>

		<!-- Navbar -->
		<ul class="navbar-nav ml-auto ml-md-0">
			<li class="nav-item dropdown no-arrow mx-1"><a
				class="nav-link dropdown-toggle" href="#" id="alertsDropdown"
				role="button" data-toggle="dropdown" aria-haspopup="true"
				aria-expanded="false"> <i class="fas fa-bell fa-fw"></i> <span
					class="badge badge-danger">9+</span>
			</a>
				<div class="dropdown-menu dropdown-menu-right"
					aria-labelledby="alertsDropdown">
					<a class="dropdown-item" href="#">Action</a> <a
						class="dropdown-item" href="#">Another action</a>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="#">Something else here</a>
				</div></li>
			<li class="nav-item dropdown no-arrow mx-1"><a
				class="nav-link dropdown-toggle" href="#" id="messagesDropdown"
				role="button" data-toggle="dropdown" aria-haspopup="true"
				aria-expanded="false"> <i class="fas fa-envelope fa-fw"></i> <span
					class="badge badge-danger">7</span>
			</a>
				<div class="dropdown-menu dropdown-menu-right"
					aria-labelledby="messagesDropdown">
					<a class="dropdown-item" href="#">Action</a> <a
						class="dropdown-item" href="#">Another action</a>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="#">Something else here</a>
				</div></li>
			<li class="nav-item dropdown no-arrow"><a
				class="nav-link dropdown-toggle" href="#" id="userDropdown"
				role="button" data-toggle="dropdown" aria-haspopup="true"
				aria-expanded="false"> <i class="fas fa-user-circle fa-fw"></i>
			</a>
				<div class="dropdown-menu dropdown-menu-right"
					aria-labelledby="userDropdown">
					<a class="dropdown-item" href="#">Settings</a> <a
						class="dropdown-item" href="#">Activity Log</a>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="#" data-toggle="modal"
						data-target="#logoutModal">Logout</a>
				</div></li>
		</ul>

	</nav>

	<div id="wrapper">

		<!-- Sidebar -->
		<ul class="sidebar navbar-nav">
			<li class="nav-item"><a class="nav-link" href="home.jsp"> <i
					class="fas fa-fw fa-tachometer-alt"></i> <span>Dashboard</span>
			</a></li>
			<li class="nav-item dropdown"><a class="nav-link"
				href="admin.jsp"> <i class="fas fa-fw fa-server"></i> <span>Administration</span>
			</a></li>
			<li class="nav-item"><a class="nav-link" href="stats.jsp"> <i
					class="fas fa-fw fa-chart-area"></i> <span>Statistics</span></a></li>
			<li class="nav-item active"><a class="nav-link" href="#"> <i
					class="fas fa-fw fa-table"></i> <span>Development</span></a></li>
		</ul>

		<div id="content-wrapper">

			<div class="container-fluid">

				<!-- Breadcrumbs-->
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a href="#">Development</a></li>
					<li class="breadcrumb-item active">Services</li>
				</ol>

				<!-- DataTables Example -->
				<div class="card mb-3">
					<div class="card-header">
						<i class="fas fa-table"></i> Service Management
					</div>
					<div class="card-body">
						<form class="form-inline">

							<label for="exampleDomain" class="form-text">Domain</label>
							&nbsp; <select id="domain" name="domain" class="form-control"
								placeholder="">
								<optgroup>

								</optgroup>
							</select> &nbsp; &nbsp; <label for="exampleProvider" class="form-text">Provider</label>
							&nbsp; <select id="provider" name="provider" class="form-control"
								placeholder="">
								<optgroup>
									<option value="">----- Select -----</option>
								</optgroup>
							</select> &nbsp; &nbsp;
							<button type="button" class="btn btn-primary" id="ServiceButton">Get
								Services</button>


						</form>
						<br />
						<br />
						<div class="row" >
							<div class="col-9" id="optionbar">
								<form class="form-inline">
									<input id="txtName" type="text" placeholder="ServiceName..."
										class="form-control mb-2 mr-sm-2 mb-sm-0" /> <input
										id="txtURI" type="text"
										placeholder="URI..."
										class="form-control mb-2 mr-sm-2 mb-sm-0" />

									<button id="btnSearch" type="button" class="btn btn-default">Search</button>
									&nbsp;
									<button id="btnClear" type="button" class="btn btn-default">Clear</button>
								</form>
							</div>
							<div class="col-3">
								<button id="btnAdd" type="button"
									class="btn btn-default float-right">Add New Record</button>
							</div>
						</div>
						<div class="row" style="margin-top: 10px">
							<div class="col-12">
								<table id="grid"></table>
							</div>
						</div>
					</div>

					<div id="dialog" style="display: none">
						<input type="hidden" id="ID" />
						<form>
							<div class="form-group">
								<label for="Name">Name</label> <input type="text"
									class="form-control" id="Name">
							</div>
							<div class="form-group">
								<label for="PlaceOfBirth">Place Of Birth</label> <input
									type="text" class="form-control" id="PlaceOfBirth" />
							</div>
							<button type="button" id="btnSave" class="btn btn-default">Save</button>
							<button type="button" id="btnCancel" class="btn btn-default">Cancel</button>
						</form>
					</div>
				</div>
				<div class="card-footer small text-muted">Updated yesterday at
					11:59 PM</div>
			</div>

			<p class="small text-center text-muted my-5">
				<em>More table examples coming soon...</em>
			</p>

		</div>
		<!-- /.container-fluid -->

		<!-- Sticky Footer -->
		<footer class="sticky-footer">
			<div class="container my-auto">
				<div class="copyright text-center my-auto">
					<span>Copyright © Your Website 2018</span>
				</div>
			</div>
		</footer>

	</div>
	<!-- /.content-wrapper -->


	<!-- /#wrapper -->

	<!-- Scroll to Top Button-->
	<a class="scroll-to-top rounded" href="#page-top"> <i
		class="fas fa-angle-up"></i>
	</a>

	<!-- Logout Modal-->
	<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body">Select "Logout" below if you are ready
					to end your current session.</div>
				<div class="modal-footer">
					<button class="btn btn-secondary" type="button"
						data-dismiss="modal">Cancel</button>
					<a class="btn btn-primary" href="index.jsp">Logout</a>
				</div>
			</div>
		</div>
	</div>


	

    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="vendor/jquery-easing/jquery.easing.min.js"></script>
    <script src="js/sb-admin.min.js"></script>
	<!-- Demo scripts for this page-->
	
	<script type="text/javascript">
        var grid, dialog;
        var tabdata=[];
		/*data = [
                { 'ID': 1, 'Name': 'Hristo Stoichkov', 'PlaceOfBirth': 'Plovdiv, Bulgaria' },
                { 'ID': 2, 'Name': 'Ronaldo Luís Nazário de Lima', 'PlaceOfBirth': 'Rio de Janeiro, Brazil' },
                { 'ID': 3, 'Name': 'David Platt', 'PlaceOfBirth': 'Chadderton, Lancashire, England' },
                { 'ID': 4, 'Name': 'Manuel Neuer', 'PlaceOfBirth': 'Gelsenkirchen, West Germany' },
                { 'ID': 5, 'Name': 'James Rodríguez', 'PlaceOfBirth': 'Cúcuta, Colombia' },
                { 'ID': 6, 'Name': 'Dimitar Berbatov', 'PlaceOfBirth': 'Blagoevgrad, Bulgaria' }
            ];*/
        function Edit(e) {
            $('#ID').val(e.data.id);
            $('#Name').val(e.data.record.Name);
            $('#PlaceOfBirth').val(e.data.record.PlaceOfBirth);
            dialog.open('Edit Player');
        }
        function Save() {
            var record = {
                ID: $('#ID').val(),
                Name: $('#Name').val(),
                PlaceOfBirth: $('#PlaceOfBirth').val()
            };
            $.ajax({ url: '/Players/Save', data: { record: record }, method: 'POST' })
                .done(function () {
                    dialog.close();
                    grid.reload();
                })
                .fail(function () {
                    alert('Failed to save.');
                    dialog.close();
                });
        }
        
        function Delete(e) {
            if (confirm('Are you sure?')) {
                $.ajax({ url: '/Players/Delete', data: { id: e.data.id }, method: 'POST' })
                    .done(function () {
                        grid.reload();
                    })
                    .fail(function () {
                        alert('Failed to delete.');
                    });
            }
        }
        $(document).ready(function () {
           
            $('optionbar').hide();
            dialog = $('#dialog').dialog({
                uiLibrary: 'bootstrap4',
                iconsLibrary: 'fontawesome',
                autoOpen: false,
                resizable: false,
                modal: true
            });
            $('#btnAdd').on('click', function () {
                $('#ID').val('');
                $('#Name').val('');
                $('#PlaceOfBirth').val('');
                dialog.open('Add Player');
            });
            $('#btnSave').on('click', Save);
            $('#btnCancel').on('click', function () {
                dialog.close();
            });
            $('#btnSearch').on('click', function () {
                grid.reload({ ServiceName: $('#txtName').val(), URI: $('#txtURI').val() });
            });
            $('#btnClear').on('click', function () {
                $('#txtName').val('');
                $('#txtURI').val('');
                grid.reload({ ServiceName: '', URI: '' });
            });
            var myNewURL = "developer";
            window.history.pushState({}, document.title, "/" + myNewURL );
            history.pushState(null, null, location.href);
            window.onpopstate = function () {
                history.go(1);
            }; 
            
            $.getJSON('/domains', function (data) {
            	var list=data.domain;
            	$('#domain').append('<option value="">---Select---</option>');
                $.each(list, function (index, value) {
                    // APPEND OR INSERT DATA TO SELECT ELEMENT.
                    
                    $('#domain').append('<option value="' + value.name + '">' + value.name + '</option>');
                });
            });
            $("#ServiceButton").click(function(){
        		var domain=$('#domain').val();
        		var provider=$('#provider').val();
        		 // DataTables rendering
        		
        		$.ajax('/developservices?domain='+domain+"&provider="+provider)
            	.done(function(entries){
            		var error=entries.error;
            		if(!error){
            			/*var list=data.filestore.location.file;
            			$.each(list, function (index, value) {
                            // APPEND OR INSERT DATA TO SELECT ELEMENT.
                            $('#provider').append('<option value="' + value.name.split("_")[0] + '">' + value.name.split("_")[0] + '</option>');
                        }); */
                        
                        var data=[];
                        tabdata=entries;
                        $.each(entries, function (index, value) {
                            // APPEND OR INSERT DATA TO SELECT ELEMENT.
                            
                           var entry={};
                            entry.ID=index+1;
                            entry.ServiceName=value.ServiceMetadata.OperationName;
                            entry.Method=value.method;
                            entry.URI=value.match;
                            entry.Transformation=value.ServiceMetadata.ServiceTransformation;
                            entry.AAA=value.RouterMetadata.Authorize.enabled;
                            entry.TargetApp=value.ServiceMetadata.TargetConfig.name;
                           
                            data.push(entry);
                        });
                        
                        grid= $('#grid').grid({
                            primaryKey: 'ID',
                            dataSource: data,
                            uiLibrary: 'bootstrap4',
                            columns: [
                                { field: 'ID', width: 48 },
                                { field: 'ServiceName',title: 'Service Name', sortable: true },
                                { field: 'Method',title: 'Protocol Method'},
                                { field: 'URI', title: 'Service URI', sortable: true },
                                { field: 'Transformation',title: 'Transformation'},
                                { field: 'AAA',title: 'AAA Enabled'},
                                { field: 'TargetApp',title: 'Target APP'},
                                { title: '', field: 'Edit', width: 42, type: 'icon', icon: 'fa fa-edit', tooltip: 'Edit', events: { 'click': Edit } },
                                { title: '', field: 'Delete', width: 42, type: 'icon', icon: 'fa fa-remove', tooltip: 'Delete', events: { 'click': Delete } }
                            ],
                            resizableColumns: true,
                            detailTemplate: '<div id="tree"></div>',
                            pager: { limit: 5, sizes: [2, 5, 10, 20] }
                        });
                       alert("TableData: "+JSON.stringify(tabdata));
                       grid.on('detailExpand', function (e, $detailWrapper, id) {
               			var treedata=tabdata[id-1];
               			$('#tree').tree({
                              
                               dataSource:treedata
                              
                           });
                       });
                       grid.on('detailCollapse', function (e, $detailWrapper, id) {
                           $detailWrapper.find('table').grid('destroy', true, true);
                       });
            		}
            		else{
            			alert("No Services available with selected provider:"+provider);
            			
            		}
            		
            	});
        		
        		 
        	});
            $("#provider").change(function () {
            	$('#grid').grid('destroy', true, true);
            });
            
            $("#domain").change(function () {
        	    var str = "";
        	    str=$('#domain').val();
        	    
                var jqxhr=$.ajax('/providers?domain='+str)
                	.done(function(data){
                		
                		var error=data.error;
                		if(!error){
                			var list=data.filestore.location.file;
                			$.each(list, function (index, value) {
                                // APPEND OR INSERT DATA TO SELECT ELEMENT.
                                $('#provider').append('<option value="' + value.name.split("_")[0] + '">' + value.name.split("_")[0] + '</option>');
                            });
                		}
                		else{
                			$('#provider option').remove();
                			$('#provider').append('<option value="">---Select---</option>');
                		}
                        
                	});
                	
                
        	    	
        	  })
        	  .change();
        });
    </script>
</body>

</html>
