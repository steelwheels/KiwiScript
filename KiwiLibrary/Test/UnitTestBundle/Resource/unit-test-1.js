/* unit-test-1.js */

class Machine extends Operation
{
	execute(){
		console.log("[Machine] Hello, world");
	}
} ;

operation = new Machine() ;

