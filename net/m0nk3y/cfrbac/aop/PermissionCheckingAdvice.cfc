component implements="coldspring.beans.factory.BeanFactoryAware" output="false"{


	function init(any User /*string SessionManagerBeanName, string GetUserMethodName*/) {
		structAppend(variables, arguments);
		return this;
	}

	function filterResults(required coldspring.aop.methodinvocation methodInvocation) {
		var md = methodInvocation.getMethod().getMeta();
		var results = methodInvocation.proceed();
		var tmp = [];
		var action = trim(md["can:filter"]);
		for(var r in results) {
			if(getUser().can(action, r)) {
				arrayappend(tmp, r);
			}	
		}
		return tmp;
	}

	function checkBefore(required coldspring.aop.methodinvocation methodInvocation) {
		var md = methodInvocation.getMethod().getMeta();
		var args = methodInvocation.getArguments();
		var check = listToArray(md["can:before"], ":");
		if(arraylen(check) == 3) {
			var action = check[1];
			var target_arg_name = check[3];
		}
		else if(arraylen(check) == 2) {
			var action = check[1];
			var target = check[2];
			var target_arg_name = "";
		}
		
		if(len(target_arg_name)) {
			// args might be named
			if(structKeyExists(args, target_arg_name)) {
				var target = args[target_arg_name];
			}
			// or just ordinal
			else {
				for(var i=1; i<=arraylen(md.parameters); i++) {
					if(md.parameters[i].name is target_arg_name) {
						target = args[i];
						break;
					}
				}
			}
		}
		if(getUser().can(action, target)) {
			return methodInvocation.proceed();
		}
		else {
			writeDump(getUser());
			writeDump(action);
			writeDump(target);
			abort;
			throw(type="CFRBAC.PermissionDeniedException", message="Permission Denied")
		}
	}

	public void function setBeanFactory(required coldspring.beans.beanfactory beanfactory) output=false {
		variables.beanfactory = arguments.beanfactory;
	}

	private function getUser() {
		return beanFactory.getBean(SessionManagerBeanName)[GetUserMethodName]();
	}

}
