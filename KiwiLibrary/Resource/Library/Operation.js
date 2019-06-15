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
		this.parameters = {} ;
	}

	setParameter(name, value){
		this.parameters[name] = value ;
	}

	parameter(name){
		return this.parameters[name] ;
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

function _set_operation(op, name, value)
{
	op.setParameter(name, value) ;
}

function _get_operation(op, name)
{
	return op.parameter(name) ;
}

function _exec_operation(op)
{
	op.main() ;
}

