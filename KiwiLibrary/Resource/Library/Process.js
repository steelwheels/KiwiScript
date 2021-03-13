/* Process.js */

function _waitUntilExitOne(process)
{
	while(!process.didFinished) {
		/* wait until exit */
	}
	return process.exitCode ;
}

function _waitUntilExitAll(processes)
{
	let ecode = 0 ;
	for(process of processes) {
		let state = _waitUntilExitOne(process) ;
		if(state != 0){
			ecode = state ;
		}
	}
	return ecode ;
}

class Semaphore {
	constructor(initval) {	// (Int)
		this.mValue = new Dictionary() ;
		this.mValue.set("count", initval) ;
	}

	signal() {
		let val = this.mValue.get("count") ;
		this.mValue.set("count", val - 1) ;
	}

	wait() {
		while(true) {
			let count = this.mValue.get("count") ;
			if(count < 0) {
				break ;
			}
		}
	}
}

function openPanel(title, type, exts) {
	let result = null ;
	let sem    = new Semaphore(0) ;
	let cbfunc = function(url) {
		result = url ;
		sem.signal() ;  // Tell finish operation
	} ;
	_openPanel(title, type, exts, cbfunc) ;
	sem.wait() ; // Wait finish operation
	return result ;
}

