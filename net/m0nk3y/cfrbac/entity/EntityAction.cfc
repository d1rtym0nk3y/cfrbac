component persistent="true" table="cfrbac_EntityAction" {

	property name="ID" fieldtype="id" generator="native";
	property name="Entity"; 
	property name="Action" fieldtype="many-to-one" cfc="net.m0nk3y.cfrbac.entity.Action" fkcolumn="fkActionID" ;

}
