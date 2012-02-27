component extends="mxunit.framework.TestCase" {

	function beforeTests() {
		include "setupDB.cfm";
	}

	function testUserCanCreateReadAndListObject() {
		for(var action in listToArray("create,read")) {
			assertTrue(users.user.can(action, obj), "user can not #action# obj");
		}
	}

	function testUserCanNotDeleteOrUpdateObjectTheDontOwn() {
		transaction {
			var newobj = new tests.cfc.Object();
			newobj.setCreatedBy(users.admin);
			entitySave(newobj);
		}
		for(var action in listToArray("delete,update")) {
			assertFalse(users.user.can(action, newobj), "user can #action# obj");
		}
	}
	function testUserCanDeleteObjectTheyCreated() {
		transaction {
			var newobj = new tests.cfc.Object();
			 newobj.setCreatedBy(users.user);
			 entitySave(newobj);
		}
		assertTrue(users.user.can("delete", newobj), "user can not delete obj they created");
	}	
	
	function testAdminCanCreateReadListDeleteAndUpdateObject() {
		for(var action in listToArray("create,read,delete,update")) {
			assertTrue(users.admin.can(action, obj), "admin can not #action# obj");
		}
	}
	
	function testInvalidActionNameIsDenied() {
		assertFalse(users.admin.can("eject", obj), "invalid action is allowed");
	}
	
	function testUsersCanUpdateThemselves() {
		var tmp = entityLoadByPK("User", users.user.getID());
		assertTrue(users.user.can("update", tmp));
	}
	function testUsersCanNotUpdateOtherUsers() {
		assertFalse(users.user.can("update", users.admin));
		assertFalse(users.user.can("update", users.both));
	}
	
	function testUserWithMultipleRoles() {
		for(var action in listToArray("create,read,delete,update")) {
			assertTrue(users.admin.can(action, obj), "admin can not #action# obj");
		}
	}
	
	function testCanNotCallNonObjectActionOnEntity() {
		assertFalse(users.user.can("list", obj), "You should not be able to list an entity instance");
		assertTrue(users.user.can("list", "Object"), "You should be able to list an entity specified by classname");
	}
	
	function testCompareFunction() {
		var tmp = entityLoadByPK("User", users.user.getID());
		var tmp2 = entityLoadByPK("User", users.user.getID());
		assertFalse(tmp._compare(tmp, javacast("null", 0)), "user should not equal null");
		assertFalse(tmp._compare(tmp, "summers day"), "user is not a summers day!");
		assertTrue(tmp._compare(tmp2));
	}
	
	function testMultiplePermissionsForSameEntityAndAction() {
		transaction {
			var p1 = entityNew("CFRBAC_Permission", {entity="Object", action="spin", condition="false"});
			entitysave(p1);
			var p2 = entityNew("CFRBAC_Permission", {entity="Object", action="spin", condition=""});
			entitysave(p2);
			roles.user.addPermission(p1);
			roles.user.addPermission(p2);
		}
		assertTrue(users.user.can("spin", obj), "user should be able to spin an object");	
	}
	
	function testWildcardEntityPermissions() {
		transaction {
			var rootUser = entityNew("User", {username='root'});
			var rootRole = entityNew("CFRBAC_Role", {name="root"});
			var wildcardObjectPerm = entityNew("CFRBAC_Permission", {entity="*", action="read", object=1});
			var wildcardClassPerm = entityNew("CFRBAC_Permission", {entity="*", action="list", object=0});
			entitySave(rootUser);
			entitySave(rootRole);
			entitySave(wildcardObjectPerm);
			entitySave(wildcardClassPerm);
			rootRole.addPermission(wildcardObjectPerm);
			rootRole.addPermission(wildcardClassPerm);
			rootUser.addRole(rootRole);
		}
		var object = entityNew("Object");
				
		assertTrue(rootUser.can("read", object), "root user should be able to read any entity");
		assertTrue(rootUser.can("read", rootuser), "root user should be able to read any entity");
		assertTrue(rootUser.can("list", "User"), "root user should be able to list any entity");
		assertTrue(rootUser.can("list", "Object"), "root user should be able to list any entity");
	}

	function testWildcardActionPermissions() {
		transaction {
			var rootUser = entityNew("User", {username='root'});
			var rootRole = entityNew("CFRBAC_Role", {name="root"});
			var wildcardObjectPerm = entityNew("CFRBAC_Permission", {entity="User", action="*", object=1});
			var wildcardClassPerm = entityNew("CFRBAC_Permission", {entity="Object", action="*", object=0});
			entitySave(rootUser);
			entitySave(rootRole);
			entitySave(wildcardObjectPerm);
			entitySave(wildcardClassPerm);
			rootRole.addPermission(wildcardObjectPerm);
			rootRole.addPermission(wildcardClassPerm);
			rootUser.addRole(rootRole);
		}
		assertTrue(rootUser.can("read", rootuser), "user should be able to read Users");
		assertTrue(rootUser.can("list", "Object"), "user should be able to list Objects ");		
		assertTrue(rootUser.can("destroy", "Object"), "user should be able to destroy Objects ");
		
	}
	

}

