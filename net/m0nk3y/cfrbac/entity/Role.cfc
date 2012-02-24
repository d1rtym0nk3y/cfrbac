component persistent="true" table="cfrbac_Role" {

	property name="ID" fieldtype="id" generator="native";
	property name="Name" notnull="true";
	property name="Permissions" fieldtype="many-to-many" cfc="net.m0nk3y.cfrbac.Permission" 
		singularname="Permission" linktable="cfrbac_RolePermissions" 
		fkcolumn="fkRoleID" inversejoincolumn="fkPermissionID"; 

}
