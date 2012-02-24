Simple Role Based Access Control for Coldfusion ORM
===================================================

_Currently a work in progress_
------------------------------

###The Basics

Give any entity that can perform actions, typically a User entity a property "Roles" (this will probably be configurable in the future) 
	
```ColdFusion
property name="Roles" fieldtype="many-to-many" 
	singularname="Role" cfc="net.m0nk3y.cfrbac.entity.Role" 
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

###Conditions
Permissions can have arbitrary conditions attached to them, conditions are a string that is evaluated when the can() function is run.  It has access to a few defined variables

- ###self
if target == subject self will be true, this allows you to write conditions where a subject may only perform actions on themselves, by simply providing a condition of "self"

- ###target
The entity instance being acted upon

- ###subject
The entity instance performing the action

###Example Condition

```ColdFusion
_compare(subject, target.getCreatedBy())
```
The _compare function is included by the mixin for easy comparison of entities

