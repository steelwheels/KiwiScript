/* boot.js */

class ExitError extends Error
{
	constructor(code, message){
		super(message) ;
		this.code = code ;
	}
}

function _exit(code)
{
	throw new ExitError(code, "exit") ;
}

function _exec(fn)
{
	try {
		return fn() ;
	} catch(err) {
		return err.code ;
	}
}
