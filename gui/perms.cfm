<cfimport taglib="tags" prefix="tag" />
<cfscript>
param name="url.id" default="0";
param name="form.save" default="false";
param name="form.delete" default="false";

perm = entityLoadByPK("CFRBAC_Permission",url.id);
if(isnull(perm)) perm = entityNew("CFRBAC_Permission");

if(form.delete) {
	transaction {
		entityDelete(perm);
	}
	location("perms.cfm", false);
}

if(form.save) {
	transaction {
		perm.setEntity(form.entity);
		perm.setAction(form.action);
		perm.setObject(form.object);
		perm.setCondition(form.condition);
		entitySave(perm);
	}
	location("perms.cfm?id=#perm.getid()#", false);
}

perms = ormExecuteQuery("
	from CFRBAC_Permission p
	order by p.Entity, p.Action
");

</cfscript>

<tag:layout>
<cfoutput>	
<h2>Permissions</h2>	
<div class="row">
	<div class="span2">
		<ul class="nav nav-pills nav-stacked">
			<li<cfif url.id is 0> class="active"</cfif>><a href="perms.cfm">New Permission</a></li>
			<li class="nav-header">Existing Permissions</li>
			<cfloop array="#perms#" index="p">
			<li<cfif url.id is p.getId()> class="active"</cfif>><a href="perms.cfm?id=#p.getID()#">#p.getEntity()#:#p.getAction()#</a></li>
			</cfloop>
		</ul>
	</div>
	
	<div class="span9">

		<form class="form-horizontal" method="post" action="perms.cfm?id=#url.id#">
			<fieldset>
				<legend><cfif isNull(perm.getID())>New Permission<cfelse>Edit Permission</cfif></legend>
				<div class="control-group">
					<label class="control-label" for="entity">Entity</label>
					<div class="controls">
						<input name="entity" type="text" class="input-xlarge" id="entity" value="#perm.getEntity()#">
					</div>
				</div>

				<div class="control-group">
					<label class="control-label" for="action">Action</label>
					<div class="controls">
						<input name="action" type="text" class="input-xlarge" id="action" value="#perm.getAction()#">
					</div>
				</div>

				<div class="control-group">
					<label class="control-label" for="object">Object or Class</label>
					<div class="controls">
						<select name="object" class="chzn-select input-xlarge" id="object">
							<option<cfif perm.getObject()> selected</cfif> value="true">Object Instance</option>
							<option<cfif !perm.getObject()> selected</cfif> value="false">Class</option>
						</select>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label" for="condition">Condition</label>
					<div class="controls">
						<textarea name="condition" class="input-xlarge" id="condition" rows="4">#perm.getCondition()#</textarea>
					</div>
				</div>

				<div class="form-actions">
		            <button name="save" type="submit" class="btn btn-primary" value="true">Save changes</button>
            		<button class="btn">Cancel</button>
					<cfif NOT isNull(perm.getID())>
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

