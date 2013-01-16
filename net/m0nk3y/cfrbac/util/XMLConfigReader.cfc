import net.m0nk3y.cfrbac.util.*;

component {

	variables.factory = new BuilderFactory();

	function load(required string configfile) {
		var xml = xmlparse(fileread(configfile));
		var permcache = {};

		var perms = xmlsearch(xml,'/cfrbac/permissions/perm');
		perms.each(function(p) {
			var perm = p.xmlattributes;			
			param name="perm.name" default="#perm.action# #perm.entity#";
			param name="perm.condition" default="";
			param name="perm.type" default="instance";
			
			permcache[perm.name] = factory.perm()
				.name(perm.name)
				.entity(perm.entity)
				.action(perm.action)
				.type(perm.type)
				.save();
		});
		
		
		var roles = xmlsearch(xml, "/cfrbac/roles/role");	
		roles.each(function(r) {
			var role = factory.role().name(r.xmlattributes.name);
			var perms = xmlsearch(r, "permissions/perm");
			perms.each(function(p) {
				var name = p.xmlattributes.name;
				if(structKeyExists(permcache, name)) {
					role.add(permcache[name]);	
				}
				else {
					throw("Permission #name# does not exist");
				}
			});
			role.save();
		});
			
		
		
	}
	

}