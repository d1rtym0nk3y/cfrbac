<cfscript>
function can(action, target) {
	var subject = this;
	var passed = false;
	var self = false;
	var object = true;

	// target might be the name of the entity, for example if this is a List action
	if(isSimpleValue(target)) {
		var targetClassName = target;
		var object = false;
	}
	// its an instance of an entity
	else {	
		var md = getMetaData(target);
		var targetClassName = structKeyExists(md, "entityname") ? md.entityname : listlast(md.fullname, ".");
		// if target is an instance, is it ourself
		var self = _compare(target);
	}
	
	var md = getMetaData(subject);
	var subjectClassName = structKeyExists(md, "entityname") ? md.entityname : listlast(md.fullname, ".");
	
	var perms = ormExecuteQuery("
		select perms
		from #subjectClassName# subject
		join subject.Roles roles
		join roles.Permissions perms
		where subject = :subject
		and (
			perms.Entity = :targetClassName
			or
			perms.Entity = '*'
		)
		and (
			perms.Action = :action
			or
			perms.Action = '*'
		)
		and perms.Object = :object
	", 
	{
		subject=subject,
		action=action,
		targetClassName=targetClassName,
		object = object
	});
	
	if(arraylen(perms) == 0) return false;
	
	for(var p in perms) {
		var con = p.getCondition();
		if(len(con)) {
			var passed = evaluate(con);
			if(passed) return true;
		}
		else {
			passed = true;
		}
	}
	
	return passed;
}	

function cannot(action, target) {
	return !can(action, taget);
}

/**
* @hint utility function to compare to entity instances, if only one argument is supplied it compares it to `this`
*/
function _compare(a,b=this) {
	if(isNull(a) && isNull(b)) return true;
	if(isnull(a) || isnull(b)) return false;
	try {
		return arrayfind([a], b);
	}
	catch(any e) {
		return false;
	}
}
</cfscript>

