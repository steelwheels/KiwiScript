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

function _exec(fn, ...args)
{
	try {
		return fn(...args) ;
	} catch(err) {
		console.log(err.message + "\n") ;
		return err.code ;
	}
}
