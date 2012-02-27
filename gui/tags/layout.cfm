<cfif thistag.executionmode is "start">
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>cfrbac gui</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  	<link href="resources/js/chosen.css" rel="stylesheet">
    <style>
      body {
        padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
      }
    </style>
  </head>

  <body>

    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="#">CFRBAC Admin</a>
          <div class="nav-collapse">
            <ul class="nav">
              <li class="active"><a href="index.cfm">Home</a></li>
              <li><a href="roles.cfm">Roles</a></li>
              <li><a href="perms.cfm">Permissions</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

    <div class="container">
<cfelse>
    </div> 

	<script src="resources/js/jquery-1.7.1.min.js"></script>
    <script src="resources/bootstrap/js/bootstrap.min.js"></script>
	<script src="resources/js/chosen.jquery.min.js"></script>

  </body>
</html>
</cfif>
