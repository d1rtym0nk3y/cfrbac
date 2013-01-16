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
		perm.setType(form.type);
		perm.setCondition(form.condition);
		entitySave(perm);
	}
	location("perms.cfm?id=#perm.getid()#", false);
}

perms = ormExecuteQuery("
	from CFRBAC_Permission p
	order by p.Entity, p.Action
");

entities = listToArray(structKeyList(ormGetSessionFactory().getAllClassMetadata()));
arraySort(entities, "textnocase");
</cfscript>

<tag:layout>
	
	<style>
		.nav-pills li {
			overflow: hidden;
		}
		
	</style>
<cfoutput>	
<h2>Permissions</h2>	
<div class="row">
	<div class="span3">
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
						<select name="entity" id="entity" class="chzn-select input-xlarge">
							<cfloop array="#entities#" index="e">
								<option value="#e#">#e#</option>
							</cfloop>
							<option value="">Other</option>
						</select>
						<input name="entity" type="text" class="input-xlarge" style="display:none;" id="entity_other" value="#perm.getEntity()#">
					</div>
				</div>

				<div class="control-group">
					<label class="control-label" for="action">Action</label>
					<div class="controls">
						<input name="action" type="text" class="input-xlarge" id="_action" value="#perm.getAction()#">
					</div>
				</div>

				<div class="control-group">
					<label class="control-label" for="object">Object or Class</label>
					<div class="controls">
						<select name="type" class="chzn-select input-xlarge" id="type">
							<option<cfif perm.getType().equals('INSTANCE')> selected</cfif> value="INSTANCE">Object Instance</option>
							<option<cfif !perm.getType().equals('CLASS')> selected</cfif> value="CLASS">Class</option>
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
$("#entity").bind("change", function() {
	var sel = $(this);
	if(sel.val()=="") {
		$("#entity_other").show();
	}
	else {
		$("#entity_other").hide();
	}
})

</script>

