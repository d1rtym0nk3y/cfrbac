<cfparam name="URL.output" default="extjs">
<cfparam name="URL.quiet" default="false">

<cfset dir = expandPath("/tests/unit")>
<cfoutput><h1>#dir#</h1></cfoutput>

<cfset DTS = createObject("component","mxunit.runner.DirectoryTestSuite")>
<cfinvoke component="#DTS#"
  method="run"
  directory="#dir#"
  recurse="true"
  returnvariable="Results"
  componentPath="tests.unit" />

<cfif NOT URL.quiet>
  <cfif NOT StructIsEmpty(DTS.getCatastrophicErrors())>
    <cfdump var="#DTS.getCatastrophicErrors()#" expand="false" label="#StructCount(DTS.getCatastrophicErrors())# Catastrophic Errors">
  </cfif>

  <cfsetting showdebugoutput="true">
  <cfoutput>#results.getResultsOutput(URL.output)#</cfoutput>
</cfif>
