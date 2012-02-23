component persistent="true" table="tests_Object"  {

	property name="ID" fieldtype="id" generator="native";
	property name="Text" default="" ;
	property name="CreatedBy" cfc="User" fieldtype="many-to-one" fkcolumn="fkCreatedByUserID";  

}
