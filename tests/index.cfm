<cfscript>
transaction {

	// create some actions	
	actions = {
		"create" = 1,
		"read" = 1,
		"update" = 1,
		"delete" = 1,
		"list" = 0
	};

	for(a in actions) {
		actions[a] = entityNew("Action", {name=a, object=actions[a]});
		entitySave(actions[a]);
	}
	
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
	for(a in actions) {
		p = entityNew("Permission", {type="Table", entity="Object", Action=actions[a]});
		entitySave(p);
	}
	
	
	// link perms to roles


	user = new tests.cfc.User();
	user.setUserName("Chris");
	entitysave(user);
	
	obj = new tests.cfc.Object();
	obj.setCreatedBy(user);
	entitySave(obj);
	
}


</cfscript>
