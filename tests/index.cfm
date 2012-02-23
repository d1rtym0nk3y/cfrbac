<cfscript>
transaction {
	
	actions = {
		"list" = 0,
		"read" = 0,
		"write" = 0,
		"delete" = 0
	};

	for(a in actions) {
		actions[a] = entityNew("Action", {name=a});
		entitySave(actions[a]);
	}
	
	for(a in actions) {
		ea = entityNew("EntityAction", {entity="Object", Action=actions[a]});
		entitySave(ea);
	}
	
	roles = {
		"user" = 0,
		"admin" = 0
	};
	
	for(r in roles) {
		roles[r] = entityNew("Role", {name=r});
		entitySave(roles[r]);
	}
	
	// create perms
	
	// link perms to roles


	user = new tests.cfc.User();
	user.setUserName("Chris");
	entitysave(user);
	
	obj = new tests.cfc.Object();
	obj.setCreatedBy(user);
	entitySave(obj);
	
}


</cfscript>
