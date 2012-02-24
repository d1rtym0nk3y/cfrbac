component {

	this.name = "cfrbac_tests";
	
	this.ormenabled = true;
	this.datasource = "cfrbac";
	this.enableRobustException = false;
	this.ormsettings = {
		cfclocation = ["/net/m0nk3y/cfrbac/entity", "/tests/cfc"],
		automanageSession = false,
		flushatrequestend = false,
		dialect = "MySQL",
		eventhandling = true,
		autorebuild = true,
		dbcreate = "dropcreate",
		skipCFCWithError = false
	};
	
	function onRequestStart()  {
		if(!isNull(url.reload)) reload(); 
		
	}
	
	private function reload() {
		ormreload();
	}
	
}
