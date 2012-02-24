component persistent="true" table="cfrbac_Permission" {

	property name="ID" fieldtype="id" generator="native";
	property name="Entity" notnull="true" default="";
	property name="Action" notnull="true";
	property name="Object" type="boolean" default="true";
	property name="Condition" default="";

}
