Simple Role Based Access Control for Coldfusion ORM
===================================================

_Currently a work in progress_
------------------------------

###The Basics

Give any entity that can perform actions, typically a User entity a property "Roles" (this will probably be configurable in the future) 
	
```ColdFusion
property name="Roles" fieldtype="many-to-many" 
	singularname="Role" cfc="net.m0nk3y.cfrbac.entity.CFRBAC_Role" 
	linktable="tests_UserRoles"; 
```

Then include a mixin that will provide the functions used to evaluate permissions

```ColdFusion
include "/net/m0nk3y/cfrbac/mixins/can.cfm"; 
```

Include "/net/m0nk3y/cfrbac/entity" in your applications orm cfclocations

```ColdFusion
this.ormsettings.cfclocation = ["/net/m0nk3y/cfrbac/entity", "/my/model/cfcs"]
```

Define some permissions and assign them to roles. Then assign your roles to your users.  See [setubDB.cfm](//github.com/d1rtym0nk3y/cfrbac/blob/master/tests/unit/setupDB.cfm) for some examples. 

Then you can start asking your entities if they have permission to perform an action

```ColdFusion
if(user.can("list", "Books")) {
  // do something
}
```
The _compare function is included by the mixin for easy comparison of entities, and returns true if the entities are the same

###Conditions
Permissions can have arbitrary conditions attached to them, conditions are a string that is evaluated when the can() function is run and should evaluate to true or false.  
Conditions have access to a few pre-defined variables

- ###self
if target == subject self will be true, this allows you to write conditions where a subject may only perform actions on themselves, by simply providing a condition of "self"

- ###target
The entity instance being acted upon

- ###subject
The entity instance performing the action

###Example Conditions

```ColdFusion
deleteOwnPostPermission = entityNew("CFRBAC_Permission", {
	entity="Post", 
	action="delete", 
	condition="_compare(subject, target.getCreatedBy())"
});
```

Its also posible to chain conditions.
Here's an example for a Forum entity, if the user can read the forum and the forum is not locked, then they can post 

```ColdFusion
readPermission = entityNew("CFRBAC_Permission", {
	entity="Forum", 
	action="read", 
	condition="target.isPublic(1)"
});

postPermission = entityNew("CFRBAC_Permission", {
	entity="Forum", 
	action="post", 
	condition="subject.can('read', target) && !target.isLocked()"
});
```

###Object or Class permission

Some permissions apply to a class of entity, rather than to a particular instance. For example a "list" action typically applies to a class of entities (a table) rather than an instance of an entity (a row). 
To create a permission that applies to a class rather than instance set object=false on the Permission

```ColdFusion
listPermission = entityNew("CFRBAC_Permission", {
	entity="Post", 
	action="list",
	object=false 
});

// now rather than pass an entity instance to can(), pass the classname
if(user.can("list", "Post")) {
	// do something
}
```

 ###Wildcard Permissions
 
As a convenience you can use a wildcard (*) for either the Entity, Action or both.  
  
 ```ColdFusion
doItAllPermission = entityNew("CFRBAC_Permission", {
	entity="*", 
	action="*",
	object=true 
}); 
listAnythingPermission = entityNew("CFRBAC_Permission", {
	entity="*", 
	action="list",
	object=false 
}); 
 ```
