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
		assertFalse(users.user.can("list", obj));
		assertTrue(users.user.can("list", "Object"));
	}
	

	

}

