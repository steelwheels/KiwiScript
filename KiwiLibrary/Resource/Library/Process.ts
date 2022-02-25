/*
 * Process.ts
 */

/// <reference path="types/Builtin.d.ts"/>

function _waitUntilExitOne(process: ProcessIF): number
{
	while(!process.didFinished) {
		/* wait until exit */
	}
	return process.exitCode ;
}

function _waitUntilExitAll(processes: ProcessIF[]): number
{
	let ecode = 0 ;
	for(let process of processes) {
		let state = _waitUntilExitOne(process) ;
		if(state != 0){
			ecode = state ;
		}
	}
	return ecode ;
}

class Semaphore
{
	mValue: ParametersIF ;

	constructor(initval: number) {
		this.mValue = Parameters() ;
		this.mValue.setNumber("count", initval) ;
	}

	signal() {
		let val = this.mValue.number("count") ;
		if(val != null){
			this.mValue.setNumber("count", val! - 1) ;
		} else {
			console.log("No count in Semaphore") ;
		}
	}

	wait() {
		while(true) {
			let count = this.mValue.number("count") ;
			if(count != null){
				if(count! >= 0) {
					sleep(0.1) ;
				} else {
					break ;
				}
			}
		}
	}
}

class CancelException extends Error
{
	code: number ;

	constructor (code: number){
		super("CancelException") ;
		this.code = code ;
	}
}

function _cancel() {
	throw new CancelException(ExitCode.exception) ;
}

function openPanel(title: string, type: number, exts: string[]): URLIF | null {
	let result = null ;
	let sem    = new Semaphore(0) ;
	let cbfunc = function(url: URLIF) {
		result = url ;
		sem.signal() ;  // Tell finish operation
	} ;
	_openPanel(title, type, exts, cbfunc) ;
	sem.wait() ; // Wait finish operation
	return result ;
}

function savePanel(title: string): URLIF | null {
	let result = null ;
	let sem    = new Semaphore(0) ;
	let cbfunc = function(url: URLIF) {
		result = url ;
		sem.signal() ;  // Tell finish operation
	} ;
	_savePanel(title, cbfunc) ;
	sem.wait() ; // Wait finish operation
	return result ;
}

function run(path: URLIF | string | null,
				input: FileIF, output: FileIF, error: FileIF) {
	if(path == null) {
		let newpath = openPanel("Select script file to execute", 
					FileType.file, ["js", "jsh", "jspkg"]) ;
		if(newpath != null) {
			path = newpath ;
		} else {
			return null ;
		}
	}
	return _run(path, input, output, error) ;
}

