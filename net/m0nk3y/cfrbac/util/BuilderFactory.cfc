import net.m0nk3y.cfrbac.util.*;

component {

	function init() {
		return this;
	}
	
	function perm(perm) {
		return new PermissionBuilder(argumentCollection=arguments); 
	}
	
	function role(role) {
		return new RoleBuilder(argumentCollection=arguments);
	}

}