component persistent="true" table="cfrbac_Permission" {

	property name="ID" fieldtype="id" generator="native";
	property name="Type"; // global, table, object
	property name="Entity"; // name of the orm entity this perm applies to
	property name="Action" fieldtype="many-to-one" cfc="net.m0nk3y.cfrbac.entity.Action" fkcolumn="fkActionID";
	property name="Condition" default="";

}
