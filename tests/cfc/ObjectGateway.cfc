component {

	/**
	* @can:after read
	*/
	function get(id) {
		return entityLoadByPK("Object", id);
	}
	
	/**
	* @can:filter read
	*/
	function getAll() {
		return entityload("Object");	
	}
	
	/**
	* @can:before list:Object:object
	*/
	function update(required Object object, required struct data) {
		for(var k in data) {
			if(structKeyExists(object, "set#k#")) {
				object["set#k#"](data[k]);
			}
		}
		return object;
	}
	
}