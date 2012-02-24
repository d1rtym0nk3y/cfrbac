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
		var self = _compare(target, subject);
	}
	
	var md = getMetaData(subject);
	var subjectClassName = structKeyExists(md, "entityname") ? md.entityname : listlast(md.fullname, ".");
	
	var q = ormExecuteQuery("
		select perms
		from #subjectClassName# subject
		join subject.Roles roles
		join roles.Permissions perms
		where subject = :subject
		and perms.Entity = :targetClassName
		and perms.Action = :action
		and perms.Object = :object
	", 
	{
		subject=subject,
		action=action,
		targetClassName=targetClassName,
		object = object
	});
	
	if(arraylen(q) == 0) return false;
	
	var con = q[1].getCondition();
	if(len(con)) {
		var passed = evaluate(con);
	}
	else {
		passed = true;
	}
	
	return passed;
}	

function cannot(action, target) {
	return !can(action, taget);
}

/**
* @hint utility function to compare to entity instances
*/
function _compare(a,b) {
	return arrayfind([a], b);
}
</cfscript>

