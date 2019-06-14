/* unit-test-1.js */

class Machine extends Operation
{
	execute(){
		console.log("[Machine] Hello, world\n");
	}
} ;

operation = new Machine() ;

