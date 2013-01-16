import net.m0nk3y.cfrbac.util.*;

component {

	function init() {
		return this;
	}
	
	function perm() {
		return new PermissionBuilder(); 
	}
	
	function role() {
		return new RoleBuilder();
	}

}