<cfscript>
public boolean function can(required string action, required any target) {
	var func = function(required string action, required any target) cachedwithin="#createtimespan(0,0,0,10)#"  {
		var subject = this;
		var passed = false;
		var self = false;
		var type = 0; // instance
	
		// target might be the name of the entity, for example if this is a List action
		if(isSimpleValue(target)) {
			var targetClassName = target;
			var type = 1; //class
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
			and perms.Type = :type
		", 
		{
			subject=subject,
			action=lcase(action),
			targetClassName=lcase(targetClassName),
			type = type
		});
		
		if(arraylen(perms) == 0) return false;
		
		for(var p in perms) {
			if(!len(p.getCondition())) {
				passed = true;
				break;
			} 
			try {
				passed = evaluate(p.getCondition());
				if(passed) break;
			}
			catch(any e) {
				passed = false;
			}
		}
		
		return yesnoformat(passed);
	};
	return func(action, target, this.getID());
}	
	
	

public boolean function cannot(required string action, required any target) {
	return !can(action, taget);
}

/**
* @hint utility function to compare to entity instances, if only one argument is supplied it compares it to `this`
*/
public boolean function equals(a,b=this) {
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

