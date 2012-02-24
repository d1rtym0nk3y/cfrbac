component persistent="true" table="tests_User" {

	property name="ID" fieldtype="id" generator="native";
	property name="UserName";
	property name="Roles" fieldtype="many-to-many" singularname="Role" cfc="net.m0nk3y.cfrbac.entity.Role" linktable="tests_UserRoles"; 

	include "/net/m0nk3y/cfrbac/mixins/can.cfm"; 

}
