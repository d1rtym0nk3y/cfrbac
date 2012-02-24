<cfscript>
ormReload();
transaction {

	// create some actions
	actions = {
		"create" = 1,
		"read" = 1,
		"update" = 1,
		"delete" = 1,
		"list" = 0
	};

	// some simple roles
	roles = {
		"user" = 0,
		"admin" = 0
	};
	
	for(r in roles) {
		roles[r] = entityNew("Role", {name=r});
		entitySave(roles[r]);
	}
	
	// create perms
	// add all permissions to the admin role
	perms = {};
	for(a in actions) {
		perms[a] = entityNew("Permission", {entity="Object", Action=a, object=actions[a]});
		entitySave(perms[a]);
		roles.admin.addPermission(perms[a]);
	}
	
	// add just create, read and list to the user role
	roles.user.addPermission(perms.create);
	roles.user.addPermission(perms.read);
	roles.user.addPermission(perms.list);

	// create an update-self permission and addit to the user role
	updateSelf = entityNew("Permission", {entity="User", action="update", condition="self"});
	entitysave(updateSelf); 
	roles.user.addPermission(updateSelf);
	
	deleteOwnObj = entityNew("Permission", {entity="Object", action="delete", condition="_compare(subject, target.getCreatedBy())"});
	entitysave(deleteOwnObj); 
	roles.user.addPermission(deleteOwnObj);
	
	// create a user for each role and assign them their corresponding role
	users = {};
	for(r in roles) {
		users[r] = new tests.cfc.User();
		users[r].setUserName(r);
		users[r].addRole(roles[r]);
		entitysave(users[r]);
	}
	
	// create a user with both user & admin roles
	users.both =  new tests.cfc.User();
	users.both.setUserName("both");
	users.both.addRole(roles.user);
	users.both.addRole(roles.admin);
	entitysave(users.both);
	
	// create an object owned by user
	obj = new tests.cfc.Object();
	obj.setCreatedBy(users.user);
	entitySave(obj);
	
}
</cfscript>
