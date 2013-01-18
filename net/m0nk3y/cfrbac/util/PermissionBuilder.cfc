import net.m0nk3y.cfrbac.entity.*;

component {

	function init(perm) {
		if(isNull(perm)) {
			variables.perm = new CFRBAC_Permission();
		}
		else {
			variables.perm = arguments.perm;
		}
		return this;
	}
	
	function name(required string name) {
		variables.perm.setName(arguments.name);
		return this;
	}
	
	function entity(required string entity) {
		variables.perm.setEntity(arguments.entity);
		return this;
	}
	
	function action(required string action) {
		variables.perm.setAction(arguments.action);
		return this;
	}
	
	function instance() {
		variables.perm.setType("INSTANCE");
		return this;
	}
	
	function class() {
		variables.perm.setType("CLASS");
		return this;
	}
	
	function type(required string type) {
		variables.perm.setType(arguments.type);
		return this;
	}
	
	function condition(required string condition) {
		variables.perm.setCondition(arguments.condition);
		return this;
	};
	
	function save() {
		transaction {
			entitySave(variables.perm);
		}
		return variables.perm;
	}


}