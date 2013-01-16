component implements="coldspring.aop.MethodInterceptor,coldspring.beans.factory.BeanFactoryAware" output="false"{


	function init(string SessionManagerBeanName, string GetUserMethodName) {
		structAppend(variables, arguments);
		return this;
	}

	function invokeMethod(required coldspring.aop.methodinvocation methodInvocation) output="false" {
		var md = methodInvocation.getMethod().getMeta();
		var args = methodInvocation.getArguments();
		var action = md["can:action"];
		
		if(structKeyExists(md, "can:target-arg")) {
			var target_arg_name = md["can:target-arg"];
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
		
		writeDump(action);
		writeDump(getUser().can("list", "Forum"));
		abort;
	}


	public void function setBeanFactory(required coldspring.beans.beanfactory beanfactory) output=false {
		variables.beanfactory = arguments.beanfactory;
	}

	private function getUser() {
		return beanFactory.getBean(SessionManagerBeanName)[GetUserMethodName]();		
	}

}
