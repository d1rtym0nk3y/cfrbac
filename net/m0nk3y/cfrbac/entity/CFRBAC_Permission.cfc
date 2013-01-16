component persistent="true" table="cfrbac_Permission" {

	property name="ID" fieldtype="id" generator="native";
	property name="Name" notnull="true" default="" unique="true";
	property name="Entity" notnull="true" default="";
	property name="Action" notnull="true";
	property name="Type" type="numeric" length=1 default="0"; 
	property name="Condition" default="";

	this.TYPE = {
		INSTANCE = 0,
		CLASS = 1
	};

	public function setType(required string type) {
		if(!this.type.keyexists(arguments.type)) {
			throw(type="CFRBAC.Permission.InvalidType", message="'#arguments.type#' is not a valid permission type");
		}
		variables.type = this.type[arguments.type];
		return this;
	}
	
	public function getType() {
		if(isNull(variables.type)) variables.type = 0;
		return this.TYPE.findValue(variables.type)[1].key;
	}

}
