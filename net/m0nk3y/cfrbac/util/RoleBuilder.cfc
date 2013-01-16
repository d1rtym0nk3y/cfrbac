import net.m0nk3y.cfrbac.entity.*;

component {

	function init() {
		variables.role = new CFRBAC_Role();
		return this;
	}
	
	function name(required string name) {
		variables.role.setName(arguments.name);
		return this;
	}
	
	function add(required any perms) {
		if(isInstanceOf(arguments.perms, "CFRBAC_Permission")) {
			addPerm(perms);
		}
		if(isArray(arguments.perms)) {
			for(var p in perms) {
				addPerm(p);				
			}
		}
		return this;
	}
	
	private function addPerm(required CFRBAC_Permission perm) {
		if(!variables.role.hasPermission(perm)) {
			variables.role.addPermission(perm);
		}
	}
	
	
	function save() {
		transaction {
			entitySave(variables.role);
		}
		return variables.role;
	}	
	
}