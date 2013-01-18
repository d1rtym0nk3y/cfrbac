import net.m0nk3y.cfrbac.util.*;

component {

	variables.factory = new BuilderFactory();

	function load(required string configfile) {
		var xml = xmlparse(fileread(configfile));
		var permcache = {};

		var perms = xmlsearch(xml,'/cfrbac/permissions/perm');
		perms.each(function(p) {
			var perm = p.xmlattributes;			
			param name="perm.name" default="#perm.action#_#perm.entity#";
			param name="perm.condition" default="";
			param name="perm.type" default="instance";
			perm.name = lcase(perm.name);
			perm.entity = lcase(perm.entity);
			perm.action = lcase(perm.action);
			
			var p = entityLoad("CFRBAC_Permission", {name=perm.name});
			if(arrayLen(p)) {
				p = factory.perm(p[1]); 
			}
			else {
				p = factory.perm();
			}			
			permcache[perm.name] = p
				.name(perm.name)
				.entity(perm.entity)
				.action(perm.action)
				.type(perm.type)
				.condition(perm.condition)
				.save();
			
		});
		
		
		var roles = xmlsearch(xml, "/cfrbac/roles/role");	
		roles.each(function(r) {
			var rolename = lcase(r.xmlattributes.name);
			var roles = entityLoad("CFRBAC_Role", {name=rolename});
			if(arraylen(roles)) {
				var role = roles[1];
				role.setPermissions([]);
				role = factory.role(role);
			}
			else {
				var role = factory.role();	
			}
			role.name(rolename);
			var perms = xmlsearch(r, "permissions/perm");
			perms.each(function(p) {
				var permname = lcase(p.xmlattributes.name);
				if(structKeyExists(permcache, permname)) {
					role.add(permcache[permname]);	
				}
				else {
					throw("Permission #permname# does not exist");
				}
			});
			role.save();
		});
			
		
		
	}
	

}