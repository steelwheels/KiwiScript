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
		this.mValue = initval ;
		this.mLock  = Lock() ;
	}

	signal() {
		this.mLock.lock() ;
			this.mValue -= 1 ;
		this.mLock.unlock() ;
	}

	wait() {
		while(true) {
			let count = 0 ;
			this.mLock.lock() ;
				count = this.mValue ;
			this.mLock.unlock() ;
			if(count < 0) {
				break ;
			}
		}
		/* Discard lock resource */
		this.mLock.discard() ;
		this.mLock = null ;
	}
}
