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

	main(){
		try {
			this.execute() ;
		} catch(err){
			return err.code
		}
	}

	execute(){
		console.log("[Error] Operation.execute must be override\n") ;
		return 0 ;
	}

	cancel(){
		_cancel() ;
	}
}

function _exec_operation(op)
{
	op.main() ;
}

