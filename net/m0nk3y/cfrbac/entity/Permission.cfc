component persistent="true" table="cfrbac_Permission" {

	property name="ID" fieldtype="id" generator="native";
	property name="Type"; // global, table, object
	property name="EntityAction" fieldtype="many-to-one" cfc="net.m0nk3y.cfrbac.entity.EntityAction" fkcolumn="fkEntityAction" ;

}
