/*
 * Process.ts
 */

/// <reference path="types/Builtin.d.ts"/>

function _waitUntilExitOne(process: _Process): number
{
	while(!process.didFinished) {
		/* wait until exit */
	}
	return process.exitCode ;
}

function _waitUntilExitAll(processes: _Process[]): number
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
	mValue: _Dictionary ;

	constructor(initval: number) {
		this.mValue = Dictionary() ;
		this.mValue.set("count", initval) ;
	}

	signal() {
		let val = this.mValue.get("count") ;
		this.mValue.set("count", val - 1) ;
	}

	wait() {
		while(true) {
			let count = this.mValue.get("count") ;
			if(count >= 0) {
				sleep(0.1) ;
			} else {
				break ;
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

function openPanel(title: string, type: number, exts: string[]): _URL | null {
	let result = null ;
	let sem    = new Semaphore(0) ;
	let cbfunc = function(url: _URL) {
		result = url ;
		sem.signal() ;  // Tell finish operation
	} ;
	_openPanel(title, type, exts, cbfunc) ;
	sem.wait() ; // Wait finish operation
	return result ;
}

function savePanel(title: string): _URL | null {
	let result = null ;
	let sem    = new Semaphore(0) ;
	let cbfunc = function(url: _URL) {
		result = url ;
		sem.signal() ;  // Tell finish operation
	} ;
	_savePanel(title, cbfunc) ;
	sem.wait() ; // Wait finish operation
	return result ;
}

function run(path: _URL | string | null,
				input: _File, output: _File, error: _File) {
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

