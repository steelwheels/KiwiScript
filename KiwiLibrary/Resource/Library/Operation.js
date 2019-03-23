/*
 * Operation.js : Define Operation class
 */

 class CancelException extends Error
 {
 	constructor (code){
 		super("CancelException") ;
 		this.code = code ;
 	}
 }

function _cancel() {
	throw new CancelException(ExitCode.exception) ;
}

/* This class must be inherited */
class Operation
{
	constructor(){
	}

	get(command){
		console.log("Operation.get(" + command + ");\n") ;
		return null ;
	}

	set(command, value){
		console.log("Operation.set(" + command + ", " + value + ");\n") ;
	}

	execute(){
		try {
			this.main() ;
		} catch(err){
			return err.code
		}
	}

	main(){
		console.log("Operation.main()\n") ;
		return 0 ;
	}

	cancel(){
		_cancel() ;
	}

	get core() {
		return _operation_core ;
	}
}

/* Called by KLOperation class */
function _operation_set(operation, command, value)
{
	operation.set(command, value) ;
}

/* Called by KLOperation class */
function _operation_get(operation, command)
{
	return operation.get(command) ;
}

/* Called by KLOperation class */
function _operation_exec()
{
	operation.execute() ;
}
