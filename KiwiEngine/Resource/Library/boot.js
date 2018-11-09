/* boot.js */

class CancelException extends Error
{
	constructor(code){
		this.code = code ;
		super("CancelException") ;
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

