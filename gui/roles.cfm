<cfimport taglib="tags" prefix="tag" />
<cfscript>
param name="url.id" default="0";
param name="form.save" default="false";
param name="form.delete" default="false";
param name="form.perms" default="";

role = entityLoadByPK("CFRBAC_Role",url.id);
if(isnull(role)) role = entityNew("CFRBAC_Role");

if(form.delete) {
	transaction {
		entityDelete(role);
	}
	location("roles.cfm", false);
}

if(form.save) {
	transaction {
		role.setName(form.name);
		role.setPermissions([]);
		for(p in listtoArray(form.perms)) {
			role.addPermission(entityLoadByPK("CFRBAC_Permission", p));
		}
		entitySave(role);
	}
	location("roles.cfm?id=#role.getid()#", false);
}

roles = ormExecuteQuery("
	from CFRBAC_Role r
	order by r.Name	
");

perms = ormExecuteQuery("
	from CFRBAC_Permission p
	order by p.Entity, p.Action
");

</cfscript>

<tag:layout>
<cfoutput>	
<h2>Roles</h2>	
<div class="row">
	<div class="span2">
		<ul class="nav nav-pills nav-stacked">
			<li<cfif url.id is 0> class="active"</cfif>><a href="roles.cfm?id=0">New Role</a></li>
			<li class="nav-header">Existing Roles</li>
			<cfloop array="#roles#" index="r">
			<li<cfif url.id is r.getId()> class="active"</cfif>><a href="roles.cfm?id=#r.getID()#">#r.getName()#</a></li>
			</cfloop>
		</ul>
	</div>
	
	<div class="span9">

		<form class="form-horizontal" method="post" action="roles.cfm?id=#url.id#">
			<fieldset>
				<legend><cfif isNull(role.getID())>New Role<cfelse>Edit Role</cfif></legend>
				<div class="control-group">
					<label class="control-label" for="name">Name</label>
					<div class="controls">
						<input name="name" type="text" class="input-xlarge" id="name" value="#role.getName()#">
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="perms">Permissions</label>
					<div class="controls">
						<select name="perms" class="chzn-select input-xlarge" id="perms" multiple="multiple" size="4" style="width:500px;" data-placeholder="Select permissions">
						<cfloop array="#perms#" index="p">
							<option <cfif role.hasPermission(p)> selected="selected" </cfif>value="#p.getID()#">#p.getEntity()# / #p.getAction()#</option>
						</cfloop>
						</select>
					</div>
				</div>
				<div class="form-actions">
		            <button name="save" type="submit" class="btn btn-primary" value="true">Save changes</button>
            		<button class="btn">Cancel</button>
					<cfif NOT isNull(role.getID())>
		            <button name="delete" type="submit" class="btn btn-danger pull-right" value="true">Delete</button>
					</cfif>
					
				</div>				
			</fieldset>
		</form>		
		
	</div>
</div>
	
</cfoutput>
</tag:layout>

<script type="text/javascript">
$(".chzn-select").chosen();
</script>

