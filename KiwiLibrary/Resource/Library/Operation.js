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

 function _cancel()
 {
 	throw new CancelException(ExitCode.exception) ;
 }

 function _exec_cancelable(fn, ...args)
 {
 	try {
 		return fn(...args) ;
 	} catch(err) {
 		return err.code ;
 	}
 }
 
