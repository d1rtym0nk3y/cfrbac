﻿component persistent="true" table="cfrbac_Role" {

	property name="ID" fieldtype="id" generator="native";
	property name="Name" notnull="true";
	property name="Permissions" fieldtype="many-to-many" cfc="CFRBAC_Permission" 
		singularname="Permission" linktable="cfrbac_RolePermissions" 
		fkcolumn="fkRoleID" inversejoincolumn="fkPermissionID"; 

}
