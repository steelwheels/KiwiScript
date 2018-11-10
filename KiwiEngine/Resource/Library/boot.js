/* boot.js */

class CancelException extends Error
{
	constructor (code){
		super("CancelException") ;
		this.code = code ;
	}
}

function _cancel(code)
{
	throw new CancelException(code) ;
}

function _exec_cancelable(fn, ...args)
{
	try {
		return fn(...args) ;
	} catch(err) {
		return err.code ;
	}
}


