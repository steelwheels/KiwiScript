/* unit-test-1.js */

class Machine extends Operation {
	execute(){
		console.log("[Operaion.execute] Hello, world\n");
	}
} ;

operation = new Machine();

