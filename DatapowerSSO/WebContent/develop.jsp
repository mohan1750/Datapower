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
									class="btn btn-default float-right" data-target="#NewServiceModal" data-toggle="modal">Add New Service</button>
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
				<!--  <div class="card-footer small text-muted">Updated yesterday at
					11:59 PM</div>
			</div>

			<p class="small text-center text-muted my-5">
				<em>More table examples coming soon...</em>
			</p>-->

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
	
	<div class="modal fade" id="ShowSucess" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Status</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body"><p class="text-success">Service operations performed successfully</p></div>
				<div class="modal-footer">
					<button class="btn btn-secondary" type="button"
						data-dismiss="modal">Close</button>
					
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="ShowFail" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Status</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body"><p class="text-danger">Something went wrong in performing Service operations</p></div>
				<div class="modal-footer">
					<button class="btn btn-secondary" type="button"
						data-dismiss="modal">Close</button>
					
				</div>
			</div>
		</div>
	</div>
	
    <!-- New Service Modal-->
	<div class="modal fade" tabindex="-1" id="NewServiceModal" data-keyboard="false" data-backdrop="static" role="dialog">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                            <h4 class="modal-title">Service Management</h4>
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                
                            </div>
                            <div class="modal-body">
                                <form id="form1" name="form1">
                                    <div class="row"><h2>Service Metadata</h2></div>
                                    <div class="row">
                                       
                                        <div class="col">
                                            
                                            <div class="form-group">
                                                <label for="inputServiceName">Service Name</label>
                                                <input class="form-control" placeholder="Enter ServiceName" type="text"
                                                    id="inputServiceName" />
                                            </div>
                                            <div class="form-group">
                                                <label for="inputURIExp">Incoming URI</label>
                                                <input class="form-control" placeholder="Enter URI or RegExp" type="text"
                                                    id="inputURIExp" />
                                            </div>
                                            <div class="form-group">
                                                <label for="inputProtocol" class="form-text">Protocol Method</label>
                                                <select id="inputProtocol" name="inputProtocol" class="form-control" placeholder="">
                                                    <optgroup>
                                                        <option value="">---Select---</option>
                                                        <option value="GET">GET</option>
                                                        <option value="POST">POST</option>
                                                        <option value="PUT">PUT</option>
                                                        <option value="DELETE">DELETE</option>
                                                    </optgroup>
                                                </select>
                                            </div>
                                            <div class="form-group" id="checkEnabled">
                                                    <label for="checkAuthorize" class="form-text">Authorize Enabled</label>
                                                    <select id="checkAuthorize" name="checkAuthorize" class="form-control" placeholder="">
                                                        <optgroup>
                                                            <option value="">---Select---</option>
                                                            <option value="Y">Yes</option>
                                                            <option value="N">No</option>
                                                        </optgroup>
                                                    </select>
                                            </div>
                                            <div class="form-group" id="enabledEntry">
                                                    <label for="inputAuthorizedEntry">Authorized Account Name</label>
                                                    <input class="form-control" placeholder="Enter ADGroup or CN Name" type="text"
                                                        id="inputAuthorizedEntry" />
                                            </div>
                                            <div class="form-group">
                                                    <label for="logRule" class="form-text">Logging Rule</label>
                                                    <select id="logRule" name="logRule" class="form-control" placeholder="">
                                                        <optgroup>
                                                            <option value="">---Select---</option>
                                                            <option value="Common_Log_Rule">Common_Log_Rule</option>
                                                            <option value="Common_Log_Rule02">Common_Log_Rule02</option>
                                                        </optgroup>
                                                    </select>
                                            </div>
                                            <div class="form-group">
                                                    <label for="sourceFormat" class="form-text">Source Format</label>
                                                    <select id="sourceFormat" name="sourceFormat" class="form-control" placeholder="">
                                                        <optgroup>
                                                            <option value="">---Select---</option>
                                                            <option value="JSON">JSON</option>
                                                            <option value="XML">XML</option>
                                                            <option value="NONXML">NONXML</option>
                                                        </optgroup>
                                                    </select>
                                            </div>
                                            <div class="form-group">
                                                    <label for="targetFormat" class="form-text">Target Format</label>
                                                    <select id="targetFormat" name="targetFormat" class="form-control" placeholder="">
                                                        <optgroup>
                                                            <option value="">---Select---</option>
                                                            <option value="JSON">JSON</option>
                                                            <option value="XML">XML</option>
                                                            <option value="NONXML">NONXML</option>
                                                        </optgroup>
                                                    </select>
                                            </div>
                                        </div>
                                        <div class="col">
                                            <div class="form-group">
                                                    <label for="checkTransformation" class="form-text">Transformation Required</label>
                                                    <select id="checkTransformation" name="checkTransformation" class="form-control" placeholder="">
                                                        <optgroup>
                                                            <option value="">---Select---</option>
                                                            <option value="Y">Yes</option>
                                                            <option value="N">No</option>
                                                        </optgroup>
                                                    </select>
                                            </div>
                                            <div class="form-group">
                                                    <label for="conditionalRouting" class="form-text">Conditional Routing</label>
                                                    <select id="conditionalRouting" name="conditionalRouting" class="form-control" placeholder="">
                                                        <optgroup>
                                                            <option value="">---Select---</option>
                                                            <option value="Y">Yes</option>
                                                            <option value="N">No</option>
                                                        </optgroup>
                                                    </select>
                                            </div>
                                            <div id="condRouterEnabled">
                                            <div class="form-group">
                                                    <label for="routingType" class="form-text">Conditional Routing Type</label>
                                                    <select id="routingType" name="routingType" class="form-control" placeholder="">
                                                        <optgroup>
                                                            <option value="">---Select---</option>
                                                            <option value="xpath">xpath</option>
                                                            <option value="XSL">XSL</option>
                                                        </optgroup>
                                                    </select>
                                            </div>
                                            
                                            <div class="form-group">
                                                    <label for="inputroutingpattern">Conditional Routing Handler</label>
                                                    <input class="form-control" placeholder="Enter XPATH or XSL file path" type="text"
                                                        id="inputroutingpattern" />
                                            </div>
                                            </div>
                                            <div class="form-group">
                                                    <label for="targetApp">Target Application</label>
                                                    <input class="form-control" placeholder="Provider Application" type="text"
                                                        id="targetApp" readonly="readonly" />
                                            </div>
                                            <div class="form-group">
                                                    <label for="uriHandlerType" class="form-text">Routing Type</label>
                                                    <select id="uriHandlerType" name="uriHandlerType" class="form-control" placeholder="">
                                                        <optgroup>
                                                            <option value="">---Select---</option>
                                                            <option value="set">set</option>
                                                            <option value="copy">copy</option>
                                                            <option value="uri-in">uri-in</option>
                                                            <option value="blank">blank</option>
                                                            <option value="dyn">dyn</option>
                                                            <option value="dynXSL">dynXSL</option>
                                                        </optgroup>
                                                    </select>
                                            </div>
                                            <div class="form-group" id="urlHandler">
                                                    <label for="targetAppURI">URI or URI Handler Path</label>
                                                    <input class="form-control" placeholder="Provide XPATH or URI Handler XSL path" type="text"
                                                        id="targetAppURI" />
                                            </div>
                                        </div>
                                    </div>
                                    <hr style="border-top: 3px double #8c8b8b;">
                                    <div class="row"><h2>Service Transform Details</h2></div>
                                    <div class="row">
                                            
                                            <div class="col">
                                              <div id="sourceTransform">  
                                                <div class="form-group">
                                                    <label for="sourcetransformType" class="form-text">Source Transform type</label>
                                                    <select id="sourcetransformType" name="sourcetransformType" class="form-control" placeholder="">
                                                        <optgroup>
                                                            <option value="">---Select---</option>
                                                            <option value="JS">JS</option>
                                                            <option value="XSL">XSL</option>
                                                        </optgroup>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="sctransformPath">SC Transform</label>
                                                    <input class="form-control" placeholder="Enter CS Transform File path" type="text"
                                                        id="sctransformPath" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="cstransformPath">CS Transform</label>
                                                    <input class="form-control" placeholder="Enter SC Transform File path" type="text"
                                                        id="cstransformPath" />
                                                </div>
                                               </div>
                                                <div class="form-group">
                                                        <label class="col-md-12 control-label" for="rolename">Source Actions</label>
                                                        <div class="col-md-12">
                                                            <select id="sourceActions" class="multiselect-ui form-control" multiple="multiple">
                                                                <option value="STRIP-SOAP">STRIP-SOAP</option>
                                                                <option value="ADD-SOAP">ADD-SOAP</option>
                                                                <option value="HTTP-RQHEADER-HANDLER">HTTP-RQHEADER-HANDLER</option>
                                                                <option value="HTTP-RSHEADER-HANDLER">HTTP-RSHEADER-HANDLER</option>
                                                                <option value="MQ-RQHEADER-HANDLER">MQ-RQHEADER-HANDLER</option>
                                                                <option value="JMS-RQHEADER-HANDLER">JMS-RQHEADER-HANDLER</option>                                
                                                                <option value="custom">custom</option>
                                                            </select>
                                                        </div>
                                                </div>
                                                <div class="form-group" id="customSourcetransform">
                                                        <label for="customSourcetransformPath">Custom Source Transform</label>
                                                        <input class="form-control" placeholder="Enter Custom Transform File path" type="text"
                                                            id="customSourcetransformPath" />
                                                </div>
                                                
                                            </div>
                                            <div class="col">
                                            	<div id="targetTransform">
                                                    <div class="form-group">
                                                            <label for="targettransformType" class="form-text">Target Transform type</label>
                                                            <select id="targettransformType" name="targettransformType" class="form-control" placeholder="">
                                                                <optgroup>
                                                                    <option value="">---Select---</option>
                                                                    <option value="JS">JS</option>
                                                                    <option value="XSL">XSL</option>
                                                                </optgroup>
                                                            </select>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="tctransformPath">TC Transform</label>
                                                            <input class="form-control" placeholder="Enter CS Transform File path" type="text"
                                                                id="tctransformPath" />
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="cttransformPath">CT Transform</label>
                                                            <input class="form-control" placeholder="Enter SC Transform File path" type="text"
                                                                id="cttransformPath" />
                                                        </div>
                                                 </div>
                                                        <div class="form-group">
                                                                <label class="col-md-12 control-label" for="rolename">Target Actions</label>
                                                                <div class="col-md-12">
                                                                    <select id="targetActions" class="multiselect-ui form-control" multiple="multiple">                                                                        
                                                                        <option value="STRIP-SOAP">STRIP-SOAP</option>
                                                                        <option value="ADD-SOAP">ADD-SOAP</option>
                                                                        <option value="HTTP-RQHEADER-HANDLER">HTTP-RQHEADER-HANDLER</option>
                                                                        <option value="HTTP-RSHEADER-HANDLER">HTTP-RSHEADER-HANDLER</option>
                                                                        <option value="MQ-RQHEADER-HANDLER">MQ-RQHEADER-HANDLER</option>
                                                                        <option value="JMS-RQHEADER-HANDLER">JMS-RQHEADER-HANDLER</option>                                
                                                                        <option value="custom">custom</option>
                                                                    </select>
                                                                </div>
                                                        </div>
                                                        <div class="form-group" id="customTargettransform">
                                                                <label for="customTargettransformPath">Custom Target Transform</label>
                                                                <input class="form-control" placeholder="Enter Custom Transform File path" type="text"
                                                                    id="customTargettransformPath" />
                                                        </div>
                                            </div>
                                        </div>
                                        
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary" id="CreateServiceButton">Proceed</button>
                                <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
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
        dialog = $('#dialog').dialog({
            uiLibrary: 'bootstrap4',
            iconsLibrary: 'fontawesome',
            autoOpen: false,
            resizable: false,
            modal: true
        });
        function showServiceData(e){
        	
        	
        	
        	$('#inputProtocol').val(e.method);
        	$('#inputURIExp').val(e.match);
        	$('#conditionalRouting').val(e.ServiceMetadata.ConditionalRouting);
        	$('#inputServiceName').val(e.ServiceMetadata.OperationName);
        	$('#checkTransformation').val(e.ServiceMetadata.ServiceTransformation);
        	if(e.ServiceMetadata.ConditionalRouting == 'Y'){
            	$('#routingType').val(e.ServiceMetadata.Routing.type);
            	$('#inputroutingpattern').val(e.ServiceMetadata.Routing.content);
            	$('#condRouterEnabled').show();
            }
        	$('#sourceFormat').val(e.ServiceMetadata.SourceConfig.SourceFormat);
        	$('#targetFormat').val(e.ServiceMetadata.TargetConfig.TargetFormat);
        	$('#targetApp').val($('#provider').val());
        	$('#logRule').val(e.RouterMetadata.LogRule);
        	$('#checkAuthorize').val(e.RouterMetadata.Authorize.enabled);
        	if(e.RouterMetadata.Authorize.enabled == 'Y'){
        		
        		$('#inputAuthorizedEntry').val(e.RouterMetadata.Authorize['attribute-value'].content);
        		$('#enabledEntry').show();
        	}
        	if(e.ServiceMetadata.ServiceTransformation == 'Y'){
        		$('#sourcetransformType').val(e.ServiceMetadata.SourceConfig.TransformationType);
        		$('#sctransformPath').val(e.ServiceMetadata.SourceConfig.SCTransform);
        		$('#cstransformPath').val(e.ServiceMetadata.SourceConfig.CSTransform);
        		$('#targettransformType').val(e.ServiceMetadata.TargetConfig.TransformationType);
        		$('#tctransformPath').val(e.ServiceMetadata.TargetConfig.TCTransform);
        		$('#cttransformPath').val(e.ServiceMetadata.TargetConfig.CTTransform);
        		$('#targetTransform').show();
        		$('#sourceTransform').show();
        	}

        	
        	$('#NewServiceModal').modal('show');
        }
        function Edit(e) {
        	
        	showServiceData(tabdata[(e.data.id)-1]);
        	$("#form1 :input").prop("disabled", false);

        	$("#form1 :selected").prop("disabled", false);
        	$('#CreateServiceButton').show();
        }
        
        function loadGrid(data){
        	
        	var data=[];
            
            console.log(JSON.stringify(tabdata));
            $.each(tabdata, function (index, value) {
                // APPEND OR INSERT DATA TO SELECT ELEMENT.
                
               var entry={};
                if(value != null){
                entry.ID=index+1;
                entry.ServiceName=value.ServiceMetadata.OperationName;
                entry.Method=value.method;
                entry.URI=value.match;
                entry.Transformation=value.ServiceMetadata.ServiceTransformation;
                entry.AAA=value.RouterMetadata.Authorize.enabled;
                entry.TargetApp=value.ServiceMetadata.TargetConfig.name;
               
                data.push(entry);
                }
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
           //alert("TableData: "+JSON.stringify(tabdata));
           grid.on('detailExpand', function (e, $detailWrapper, id) {
   			var treedata=tabdata[id-1];
   			
   			showServiceData(treedata);
   			$("#form1 :input").prop("disabled", true);

        	$("#form1 :selected").prop("disabled", true);
        	$('#CreateServiceButton').hide();
           });
           grid.on('detailCollapse', function (e, $detailWrapper, id) {
               $detailWrapper.find('table').grid('destroy', true, true);
           });
        }
        function Delete(e) {
        	
        	console.log('Selected Service is: '+JSON.stringify(tabdata[(e.data.id)-1]));
        	
        	console.log('After Deletion of Service is: '+JSON.stringify(tabdata));
            if (confirm('Are you sure you want to delete service with name '+tabdata[(e.data.id)-1].ServiceMetadata.OperationName+'?')) {
            	delete tabdata[e.data.id-1];
            	$.ajax({
                    url: "/newService",
                    type: 'POST',
                    dataType: 'json',
                    data: JSON.stringify(tabdata),
                    contentType: 'application/json',
                    mimeType: 'application/json',
                    headers: {
                        'domain': $('#domain').val(),
                        'provider': $('#provider').val()
                    },
                    statusCode: {
                        201: function(responseObject, textStatus, jqXHR) {
                        	console.log( "Service Deleted" );
                        	
                        	$("#ShowSucess").modal({
                        		  fadeDuration: 1
                        		});
                        	$('#ShowSucess').modal('show');
                        	grid.removeRow(e.data.id);
                        },
                        501: function(responseObject, textStatus, errorThrown) {
                        	$("#ShowFail").modal({
                      		  fadeDuration: 1
                      		});
                        	$('#ShowFail').modal('show');
                        }
            	}});
                   
                
                
            }
        }
        $(document).ready(function () {
        	$('#enabledEntry').hide();
        	$('#targetTransform').hide();
    		$('#sourceTransform').hide();
    		$('#condRouterEnabled').hide();
    		$('#urlHandler').hide();
    		$('#customTargettransform').hide();
    		$('#customSourcetransform').hide();
            $('optionbar').hide();
            $('#btnAdd').prop('disabled', true);
            /* dialog = $('#dialog').dialog({
                uiLibrary: 'bootstrap4',
                iconsLibrary: 'fontawesome',
                autoOpen: false,
                resizable: false,
                modal: true
            }); */
            /*$('#btnAdd').on('click', function () {
                $('#ID').val('');
                $('#Name').val('');
                $('#PlaceOfBirth').val('');
                dialog.open('Add Player');
            });*/
           // $('#btnSave').on('click', Save);
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
            
            $("#CreateServiceButton").click(function(){
            	var newservice={};
            	var ServiceMetadata={};
            	var RouterMetadata={};
            	var SourceConfig={};
            	var TargetConfig={};
            	var Routing={};
            	var EndpointConfig={};
            	var Authorize={};
            	var attribute={};
            	
            	newservice.method=$('#inputProtocol').val();
            	newservice.match=$('#inputURIExp').val();
            	ServiceMetadata.ConditionalRouting=$('#conditionalRouting').val();
            	ServiceMetadata.OperationName=$('#inputServiceName').val();
            	ServiceMetadata.ServiceTransformation=$('#checkTransformation').val();
            	
            	if($('#conditionalRouting').val() == 'Y'){
            	Routing.type=$('#routingType').val();
            	Routing.content=$('#inputroutingpattern').val();
            	ServiceMetadata.Routing=Routing;
            	}
            	
            	SourceConfig.SourceFormat=$('#sourceFormat').val();
            	if($('#checkTransformation').val() == 'Y'){
            		SourceConfig.TransformationType=$('#sourcetransformType').val();
            		SourceConfig.SCTransform=$('#sctransformPath').val();
            		SourceConfig.CSTransform=$('#cstransformPath').val();
            	}
            	
            	TargetConfig.TargetFormat=$('#targetFormat').val();
            	TargetConfig.name=$('#targetApp').val();
            	EndpointConfig.TargetSystem=$('#targetApp').val();
            	TargetConfig.EndpointConfig=EndpointConfig;
            	if($('#checkTransformation').val() == 'Y'){
            		TargetConfig.TransformationType=$('#targettransformType').val();
            		TargetConfig.TCTransform=$('#tctransformPath').val();
            		TargetConfig.CTTransform=$('#cttransformPath').val();
            	}
            	
            	ServiceMetadata.SourceConfig=SourceConfig;
            	ServiceMetadata.TargetConfig=TargetConfig;
            	ServiceMetadata.Routing=Routing;
            	RouterMetadata.LogRule=$('#logRule').val();
            	Authorize.enabled=$('#checkAuthorize').val();
            	if($('#checkAuthorize').val() == 'Y'){
            		attribute.name ='member';
            		attribute.content =$('#inputAuthorizedEntry').val();
            		Authorize['attribute-value']=attribute;
            	}
            	RouterMetadata.Authorize=Authorize;
            	
            	newservice.ServiceMetadata=ServiceMetadata;
            	newservice.RouterMetadata=RouterMetadata;
            	
            	
            	tabdata.push(newservice);
            	/* if(!providers.include($('#targetApp').val())){
            		alert('Given provider was not avialable');
            	} */
            	//console.error('Created Service is:'+JSON.stringify(tabdata));
            	// Ajax Service start
            	$.ajax({
                    url: "/newService",
                    type: 'POST',
                    dataType: 'json',
                    data: JSON.stringify(tabdata),
                    contentType: 'application/json',
                    mimeType: 'application/json',
                    headers: {
                        'domain': $('#domain').val(),
                        'provider': $('#provider').val()
                    },
                    
                    statusCode: {
                        201: function(responseObject, textStatus, jqXHR) {
                        	console.log( "Service Created" );
                        	grid.addRow({ 'ID': grid.count(true) + 1, 'ServiceName': newservice.ServiceMetadata.OperationName, 'Method': newservice.method,'URI': newservice.match,'Transformation':newservice.ServiceMetadata.ServiceTransformation,'AAA': newservice.RouterMetadata.Authorize.enabled,'TargetApp':$('#provider').val()});
                        	$('#NewServiceModal').modal('hide');
                        	$("#ShowSucess").modal({
                        		  fadeDuration: 1
                        		});
                        	$('#ShowSucess').modal('show');
                        },
                        501: function(responseObject, textStatus, errorThrown) {
                        	alert( "Service Creation failed" );
                        	$('#NewServiceModal').modal('hide'); 
                        	$("#ShowFail").modal({
                      		  fadeDuration: 1
                      		});
                        	$('#ShowFail').modal('show');
                        	}
            	}
                });
            	// Ajax Service end
            });
            $("#ServiceButton").click(function(){
        		var domain=$('#domain').val();
        		var provider=$('#provider').val();
        		 // DataTables rendering
        		
                $('#targetApp').val(provider);
        		$.ajax('/developservices?domain='+domain+"&provider="+provider)
            	.done(function(entries){
            		var error=entries.error;
            		if(!error){
            			
                        tabdata=entries;
                      
                        loadGrid(tabdata);
                        $('#btnAdd').prop('disabled', false);
            		}
            		else{
            			alert("No Services available with selected provider:"+provider);
            			
            		}
            		
            	});
        		
        		 
        	});
            $("#provider").change(function () {
            	$('#grid').grid('destroy', true, true);
            	$('#btnAdd').prop('disabled', true);
            	
            });
            $('#checkAuthorize').change(function () {
            	var authcheck=$('#checkAuthorize').val();
            	if(authcheck != 'Y'){
            		$('#enabledEntry').hide();
            	}
            	else{
            		$('#enabledEntry').show();
            	}	
            
            });
            $('#checkTransformation').change(function(){
            	var authcheck=$('#checkTransformation').val();
            	if(authcheck != 'Y'){
            		$('#targetTransform').hide();
            		$('#sourceTransform').hide();
            	}
            	else{
            		$('#targetTransform').show();
            		$('#sourceTransform').show();
            	}	
            
            });
            $('#conditionalRouting').change(function(){
            		
            	var authcheck=$('#conditionalRouting').val();
            	if(authcheck != 'Y'){
            		$('#condRouterEnabled').hide();
            		
            	}
            	else{
            		$('#condRouterEnabled').show();
            		
            	}	
        	});
            $('#uriHandlerType').change(function(){
            	var authcheck=$('#uriHandlerType').val();
            	
            	if(authcheck == 'dyn' || authcheck == 'dynXSL'){
            		$('#urlHandler').show();
            		
            	}
            	else{
            		$('#urlHandler').hide();
            		
            	}	
            });
            $('#sourceActions').change(function(){
            	var entries = [];
            	
            	
            	$('#sourceActions option:selected').each(function() {
            		
            		entries.push($(this).text());
            	});
            	
            	
            	if(entries.includes('custom')){
            		$('#customSourcetransform').show();
            	}
            	else{
            		$('#customSourcetransform').hide();
            	}
            	
            });
			$('#targetActions').change(function(){
				
				var entries = [];
				$('#targetActions option:selected').each(function() {
            		
            		entries.push($(this).text());
            	});
            	if(entries.includes('custom')){
            		
            		$('#customTargettransform').show();
            	}
            	else{
            		$('#customTargettransform').hide();
            	}
            });
            $("#domain").change(function () {
        	    var str = "";
        	    $('#btnAdd').prop('disabled', true);
        	    str=$('#domain').val();
        	    $('#provider option').remove();
    			$('#provider').append('<option value="">---Select---</option>');
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
                		
                        
                	});
                	
                
        	    	
        	  })
        	  .change();
        });
    </script>
</body>

</html>
