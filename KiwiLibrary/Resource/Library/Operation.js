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

	get(name){
		return _operation_core.get(name) ;
	}

	set(name, value){
		return _operation_core.set(name, value) ;
	}

	main(){
		try {
			this.execute() ;
		} catch(err){
			return err.code
		}
	}

	execute(){
		console.log("Operation.execute()\n") ;
		return 0 ;
	}

	cancel(){
		_cancel() ;
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
function _operation_main(operation)
{
	operation.main() ;
}
